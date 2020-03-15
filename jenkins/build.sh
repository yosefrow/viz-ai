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

IMAGE_UID=$(docker run --rm -it ${DOCKER_IMAGE} id -u | tail -n 1 | tr -d '\r')

title "Create Data dir"
sudo mkdir -p ${JENKINS_DATA_DIR_EXTERNAL}

title "Fix ownership"
sudo chown -R $IMAGE_UID ${JENKINS_DATA_DIR_EXTERNAL}

title "Restart server process"
docker-compose down || echo 'Info: could not docker-compose down'
docker-compose up -d ${SERVICE_NAME}

title "Waiting for ${SERVICE_NAME} service..."
while true; do
    curl -sL http://localhost:${JENKINS_HTTP_PORT_EXTERNAL} -o /dev/null && break
    sleep 2
done

title "Done."
