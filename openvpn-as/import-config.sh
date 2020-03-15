#!/bin/bash -xe

source .env

confdba=./config/scripts/confdba

TEMP_DIR="tmp/config-$(date +%s)"
TEMP_DIR_EXTERNAL=$OPENVPN_AS_DATA_DIR_EXTERNAL/$TEMP_DIR
TEMP_DIR_INTERNAL=/config/$TEMP_DIR

mkdir -p $TEMP_DIR_EXTERNAL

cp -pr config/* $TEMP_DIR_EXTERNAL

# Import server configuration from text file back to the configuration database:
docker exec -i ${SERVICE_NAME} $confdba -lf ${TEMP_DIR_INTERNAL}/server-config.txt

# Import user and group configuration from text file back to the configuration database:
docker exec -i ${SERVICE_NAME} $confdba -ulf ${TEMP_DIR_INTERNAL}/server-config.txt
