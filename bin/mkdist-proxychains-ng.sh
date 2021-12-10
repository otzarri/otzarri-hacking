#!/bin/bash
set -e

rd="${PWD}"  # Root dir
bd="$(mktemp -d)"  # Build dir

pc_pkg="proxychains-ng.zip"
pc_url="https://github.com/rofl0r/proxychains-ng/archive/refs/heads/master.zip"

echo "[INFO] Downloading ${pc_pkg}"
if which curl > /dev/null; then curl -Lko ${bd}/${pc_pkg} ${pc_url}
elif which wget > /dev/null; then wget --no-check-certificate -P ${bd}/${pc_pkg} ${pc_url}
else echo -e "[ERROR] Missing curl and wget\n"; exit 1; fi

echo "[INFO] Extracting ${pc_pkg}"
unzip ${bd}/${pc_pkg} -d ${bd}

echo "[INFO] Building ${pc_pkg}"
cd ${bd}/proxychains-ng-master
./configure
make

mkdir ${bd}/proxychains-ng
cp ${bd}/proxychains-ng-master/libproxychains4.so ${bd}/proxychains-ng
cp ${bd}/proxychains-ng-master/proxychains4 ${bd}/proxychains-ng
chmod +x ${bd}/proxychains-ng/proxychains4
cat << 'EOF' > ${bd}/proxychains-ng/proxychains.conf
strict_chain
proxy_dns
[ProxyList]
socks5 	127.0.0.1 9050
EOF

cat << 'EOF' > ${bd}/proxychains-ng/proxychains.source
# Bash source file with a shortcut alias
alias pc="${PWD}/proxychains4 -f ${PWD}/proxychains.conf"
EOF

echo "[INFO] Packaging to ${rd}/proxychains-ng.tar.xz"
chmod +x ${bd}/proxychains-ng/proxychains4
tar cf ${bd}/proxychains-ng.tar.xz -C ${bd} ./proxychains-ng > /dev/null
mv ${bd}/proxychains-ng.tar.xz ${rd}
echo -e "[DEL] Removing ${bd} build directory"
#rm -rf ${bd}

echo "[INFO] Proxychains-ng distribution created in ${rd}/proxychains-ng.tar.xz"
