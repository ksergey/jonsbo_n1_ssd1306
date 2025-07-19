#!/bin/bash

SCRIPT_PATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

Red='\033[0;31m'
Green='\033[0;32m'
Cyan='\033[0;36m'
Normal='\033[0m'

echo_text()
{
  printf "${Normal}$1${Cyan}\n"
}

echo_error()
{
  printf "${Red}$1${Normal}\n"
}

echo_ok()
{
  printf "${Green}$1${Normal}\n"
}

install_systemd_service()
{
  echo_text "Installing systemd unit file"

  mkdir -p ${HOME}/.config/systemd/user

cat > ${HOME}/.config/systemd/user/ssd1306.service <<EOF
[Unit]
Description=ssd1306 module helper
After=network.target

[Service]
Type=simple
WorkingDirectory=${SCRIPT_PATH}
ExecStart=/bin/bash ${SCRIPT_PATH}/ssd1306service.sh
Restart=always
RestartSec=15
KillSignal=SIGTERM

[Install]
WantedBy=default.target
EOF

  systemctl --user unmask ssd1306.service
  systemctl --user daemon-reload
  systemctl --user enable ssd1306.service
}

install_systemd_service

echo_ok "ssd1306 service installed"
echo_ok "Now start service"
echo_ok "   systemctl --user start ssd1306.service"
