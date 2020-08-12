#!/bin/bash


## [Set VPN commands]. Setup for Mullvad is done below.
VPN_CONNECT="nordvpn connect"
VPN_DISCONNECT="nordvpn disconnect"
VPN_GET_STATUS="nordvpn status"

## [Set VPN status parsing]
VPN_STATUS=$(echo $(echo $(nordvpn status) | awk '{print $4}'))	# returns Connected/Disconnected/<other>
CONNECTED=Connected

VPN_CURRENT_COUNTRY=$(echo $(echo $(nordvpn status) | awk '{print $9}'))	# returns cOUNTRY TO WHICH VPN IS CONNECTED
VPN_CURRENT_CITY=$(echo $(echo $(nordvpn status) | awk '{print $11}'))	# returns CITY TO WHICH VPN IS CONNECTED

COLOR_CONNECTED=#4DC76E
COLOR_CONNECTING=#FF79C6
COLOR_DISCONNECTED=#FF5555

vpn_toggle_connection() {
# connects or disconnects vpn
    if [ "$VPN_STATUS" = "$CONNECTED" ]; then
        $VPN_DISCONNECT
    else
        $VPN_CONNECT
    fi
}

vpn_report() {
  if [ "$VPN_STATUS" = "$CONNECTED"  ]; then
		echo "%{F$COLOR_CONNECTED} $VPN_CURRENT_COUNTRY ($VPN_CURRENT_CITY)"
	elif [ "$VPN_STATUS" = "$CONNECTING" ]; then
		echo "%{F$COLOR_CONNECTING} Connecting"
	else
		echo "%{F$COLOR_DISCONNECTED} Disconnected"
	fi
}

case "$1" in
	--toggle-connection) vpn_toggle_connection ;;
	--location-menu) ~/.config/dmenu/nord-countries.sh ;;
	*) vpn_report ;;
esac
