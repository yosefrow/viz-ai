#!/bin/bash

export CLIENTNAME="${1}"

echo "Revoke a client certificate"
echo "==========================="
echo "Keep the corresponding crt, key and req files."
echo "==========================="
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME
echo
echo "Remove the corresponding crt, key and req files."
echo "==========================="
docker-compose run --rm openvpn ovpn_revokeclient $CLIENTNAME remove