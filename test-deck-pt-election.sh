#!/usr/bin/env bash
# This script sets a Web Connectivity test deck for the Portuguese election 2019.
set -ex

td_var=pt-election-2019
ooniprobe_unit=ooniprobe
ooni_vars=`ooniprobe --info | cut -d ':' -f2 | tr -d ' ' | tail -n +3`
set -- ${ooni_vars}
td_descriptor=${1}/descriptors/${td_var}.txt
td_data=${1}/data/${td_var}.txt
td_available=${4}/${td_var}.yaml
td_enabled=${5}/${td_var}.yaml

cat > ${td_descriptor} <<EOF
{"id": "pt-election-urls", "type": "file/url", "last_updated": "2019-01-01T09:00:00Z", "name": "PT election 2019 list", "filepath": "${td_data}"}
EOF

cat > ${td_data} <<'EOF'
https://pt.wikipedia.org/
https://en.wiktionary.org/
https://nl.wikipedia.org/
https://partidoalianca.pt/
https://www.bloco.org/
https://fazsentido.cds.pt/
https://partidochega.pt/
https://www.cdu.pt/
https://iniciativaliberal.pt/
https://juntospelopovo.pt/
https://partidolivre.pt/
https://www.mas.org.pt/
https://noscidadaos.pt/
https://www.pan.com.pt/
https://www.lutapopularonline.org/
https://pdr.pt/
https://www.pnr.pt/
https://www.cds.pt/
https://ppmonarquico.pt/
https://www.psd.pt/
https://ps.pt/
https://www.partidotrabalhista.pt/
https://www.purp.pt/
https://mpt.pt/
https://www.partido-rir.pt/
http://www.cne.pt/
https://www.recenseamento.mai.gov.pt/
https://www.eleicoes.mai.gov.pt/
https://www.portaldoeleitor.pt/
https://www.sg.mai.gov.pt/AdministracaoEleitoral/Paginas/default.aspx/
https://www.tribunalconstitucional.pt/
EOF

cat > ${td_available} <<'EOF'
---
name: Portuguese election 2019 test
description: "This test deck performs a Web Connectivitity test to the websites related to the Portuguese election 2019."
schedule: "@daily"
icon: "fa-puzzle-piece"
tasks:
- name: Web Connectivy test to Portuguese election 2019 websites.
  ooni:
    test_name: web_connectivity
    file: $pt-election-urls
EOF

ln -sf ${td_available} ${td_enabled}

if [ `systemctl is-active ${ooniprobe_unit}` ] ; then
    systemctl restart ${ooniprobe_unit}
fi
