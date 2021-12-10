#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo -e "Missing target C class IP network"
    echo -e "Usage: ${0} <ip-network>"
    echo -e "       ${0} 192.168.1"
    exit 1
else
    network="${1}"
fi

for host in $(seq 1 254); do
    timeout 1 bash -c "ping -c 1 ${network}.${host} > /dev/null 2>&1" && echo "Host alive: ${network}.${host}" &
done; wait
