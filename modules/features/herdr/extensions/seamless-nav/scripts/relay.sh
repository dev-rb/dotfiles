#!/usr/bin/env bash
#
# Manage seamless-nav's relay on the machine you type on (where herdr's client
# and WezTerm run), so remote machines on your tailnet can hand edges back.
#
#   relay.sh start | stop | restart | status | build
#
# start does nothing unless SEAMLESS_NAV_RELAY_ALLOW is set in the plugin's env
# file (`herdr plugin config-dir seamless-nav`), e.g. SEAMLESS_NAV_RELAY_ALLOW="my-vm".
# SEAMLESS_NAV_RELAY_LISTEN overrides the address (default tailscale:47100).

set -uo pipefail

if [ -n "${HERDR_PLUGIN_CONFIG_DIR:-}" ] && [ -f "$HERDR_PLUGIN_CONFIG_DIR/env" ]; then
  # shellcheck source=/dev/null
  . "$HERDR_PLUGIN_CONFIG_DIR/env"
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
bin="$root/bin/seamless-nav-relay"
state="${HERDR_PLUGIN_STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/seamless-nav}"
pidfile="$state/relay.pid"
logfile="$state/relay.log"

running() {
  local pid
  # The full command line: Linux truncates comm to 15 characters.
  pid="$(cat "$pidfile" 2>/dev/null)" && [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null &&
    ps -o command= -p "$pid" | grep -q seamless-nav-relay
}

build() {
  if ! command -v go >/dev/null 2>&1; then
    echo "relay: go is not on PATH; build with: (cd $root/relay && go build -o $bin .)" >&2
    return 1
  fi
  (cd "$root/relay" && go build -o "$bin" .)
}

# Rebuild when the binary is missing or older than its sources. Packaged
# copies (e.g. in the Nix store) ship only the binary.
stale() {
  [ ! -x "$bin" ] || {
    [ -d "$root/relay" ] &&
      [ -n "$(find "$root/relay" \( -name '*.go' -o -name go.mod \) -newer "$bin")" ]
  }
}

start() {
  if [ -z "${SEAMLESS_NAV_RELAY_ALLOW:-}" ]; then
    echo "relay: not configured (SEAMLESS_NAV_RELAY_ALLOW is unset)"
    return 0
  fi
  if running; then
    echo "relay: already running (pid $(cat "$pidfile"))"
    return 0
  fi
  if stale; then
    build || return 1
  fi
  mkdir -p "$state"
  # Detach from herdr's output pipes so this plugin command can finish.
  nohup "$bin" -navigate "$root/scripts/navigate.sh" \
    -allow "$SEAMLESS_NAV_RELAY_ALLOW" -listen "${SEAMLESS_NAV_RELAY_LISTEN:-tailscale:47100}" \
    </dev/null >>"$logfile" 2>&1 &
  echo $! >"$pidfile"
  echo "relay: started (pid $!), logging to $logfile"
}

stop() {
  if running; then
    kill "$(cat "$pidfile")"
    echo "relay: stopped"
  fi
  rm -f "$pidfile"
}

case "${1:-}" in
  start) start ;;
  stop) stop ;;
  restart)
    stop
    start
    ;;
  status)
    if running; then
      echo "relay: running (pid $(cat "$pidfile"))"
      tail -n 3 "$logfile" 2>/dev/null
    else
      echo "relay: not running"
    fi
    ;;
  build) build ;;
  *)
    echo "usage: relay.sh start|stop|restart|status|build" >&2
    exit 2
    ;;
esac
