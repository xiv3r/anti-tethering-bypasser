#!/bin/sh

opkg install iptables-mod-ipopt iptables-zz-legacy ip6tables-zz-legacy
###
cat >/etc/iptables/rules.v4 << EOF
iptables -t mangle -A PREROUTING -j TTL --ttl-set 64
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
ip6tables -t mangle -A PREROUTING -j HL --hl-set 64
EOF
##$
chmod +x /etc/iptables/rules.v4
###
sh /etc/iptables/rules.v4
###
echo "Done Installing"
###
iptables -vnL --line-numbers
###
ip6tables -vnL --line-numbers
