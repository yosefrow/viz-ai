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

echo "Start server process"
echo "============================="
docker-compose up -d openvpn