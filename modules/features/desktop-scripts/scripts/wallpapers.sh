#!/bin/sh

# Favorites
# wallhaven-vq7ve5.jpg
# wallhaven-ly93ry.png
# wallhaven-3qkggv.jpg
# wallhaven-ex5jql.jpg
# wallhaven-3lvgg6.jpg

dir=${HOME}/wallpapers
img=wallhaven-3qkggv.jpg

# Wallpaper images stay user-owned; a missing image must not break startup.
if [ -f "$dir/$img" ]; then
	awww img "$dir/$img" --transition-type=wipe
fi
