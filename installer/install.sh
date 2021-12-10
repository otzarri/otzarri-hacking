#!/usr/bin/env bash
action="${1}"

rd=$(realpath $(dirname "${0}")/..)  # Root dir
bin_src="${rd}/bin"
bin_dst="${HOME}/.local/bin"
cfg_src="${rd}/config"
cfg_dst="${HOME}/.config/otzarri-hacking"
file_list="${cfg_dst}/.installed-files.list"

if [[ "${action}" == 'overwrite-config' ]]; then rm_cfg='y'; fi

check_dir() {
    dir="${1}"
    action="${2}"

    if [[ ! -d "${dir}" ]]; then
        echo "[WARNING] Missing ${dir} directory"
        if [[ "${action}" == "create" ]]; then
            echo "[INFO] Creating ${dir} directory"
            mkdir "${dir}"
        fi
    fi
}

copy_file() {
    src_file="${1}"
    dst_file="${2}"
    overwrite="${3}"
    file_path=$(dirname "${dst_file}")

    if [[ -f "${dst_file}" && \
        "${file_path}" == "${cfg_dst}" && \
        "${overwrite}" == "n" \
    ]]; then
        echo "[OMIT] ${dst_file}"
    else
        echo "[COPY] ${src_file}  =>  ${dst_file}"
        cp -rp -f "${src_file}" "${dst_file}"
        if ! grep -Fxq "${dst_file}" "${file_list}" 2> /dev/null; then
            echo "${dst_file}" >> "${file_list}"
        fi
    fi
}

function copy_dir_content() {
    src_dir="${1}"
    dst_dir="${2}"
    overwrite="${3}"

    for src_file in "${src_dir}"/*; do
        if [[ "${src_dir}" ==  "${bin_src}" ]]; then
            # Remove extension to the files installed from bin dir
            dst_file="${dst_dir}/$(basename ${src_file%.*})"
        else
            dst_file="${dst_dir}/$(basename ${src_file})"
        fi
        copy_file "${src_file}" "${dst_file}" "${overwrite}"
    done
}

echo -e "\n[INFO] Installing otzarri-hacking"

if [[ -f ${file_list} ]]; then
    if grep -Fq "${cfg_dst}" "${file_list}" 2> /dev/null; then
        while [[ ! "${rm_cfg}" =~ ^(n|y)$ ]]; do
            read -r -p "Overwrite config files? (y/n): " rm_cfg
        done
    fi
fi

check_dir "${bin_dst}" "create"
check_dir "${cfg_dst}" "create"
copy_dir_content "${bin_src}" "${bin_dst}" "y"
copy_dir_content "${cfg_src}" "${cfg_dst}" "${rm_cfg}"
copy_file "${rd}/installer/uninstall.sh" "${bin_dst}/otzarri-hacking-uninstall" "y"
echo -e "[INFO] Installation completed\n"
