#!/bin/bash

set -e

scriptName="ssd1306service.sh"
scriptInstallDir="/usr/local/bin"
systemdServiceRoot="/etc/systemd/system"
systemdServiceName="ssd1306update.service"

if [ ! -f "${scriptName}" ]; then
  echo "run script from source dir"
  exit 1
fi

mkdir -p "${scriptInstallDir}"
cp "${scriptName}" "${scriptInstallDir}/${scriptName}"

mkdir -p "${systemdServiceRoot}"

cat > "${systemdServiceRoot}/${systemdServiceName}" <<EOF
[Unit]
Description=SSD1306 display service
StartLimitInterval=200
StartLimitBurst=5

[Service]
Restart=always
RestartSec=30
Type=simple
ExecStart=${scriptInstallDir}/${scriptName}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable "${systemdServiceName}"
systemctl start "${systemdServiceName}"
