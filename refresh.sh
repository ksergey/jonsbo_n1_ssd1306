#!/bin/bash

DEVICE="/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0"
NET_INTERFACE="wlan0"

if [ ! -e "${DEVICE}" ]; then
  echo "no \"${DEVICE}\" device found"
  exit 1
fi

stty -F "${DEVICE}" 115200 clocal -hup

ip=$(ifconfig "${NET_INTERFACE}" | grep "inet " | tr -s ' ' '\t' | cut -f 3)
date=$(date +"%T")

cat > "${DEVICE}" <<EOF
0# now: ${date}
1#  ip: ${ip}
EOF
