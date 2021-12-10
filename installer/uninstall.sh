#!/usr/bin/env bash
action="${1}"

rd=$(realpath $(dirname "${0}")/..)  # Root dir
bin_src="${rd}/bin"
bin_dst="${HOME}/.local/bin"
cfg_src="${rd}/config"
cfg_dst="${HOME}/.config/otzarri-hacking"
file_list="${cfg_dst}/.installed-files.list"

if [[ "${action}" == 'delete-config' ]]; then rm_cfg='y'; fi

delete_file() {
    file="${1}"
    echo "[DELETE] ${file}"
    rm -f "${file}";
    sed -i "\|${file}|d" "${file_list}" 2> /dev/null
}

echo -e "\n[INFO] Uninstalling otzarri-hacking"

if [[ ! -f "${file_list}" ]]; then
    echo "Missing ${file_list} file."
    echo "Can't uninstall because the list of installed files is missing"
else
    if grep -Fq "${cfg_dst}" "${file_list}" 2> /dev/null; then
        while [[ ! "${rm_cfg}" =~ ^(n|y)$ ]]; do
            read -r -p "Also delete config files? (y/n): " rm_cfg
        done
    fi

    mapfile -t files < "${file_list}"
    for file in "${files[@]}"; do
        file_path=$(dirname "${file}")
        
        if [[ -f "${file}" ]]; then
            if [[ "${file_path}" == "${cfg_dst}" && "${rm_cfg}" == "n" ]]; then
                echo "[OMIT] ${file}"
            else
                delete_file "${file}"
            fi
        fi
    done
fi

if [[ "$(wc -m < ${file_list})" -eq 0 ]]; then
    echo "[WARNING] File ${file_list} is empty"
    echo "[DELETE] ${cfg_dst}"
    delete_file "${file_list}"
fi

if [[ -z "$(ls -A ${cfg_dst})" ]]; then
    echo "[WARNING] Directory ${cfg_dst} is empty"
    echo "[DELETE] ${cfg_dst}"
    rmdir "${cfg_dst}"
fi

echo -e "[INFO] Unistallation completed\n"
