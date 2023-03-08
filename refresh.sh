#!/bin/bash

# DEVICE=/dev/ttyUSB0
DEVICE="/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0"
NET_INTERFACE="wlan0"

stty -F "${DEVICE}" cs8 115200 ignbrk

ip=$(ifconfig "${NET_INTERFACE}" | grep "inet " | tr -s ' ' '\t' | cut -f 3)
date=$(date +"%T")

cat > "${DEVICE}" <<EOF
0# now: ${date}
1#  ip: ${ip}
EOF
