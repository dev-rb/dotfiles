#!/bin/sh
# Apply the selected user-owned wallpaper from ~/wallpapers using awww.
# The awww daemon must already be running; this helper only sets the image.

# Candidate filenames; change img below to select another wallpaper.
# wallhaven-vq7ve5.jpg
# wallhaven-ly93ry.png
# wallhaven-3qkggv.jpg
# wallhaven-ex5jql.jpg
# wallhaven-3lvgg6.jpg

# Keep images outside the Nix store so the user can manage them separately.
dir=${HOME}/wallpapers
img=wallhaven-3qkggv.jpg

# Wallpaper images stay user-owned; a missing image must not break startup.
if [ -f "$dir/$img" ]; then
	awww img "$dir/$img" --transition-type=wipe
fi
