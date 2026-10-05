#!/usr/bin/env bash
set -euo pipefail
repo_root=${1:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/bin" "$work/home with spaces/wallpapers"
export HOME="$work/home with spaces" CALL_LOG="$work/calls"
export PATH="$work/bin:$PATH"

printf '#!/bin/sh\nif [ "$1" = get-volume ]; then printf "%%s\\n" "$WPCTL_VOLUME"; fi\n' > "$work/bin/wpctl"
printf '#!/bin/sh\nif [ "$1" = -G ]; then printf "42\\n"; fi\n' > "$work/bin/brillo"
for tool in notify-send dunstify awww; do
  printf '#!/bin/sh\nprintf "%%s\\n" "$(basename "$0")" "$@" >> "$CALL_LOG"\n' > "$work/bin/$tool"
done
chmod +x "$work/bin/"*

for volume in 'Volume: 0.00' 'Volume: 0.65' 'Volume: 1.20' 'Volume: 0.00 [MUTED]'; do
  export WPCTL_VOLUME="$volume"
  for action in up down mute; do
    sh "$repo_root/modules/features/desktop-scripts/scripts/volume.sh" "$action" 2> "$work/errors"
    test ! -s "$work/errors"
  done
done
sh "$repo_root/modules/features/desktop-scripts/scripts/brightness.sh" up
sh "$repo_root/modules/features/desktop-scripts/scripts/brightness.sh" down

rm -f "$CALL_LOG"
sh "$repo_root/modules/features/desktop-scripts/scripts/wallpapers.sh"
test ! -e "$CALL_LOG"
touch "$HOME/wallpapers/wallhaven-3qkggv.jpg"
sh "$repo_root/modules/features/desktop-scripts/scripts/wallpapers.sh"
printf '%s\n' awww img "$HOME/wallpapers/wallhaven-3qkggv.jpg" --transition-type=wipe > "$work/expected"
cmp "$work/expected" "$CALL_LOG"
printf 'Desktop script checks passed with stubbed tools.\n'
