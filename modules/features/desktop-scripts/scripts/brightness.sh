#!/bin/sh
# Usage: brightness.sh up|down
# Adjust the current backlight by two percentage points with brillo, then
# show its new value through dunstify. Requires a running notification daemon.

# Reuse notification ID 9992 so repeated keypresses replace the same popup.
# The integer value hint supplies the notification's brightness progress bar.
send_notification() {
  brightness=$(printf "%.0f\n" "$(brillo -G)")
  space=$(printf "%64s");
	dunstify -a "Backlight" -u low -r 9992 -h int:value:"$brightness" -i "brightness" "Brightness $space $brightness%" "\n" -t 1000
}

# Apply the change before reading brightness for the notification.
case $1 in
	up)
		brillo -q -A 2
		send_notification "$1"
		;;
	down)
		brillo -q -U 2
		send_notification "$1"
		;;
esac
