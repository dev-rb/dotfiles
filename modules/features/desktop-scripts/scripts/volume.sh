#!/bin/sh
# Usage: volume.sh up|down|mute
# Control PipeWire's default output through wpctl and display a notification.
# Requires notify-send and a running desktop notification daemon.

# Up/down first unmute the output, then adjust by five percentage points.
# Raising volume is capped at 200%; mute toggles the current mute state.
case $1 in
	up)
		wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
		wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%+
		;;
	down)
		wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
		wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%-
		;;
	mute)
		wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
		;;
esac

# Read back the resulting volume and round it for display.
VOLUME=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ printf "%.0f", $2 * 100 }')

space=$(printf "%70s");

# Select an icon from the volume range, or show the explicit muted state.
send_notification() {
	if [ "$1" = "mute" ]; then ICON="mute"; elif [ "$VOLUME" -lt 33 ]; then ICON="low"; elif [ "$VOLUME" -lt 66 ]; then ICON="medium"; else ICON="high"; fi
	if [ "$1" = "mute" ]; then TEXT="Muted"; else TEXT="$space ${VOLUME}%"; fi

	notify-send -a "Volume" -u low -i "volume-$ICON" "Volume $TEXT" -t 2000
}

# A mute toggle can also unmute. Inspect the resulting state rather than
# always labeling the action as muted.
case $1 in
	mute)
		case "$(wpctl get-volume @DEFAULT_AUDIO_SINK@)" in
			*MUTED* ) send_notification mute;;
			*       ) send_notification;;
		esac;;
	*)
		send_notification;;
esac
