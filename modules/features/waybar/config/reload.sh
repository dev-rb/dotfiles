#!/bin/bash
# Start Waybar and reload it when files under ~/.config/waybar change.
# Requires inotifywait from inotify-tools; run this helper inside the desktop
# session so Waybar can connect to the compositor.

# Launch in the background so this process can wait for filesystem events.
waybar&

# Cleanup targets all processes named waybar, not just the one started here.
trap "killall waybar" EXIT

# Watch the expanded config paths recursively for creation/modification.
# SIGUSR2 asks every Waybar process to reload; stop if inotifywait fails.
while inotifywait -r -e create,modify ~/.config/waybar/*; do killall -SIGUSR2 waybar; done
