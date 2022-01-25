#!/usr/bin/env bash
action="${1}"

echo -e "\n[INFO] Cloning otzarri-hacking"
cur_dir=$(pwd)
tmp_dir=$(mktemp -d)
cd "${tmp_dir}"
git clone https://gitlab.com/josebamartos/otzarri-hacking.git
"${tmp_dir}"/otzarri-hacking/installer/install.sh "${action}"
cd "${cur_dir}"
rm -rf "${tmp_dir}"
