#!/bin/bash

cd $(dirname ${0})

[ -f .env ] || (
    echo ".env not found! Copying from .env.example" && 
    cp -p .env.example .env
)
source .env

echo "Create Data dir"
echo "============================="
sudo mkdir -p ${JENKINS_DATA_DIR_EXTERNAL}

echo "Fix ownership"
echo "============================="
sudo chown -R $(whoami): ${JENKINS_DATA_DIR_EXTERNAL}

echo "Start Start server process"
echo "============================="
docker-compose up -d jenkins

