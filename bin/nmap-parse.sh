#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "Missing arguments"
    echo "Usage: ${0} <nmap-grepable-file> [ip|ports|all]"
    exit 0
else
    nmap_file="${1}"
    nmap_data="${2}"
fi

if [[ -z "${nmap_data}" ]]; then nmap_data="all"; fi

if [[ "${nmap_data}" == "ip" || "${nmap_data}" == "all" ]]; then
    cat ${nmap_file} | grep -oP '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' | sort -u
fi

if [[ "${nmap_data}" == "ports" || "${nmap_data}" == "all" ]]; then
    cat "${nmap_file}" | grep -oP '\d{1,5}/open' | awk '{print $1}' FS="/" | xargs | tr ' ' ','
fi
