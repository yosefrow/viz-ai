#!/bin/bash -e

cd $(dirname ${0})

[ -f .env ] || (
    echo ".env not found! Copying from .env.example" &&
    cp -p .env.example .env
)
source .env

mkdir -p certs 
cd certs

SAN="IP:127.0.0.1,IP:172.17.0.1,IP:${SERVER_PUBLIC_URL}" #IP or DNS
C='IL'
ST='IL'
O='viz.ai-OpenDNS-AS'
CN='*'

openssl req \
	-config <(
		cat /etc/ssl/openssl.cnf <(
			printf "[SAN]\nsubjectAltName=${SAN}"
		)
	) \
	-extensions SAN \
	-subj '/C='${C}'/ST='${ST}'/O='${O}'/CN='${CN} \
	-newkey rsa:2048 \
	-nodes \
	-keyout key.pem \
	-x509 \
	-days 365 \
	-out certificate.pem

cat key.pem certificate.pem | tee chain.pem

openssl x509 -in chain.pem -text
