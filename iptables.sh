#!/bin/sh

opkg install iptables-mod-ipopt iptables-zz-legacy ip6tables-zz-legacy
###
cat > /etc/iptables/rules.v4 << EOF
iptables -t mangle -A PREROUTING -j TTL --ttl-set 64
ip6tables -t mangle -A PREROUTING -j HL --hl-set 64
EOF
###
chmod +x /etc/iptables/rules.v4
###
sh /etc/iptables/rules.v4
###
echo "Done Installing"
