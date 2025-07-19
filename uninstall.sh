#!/bin/bash

echo "Uninstalling bot"
echo ""
echo "* Stopping service"
systemctl --user stop ssd1306.service
echo "* Removing unit file"
rm ${HOME}/.config/systemd/user/ssd1306.service
echo "Done"
