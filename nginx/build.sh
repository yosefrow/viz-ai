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

title "Restart server process"
docker-compose down || echo 'Info: could not docker-compose down'
docker-compose up --build -d ${SERVICE_NAME}

title "Waiting for ${SERVICE_NAME} service..."
while true; do
    curl -sL http://localhost:${NGINX_HTTP_PORT_EXTERNAL} -o /dev/null && break
    sleep 2
done

title "Done."
