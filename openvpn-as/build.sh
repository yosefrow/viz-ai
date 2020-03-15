#!/bin/bash -e

cd $(dirname ${0})

[ -f .env ] || (
    echo ".env not found! Copying from .env.example" && 
    cp -p .env.example .env
)
source .env

function title() {
    local text="${@}"
    echo 
    echo "${text}"
    echo "============================="
}

title "Create Data dir"
sudo mkdir -p ${OPENVPN_AS_DATA_DIR_EXTERNAL}

title "Fix ownership"
sudo chown -R $(whoami): ${OPENVPN_AS_DATA_DIR_EXTERNAL}

title "Restart server process"
docker-compose down || echo 'Info: could not docker-compose down'
docker-compose up -d openvpn-as

title "Waiting for service..."
while true; do
    curl -sLk https://localhost:943 -o /dev/null && break
    sleep 2
done

title "Visit the dashboard"
echo "https://${SERVER_PUBLIC_URL}:${OPENVPN_AS_GUI_PORT_EXTERNAL}/admin"
