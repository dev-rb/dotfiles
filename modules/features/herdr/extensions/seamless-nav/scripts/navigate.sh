#!/usr/bin/env bash
#
# seamless-nav: Ctrl+h/j/k/l across Neovim splits, herdr panes and WezTerm panes.
#
#   navigate.sh <left|down|up|right>           herdr keybinding (plugin action)
#   navigate.sh edge <left|down|up|right>      Neovim and herdr are both at an edge
#   navigate.sh sidebar <left|right>           pressed while herdr's sidebar is open
#
# Per keypress:
#   1. The focused pane runs Vim/Neovim (or matches SEAMLESS_NAV_PASSTHROUGH_RE):
#      forward the key and let the app decide. smart-splits.nvim crosses back
#      into herdr at its own edge.
#   2. herdr has a neighbor in that direction: move herdr focus.
#   3. herdr is at its left edge: open herdr's workspace sidebar.
#   4. herdr is at its edge and this client runs inside a WezTerm pane with a
#      neighbor in that direction: move WezTerm focus.
#   5. Otherwise forward the key, so shell defaults (C-l clear, C-h backspace) work.
#
# In the sidebar, herdr handles Ctrl+J/K and Enter itself; Ctrl+L returns to the
# panes and Ctrl+H moves on to the WezTerm pane on the left.
#
# Adapted from smart-splits.nvim's scripts/herdr-navigate.sh (MIT, Mat Jones).
# The WezTerm handoff requires jq.

set -uo pipefail

# Optional settings, e.g. SEAMLESS_NAV_PASSTHROUGH_RE='^(lazygit|k9s)$'.
# `herdr plugin config-dir seamless-nav` prints the directory.
if [ -n "${HERDR_PLUGIN_CONFIG_DIR:-}" ] && [ -f "$HERDR_PLUGIN_CONFIG_DIR/env" ]; then
  # shellcheck source=/dev/null
  . "$HERDR_PLUGIN_CONFIG_DIR/env"
fi

mode=move
case "${1:-}" in
  edge | sidebar)
    mode=$1
    shift
    ;;
esac
dir="${1:-}"
herdr="${HERDR_BIN_PATH:-herdr}"
pane="${HERDR_PANE_ID:-}"

case "$dir" in
  left) key=ctrl+h wez_dir=Left ;;
  down) key=ctrl+j wez_dir=Down ;;
  up) key=ctrl+k wez_dir=Up ;;
  right) key=ctrl+l wez_dir=Right ;;
  *)
    echo "usage: navigate.sh [edge|sidebar] <left|down|up|right>" >&2
    exit 2
    ;;
esac

log() {
  if [ -n "${SEAMLESS_NAV_LOG:-}" ]; then
    printf '%s %s %s: %s\n' "$(date +%T)" "$mode" "$dir" "$*" >>"$SEAMLESS_NAV_LOG"
  fi
}

# Same matcher as vim-tmux-navigator and smart-splits: vi, vim, nvim, view, *diff, ...
vim_re='^g?(view|l?n?vim?x?)(diff)?$'
passthrough_re="${SEAMLESS_NAV_PASSTHROUGH_RE:-}"

