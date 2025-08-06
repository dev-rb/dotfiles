#!/bin/sh

send_notification() {
  brightness=$(printf "%.0f\n" "$(brillo -G)")
  space=$(printf "%64s");
	dunstify -a "Backlight" -u low -r 9992 -h int:value:"$brightness" -i "brightness" "Brightness $space $brightness%" "\n" -t 1000
}

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
