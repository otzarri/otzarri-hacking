#!/bin/bash
set -e

rd="${PWD}"  # Root dir
bd="$(mktemp -d)"  # Build dir

tor_arch="linux64"
tor_ver="11.0"
tor_pkg="tor-browser-${tor_arch}-${tor_ver}_en-US.tar.xz"
tor_url="https://archive.torproject.org/tor-package-archive/torbrowser/${tor_ver}/${tor_pkg}"

echo "[INFO] Downloading ${tor_pkg}"
if which curl > /dev/null; then curl -Lko ${bd}/${tor_pkg} ${tor_url}
elif which wget > /dev/null; then wget --no-check-certificate -P ${bd} ${tor_url}
else echo -e "[ERROR] Missing curl and wget\n"; exit 1; fi

echo "[INFO] Extracting ${tor_pkg}"
tar xf ${bd}/${tor_pkg} -C ${bd}
mv ${bd}/tor-browser_en-US/Browser/TorBrowser/Tor ${bd}/tor
mv ${bd}/tor-browser_en-US/Browser/TorBrowser/Data/Tor ${bd}/tor/data
sed -i 's,./TorBrowser/Tor/,./,g' ${bd}/tor/data/torrc-defaults

echo "[INFO] Creating admin scripts"
cat << 'EOF' > ${bd}/tor/tor.sh
#!/bin/bash

rd=$(cd "$(dirname ${0})" &> /dev/null && pwd)  # Root dir
tor_data="${rd}/data"

LD_LIBRARY_PATH=${rd} \
${rd}/tor \
--defaults-torrc ${tor_data}/torrc-defaults \
-f ${tor_data}/torrc \
--DataDirectory ${tor_data} \
--GeoIPFile ${tor_data}/geoip \
--GeoIPv6File ${tor_data}/geoip6 \
--SocksPort 9050
EOF

cp ${bd}/tor/tor.sh ${bd}/tor/tord.sh
cp ${bd}/tor/tor.sh ${bd}/tor/tor-hidden.sh
cp ${bd}/tor/tor.sh ${bd}/tor/tord-hidden.sh

# Preparing interactive scripts
sed -i '2i# Runs tor and attaches to the ouput' ${bd}/tor/tor.sh
sed -i '2i# Runs tor and attaches to the ouput' ${bd}/tor/tor-hidden.sh
sed -i '3i# Starts a hidden service' ${bd}/tor/tor-hidden.sh
sed -i '$i--HiddenServiceDir ${rd}/hidden-service \' ${bd}/tor/tor-hidden.sh
sed -i '$i--HiddenServicePort 8080' ${bd}/tor/tor-hidden.sh

# Preparing daemon scripts
sed -i '2i# Runs tor as daemon' ${bd}/tor/tord.sh
sed -i '$i--runasdaemon 1' ${bd}/tor/tord.sh
sed -i '2i# Runs tor as daemon' ${bd}/tor/tord-hidden.sh
sed -i '3i# Starts a hidden service' ${bd}/tor/tord-hidden.sh
sed -i '$i--runasdaemon 1 \' ${bd}/tor/tord-hidden.sh
sed -i '$i--HiddenServiceDir ${rd}/hidden-service \' ${bd}/tor/tord-hidden.sh
sed -i '$i--HiddenServicePort 8080' ${bd}/tor/tord-hidden.sh

echo "[INFO] Packaging to ${rd}/tor.tar.xz"
chmod +x ${bd}/tor/tor.sh ${bd}/tor/tor*.sh
tar cf ${bd}/tor.tar.xz -C ${bd} ./tor > /dev/null
mv ${bd}/tor.tar.xz ${rd}
echo -e "[DEL] Removing ${bd} build directory"
rm -rf ${bd}

echo "[INFO] Tor distribution created in ${rd}/tor.tar.xz"
