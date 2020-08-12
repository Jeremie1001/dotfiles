#!/bin/bash

MUTE="pamixer -m"
UNMUTE="pamixer -u"
MUTED=true
MUTE_STATUS=$(echo $(pamixer --get-mute))

VOLUME_STATUS=$(echo $(pamixer --get-volume))
VOLUME_STATUS_HUMAN=$(echo $(pamixer --get-volume-human))

BARRIER_ONE=25
BARRIER_TWO=75

COLOR=#44475A

#format-muted-prefix = 
#ramp-volume-0 = 
#ramp-volume-2 = 
#ramp-volume-4 = 


mute_toggle () {
  if [ "$MUTE_STATUS" = "$MUTED" ]; then
      $UNMUTE
  else
      $MUTE
  fi
}

volume_increment_increase () {
  pamixer -i $1
}

volume_increment_decrease () {
  pamixer -d $1
}

volume_status () {
  if [ "$MUTE_STATUS" = "$MUTED" ]; then
    echo "%{F$COLOR} Muted"
  elif [ "$VOLUME_STATUS" -le "$BARRIER_ONE" ]; then
    echo "%{F$COLOR} $VOLUME_STATUS_HUMAN"
  elif [[ ("$VOLUME_STATUS" -gt "$BARRIER_ONE") && ("$VOLUME_STATUS" -le "$BARRIER_TWO") ]]; then
    echo "%{F$COLOR} $VOLUME_STATUS_HUMAN"
  else
    echo "%{F$COLOR} $VOLUME_STATUS_HUMAN"
  fi
}


case "$1" in
	--toggle-mute) mute_toggle ;;
  --volume-increase) volume_increment_increase $2 ;;
  --volume-decrease) volume_increment_decrease $2 ;;
  --volume-status) volume_status ;;
  *) volume_status ;;
esac
