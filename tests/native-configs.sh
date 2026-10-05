#!/usr/bin/env bash
set -euo pipefail
repo_root=${1:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}

while IFS= read -r -d '' file; do
  luac -p "$file"
done < <(find "$repo_root/modules/features" -name '*.lua' -print0)
lua "$repo_root/tests/wezterm.lua" "$repo_root"
bash "$repo_root/tests/desktop-scripts.sh" "$repo_root"
for file in "$repo_root/modules/features/desktop-scripts/scripts/"*.sh "$repo_root/modules/features/waybar/config/reload.sh"; do
  sh -n "$file"
done

# Parse and apply tmux configuration without a terminal or any user configuration.
work=$(mktemp -d)
socket="$work/tmux.sock"
trap 'tmux -S "$socket" kill-server >/dev/null 2>&1 || true; rm -rf "$work"' EXIT
export SHELL=$(command -v bash)
printf 'set -g exit-empty off\n' > "$work/bootstrap.conf"
tmux -S "$socket" -f "$work/bootstrap.conf" start-server
tmux -S "$socket" source-file "$repo_root/modules/features/tmux/tmux.conf"
test "$(tmux -S "$socket" show-options -gv mouse)" = on
test "$(tmux -S "$socket" show-options -gv status-position)" = top
printf 'Native configuration checks passed without activation.\n'
