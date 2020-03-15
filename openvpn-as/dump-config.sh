#!/bin/bash

source .env

# Dump server configuration to text file:
docker exec -it ${SERVICE_NAME} ./confdba -s > config/config.txt

# Dump user and group configuration to text file:
docker exec -it ${SERVICE_NAME} ./confdba -us > config/config.txt

# Import server configuration from text file back to the configuration database:
#./confdba -lf config.txt

# Import user and group configuration from text file back to the configuration database:
# ./confdba -ulf config.txt
