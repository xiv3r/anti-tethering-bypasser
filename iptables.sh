#!/bin/bash

opkg install bash iptables-mod-ipopt iptables-zz-legacy ip6tables-zz-legacy
###
cat >/etc/iptables/rules.v4 << EOF
iptables -t mangle -I PREROUTING -j TTL --ttl-set 64
ip6tables -t mangle -I PREROUTING -j HL --hl-set 64
EOF
###
chmod +x /etc/iptables/rules.v4
###
bash /etc/iptables/rules.v4
###
echo "Done Installing"
###
iptables -vnL --line-numbers
###
ip6tables -vnL --line-numbers
