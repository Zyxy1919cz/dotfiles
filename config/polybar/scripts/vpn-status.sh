#!/usr/bin/sh

IFACE=$(ifconfig | grep cscotun | awk '{print $1}')

if [ "$IFACE" = "cscotun*" ]; then
    echo "%{u#55aa55}$(ifconfig cscotun0 | grep inet | awk '{print $2}' | cut -f2 -d ':')%{u-}"
else
    echo "%{F#FF0000}%{u#FF0000}VPN DISCONNECTED%{u-}%{F-}"
fi
