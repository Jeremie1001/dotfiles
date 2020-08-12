#!/bin/sh

cat <<EOF | xmenu | sh &
Applications
Terminal (xterm)	kitty
Terminal (urxvt)	urxvt
Terminal (st)		st

Shutdown		poweroff
Reboot			reboot
EOF
