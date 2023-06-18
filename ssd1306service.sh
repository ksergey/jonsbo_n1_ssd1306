#!/bin/bash

Device="/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0"
UpdateDelay=5s

if [ ! -e "${Device}" ]; then
  echo "no \"${Device}\" device found"
  exit 1
fi

function updateDisplay {
  local IFs=( $(ip -4 -o addr | tr -s ' /' '\t\t' | cut -f 2 | xargs echo) )
  local IPs=( $(ip -4 -o addr | tr -s ' /' '\t\t' | cut -f 4 | xargs echo) )

  for index in ${!IFs[*]}; do
    local iface=${IFs[$index]}
    local ip=${IPs[$index]}

    cat > "${Device}" <<EOF
0# dev: ${iface}
1#  ip: ${ip}
EOF
    sleep ${UpdateDelay}
  done
}

function displayInit {
  cat > "${Device}" <<EOF
0# wait...
1#
EOF
}

# setup device
stty -F "${Device}" 115200 clocal -hup

displayInit
sleep 1s
displayInit
sleep 1s

while true; do
  updateDisplay
done