# This runs on every keypress, so match herdr's compact JSON with bash instead
# of spawning jq (~13 ms each).
pane_wants_key() {
  local rest name
  rest="$("$herdr" pane process-info --current 2>/dev/null)" || return 1
  shopt -s nocasematch
  while [[ $rest =~ \"name\":\"([^\"]*)\" ]]; do
    name="${BASH_REMATCH[1]}"
    rest="${rest#*"${BASH_REMATCH[0]}"}"
    if [[ $name =~ $vim_re ]] || { [ -n "$passthrough_re" ] && [[ $name =~ $passthrough_re ]]; }; then
      shopt -u nocasematch
      return 0
    fi
  done
  shopt -u nocasematch
  return 1
}

forward_key() {
  log "forward $key to $pane"
  exec "$herdr" pane send-keys "$pane" "$key"
}

wezterm_bin() {
  if [ -n "${SEAMLESS_NAV_WEZTERM:-}" ]; then
    printf '%s\n' "$SEAMLESS_NAV_WEZTERM"
  elif command -v wezterm >/dev/null 2>&1; then
    command -v wezterm
  elif [ -x "${WEZTERM_EXECUTABLE_DIR:-}/wezterm" ]; then
    printf '%s\n' "$WEZTERM_EXECUTABLE_DIR/wezterm"
  elif [ -x /Applications/WezTerm.app/Contents/MacOS/wezterm ]; then
    printf '%s\n' /Applications/WezTerm.app/Contents/MacOS/wezterm
  else
    return 1
  fi
}

# Find the WezTerm pane hosting this herdr client; sets $wez and $host.
wez="" host=""
wezterm_host() {
  [ -n "$host" ] && return 0
  local client tty
  wez="$(wezterm_bin)" || return 1

  # The GUI client with the most recent input is the one this key came from.
  # Don't trust WEZTERM_PANE: herdr panes inherit it from whichever WezTerm
  # pane started the server, which goes stale after reattaching elsewhere.
  client="$("$wez" cli list-clients --format json 2>/dev/null |
    jq -r 'sort_by(.idle_time.secs, .idle_time.nanos) | .[0] // empty
      | "\(.focused_pane_id) \(.idle_time.secs * 1000 + (.idle_time.nanos / 1000000 | floor))"')"
  host="${client%% *}"
  if [ -z "$host" ]; then
    log "no wezterm client"
    return 1
  fi

  # Only use a pane that really hosts a herdr client, so herdr running in
  # another terminal never acts on a background WezTerm window.
  tty="$("$wez" cli list --format json 2>/dev/null |
    jq -r --argjson id "$host" '.[] | select(.pane_id == $id) | .tty_name // empty')"
  # macOS `pgrep -t` doesn't match terminals reliably, so ask ps.
  # shellcheck disable=SC2009
  if [ -z "$tty" ] || ! ps -o comm= -t "${tty#/dev/}" 2>/dev/null | grep -qE '(^|/)herdr$'; then
    log "wezterm pane $host does not host herdr"
    host=""
    return 1
  fi
}

# Move WezTerm focus away from the pane hosting this herdr client.
# Succeeds only when focus actually moved.
wezterm_handoff() {
  [ "${SEAMLESS_NAV_WEZTERM_HANDOFF:-1}" = 1 ] || return 1
  wezterm_host || return 1
  local neighbor
  neighbor="$("$wez" cli get-pane-direction "$wez_dir" --pane-id "$host" 2>/dev/null)"
  if [ -z "$neighbor" ]; then
    log "no wezterm pane $wez_dir of $host"
    return 1
  fi
  log "wezterm focus $host -> $neighbor"
  "$wez" cli activate-pane-direction "$wez_dir" --pane-id "$host" >/dev/null 2>&1
}

# Only herdr's own keybindings can focus its workspace sidebar, so type them
# into the herdr client through WezTerm. The default is Ctrl+B (as CSI-u) then
# w: the default prefix and workspace_picker bindings.
default_sidebar_keys='\x1b[98;5uw'
open_sidebar() {
  [ "${SEAMLESS_NAV_SIDEBAR:-1}" = 1 ] || return 1
  wezterm_host || return 1
  local keys
  keys="$(printf '%b' "${SEAMLESS_NAV_SIDEBAR_KEYS:-$default_sidebar_keys}")"
  log "open sidebar through wezterm pane $host"
  "$wez" cli send-text --no-paste --pane-id "$host" "$keys" >/dev/null 2>&1
}

case "$mode" in
  edge)
    if [ "$dir" = left ] && open_sidebar; then exit 0; fi
    wezterm_handoff
    exit
    ;;
  sidebar)
    # herdr has already closed the sidebar to run this binding, so Ctrl+L is
    # done. Ctrl+H moves on to WezTerm, or reopens the sidebar if nothing's there.
    log "leave sidebar"
    if [ "$dir" = left ] && ! wezterm_handoff; then
      open_sidebar
    fi
    exit 0
    ;;
esac

if [ -z "$pane" ]; then
  log "no focused pane"
  exit 0
fi

if pane_wants_key; then
  forward_key
fi

focus="$("$herdr" pane focus --direction "$dir" --current 2>/dev/null)"
if [[ $focus == *'"changed":true'* ]]; then
  log "herdr focus moved"
  exit 0
fi
if [[ $focus == *'"reason":"no_neighbor"'* ]]; then
  if [ "$dir" = left ] && open_sidebar; then exit 0; fi
  if wezterm_handoff; then exit 0; fi
fi
forward_key
