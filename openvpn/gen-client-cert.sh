#!/bin/bash

export CLIENTNAME="${1}"

echo "Generate a client certificate"
echo "============================="
echo "with a passphrase (recommended)"
echo "============================="
docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
echo
# without a passphrase (not recommended)
# docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
echo
echo "Retrieve the client configuration with embedded certificates"
echo ""============================="
docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn