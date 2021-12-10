#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Missing directory name"
    echo "Usage: ${0} <dir-name>"
    exit 1
else
    dir_name="${1}"
fi

if [[ -d "${dir_name}" ]]; then
    echo "[ERROR] Directory ${dir_name} aldready exists"
else
    mkdir -p "${dir_name}"/{nmap,content,scripts,tmp,exploits}
fi
