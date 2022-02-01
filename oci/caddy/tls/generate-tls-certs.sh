#!/bin/bash
# tested on debian 11
# ----------------
# => [ /C=FR ] is for Country
# => [ /ST=Occitanie ] is for STate or province
# => [ /L=Toulouse ] is for Locality name or city
# => [ /O=Tech ] School is for Organisation
# => [ /OU=Education ] is for Organisation Unit
# => [ /CN=*.techschool.guru ] is for Common Name or domain name
# => [ /emailAddress=techschool.guru@gmail.com ] is for email address

export TLS_CERT_COUNTRY="FR"
export TLS_CERT_STATE="Auvergne"
export TLS_CERT_LOCALITY="Chamalires"
export TLS_CERT_ORGANISATION="pok-us.io"
export TLS_CERT_ORGANISATION_UNIT="devops"
# one wildcard cert for all pokus services : [caddy.pok-usio.io] [gitea.pok-usio.io] [drone.pok-usio.io] [vault.pok-usio.io] [hubot.pok-usio.io]  etc...
export TLS_CERT_COMMON_NAME="*.pok-us.io"
export TLS_CERT_EMAIL="jean.baptiste.lasselle@gmail.com"

export TLS_ID_INFOS_STR="/C=${TLS_CERT_COUNTRY}/ST=${TLS_CERT_STATE}/L=${TLS_CERT_LOCALITY}/O=${TLS_CERT_ORGANISATION}/OU=${TLS_CERT_ORGANISATION_UNIT}/CN=${TLS_CERT_COMMON_NAME}/emailAddress=${TLS_CERT_EMAIL}"
# openssl req -x509 -newkey rsa:4096 -days 365 -keyout ca-key.pem -out ca-cert.pem -subj "${TLS_ID_INFOS_STR}"
mkdir -p $(pwd)/pokus/tls/rootca/
openssl req -x509 -newkey rsa:4096 -days 365 -keyout "$(pwd)/pokus/tls/rootca/ca-key.pem" -out "$(pwd)/pokus/tls/rootca/ca-cert.pem" -subj "${TLS_ID_INFOS_STR}"


# -- right, after that the [$(pwd)/pokus/tls/rootca/ca-cert.pem] must be trusted by the Linux machien on which docker runs :
sudo apt-get install -y ca-certificates
export CERT_FILE_TO_TRUST=$(pwd)/pokus/tls/rootca/ca-cert.pem

# ---
# * Copy your CA to dir /usr/local/share/ca-certificates/
# * Use command: sudo cp foo.crt /usr/local/share/ca-certificates/foo.crt
# * Use command: sudo cp foo.pem /usr/local/share/ca-certificates/foo.crt
# * Update the CA store: sudo update-ca-certificates
# ---
sudo cp ${CERT_FILE_TO_TRUST} /usr/local/share/ca-certificates/wildcard.pok-us.io.crt
sudo update-ca-certificates
