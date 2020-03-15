#!/bin/bash

source .env

confdba=./config/scripts/confdba

# Dump server configuration to text file:
docker exec -it ${SERVICE_NAME} $confdba -s > config/server-config.txt

# Dump user and group configuration to text file:
docker exec -it ${SERVICE_NAME} $confdba -us > config/user-group-config.txt
