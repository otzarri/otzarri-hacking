#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo -e "Missing target IP address"
    echo -e "Usage: ${0} <ip-address>"
    exit 1
else
    ip_addr="${1}"
fi

for port in $(seq 1 65535); do
    timeout 1 bash -c "echo '' > /dev/tcp/$ip_addr/$port" 2> /dev/null && echo "Open port: ${port}" &
done; wait
