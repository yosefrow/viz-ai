#!/bin/bash

cd $(dirname ${0})

[ -f .env ] || (
    echo ".env not found! Copying from .env.example" && 
    cp -p .env.example .env
)
source .env

echo "Create Data dir"
echo "============================="
sudo mkdir -p ${OPENVPN_DATA_DIR_EXTERNAL}

echo "Fix ownership"
echo "============================="
sudo chown -R $(whoami): ${OPENVPN_DATA_DIR_EXTERNAL}

echo Initialize the configuration files and certificates
echo =============================
docker-compose run --rm openvpn ovpn_genconfig -u udp://${SERVER_PUBLIC_URL}
docker-compose run --rm openvpn ovpn_initpki

./build.sh

