#!/usr/bin/env bash
# This script setups a Tor web connectivity directory authorities test deck
set -ex

td_var=tor-dir-auth
ooniprobe_unit=ooniprobe
ooni_vars=`ooniprobe --info | cut -d ':' -f2 | tr -d ' ' | tail -n +3`
set -- ${ooni_vars}
td_descriptor=${1}/descriptors/${td_var}.txt
td_data=${1}/data/${td_var}.txt
td_available=${4}/${td_var}.yaml
td_enabled=${5}/${td_var}.yaml

cat > ${td_descriptor} <<EOF
{"id": "tor_dirauth_urls", "type": "file/url", "last_updated": "2019-04-03T09:01:29Z", "name": "Tor dirauth list", "filepath": "${td_data}"}
EOF

cat > ${td_data} <<'EOF'
http://128.31.0.39:9131/tor/server/authority
http://131.188.40.189/tor/server/authority
http://154.35.175.225/tor/server/authority
http://171.25.193.9:443/tor/server/authority
http://193.23.244.244/tor/server/authority
http://194.109.206.212/tor/server/authority
http://199.58.81.140/tor/server/authority
http://204.13.164.118/tor/server/authority
http://66.111.2.131:9030/tor/server/authority
http://86.59.21.38/tor/server/authority
EOF

cat > ${td_available} <<'EOF'
---
name: Test Tor Directory Authorities
description: "This test deck performs a web connectivitity tests to the Tor directory authorities."
schedule: "@daily"
icon: "oo-tor"
tasks:
- name: Web Connectivy tests to Tor directory authorities.
  ooni:
    test_name: web_connectivity
    file: $tor_dirauth_urls
EOF

ln -sf ${td_available} ${td_enabled}

if [ `systemctl is-active ${ooniprobe_unit}` ] ; then
    systemctl restart ${ooniprobe_unit}
fi
