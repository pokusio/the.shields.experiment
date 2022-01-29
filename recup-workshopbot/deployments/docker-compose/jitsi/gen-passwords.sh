#!/usr/bin/env bash

function generatePassword() {
    openssl rand -hex 16
}

JICOFO_AUTH_PASSWORD=$(generatePassword)
JVB_AUTH_PASSWORD=$(generatePassword)
JIGASI_XMPP_PASSWORD=$(generatePassword)
JIBRI_RECORDER_PASSWORD=$(generatePassword)
JIBRI_XMPP_PASSWORD=$(generatePassword)

sed -i.bak \
    -e "s#JICOFO_AUTH_PASSWORD=.*#JICOFO_AUTH_PASSWORD=${JICOFO_AUTH_PASSWORD}#g" \
    -e "s#JVB_AUTH_PASSWORD=.*#JVB_AUTH_PASSWORD=${JVB_AUTH_PASSWORD}#g" \
    -e "s#JIGASI_XMPP_PASSWORD=.*#JIGASI_XMPP_PASSWORD=${JIGASI_XMPP_PASSWORD}#g" \
    -e "s#JIBRI_RECORDER_PASSWORD=.*#JIBRI_RECORDER_PASSWORD=${JIBRI_RECORDER_PASSWORD}#g" \
    -e "s#JIBRI_XMPP_PASSWORD=.*#JIBRI_XMPP_PASSWORD=${JIBRI_XMPP_PASSWORD}#g" \
    "$(dirname "$0")/.env"



# export POKUS_LX_NET_INTERFACE=<name of the linux network interface your docker daemon binds your containers to>
export POKUS_LX_NET_INTERFACE=${POKUS_LX_NET_INTERFACE:-"enp0s3"}
# export POKUS_LX_NET_INTERFACE=enp3s0
export DOCK_HOST_IP_ADDR=$(ip addr | grep -EA2 ${POKUS_LX_NET_INTERFACE} | grep 192 | awk '{print $2}' | awk -F '/' '{print $1}')


sed -i.bak \
    -e "s#POKUS_LX_NET_INTERFACE=.*#POKUS_LX_NET_INTERFACE=${POKUS_LX_NET_INTERFACE}#g" \
    -e "s#DOCK_HOST_IP_ADDR=.*#DOCK_HOST_IP_ADDR=${DOCK_HOST_IP_ADDR}#g" \
    "$(dirname "$0")/.env"
