#!/bin/sh

echo "Downloading Dependencies"
###
opkg install iptables-mod-ipopt iptables-zz-legacy ip6tables-zz-legacy
###
echo "
net.ipv6.conf.all.forwarding=1
net.ipv4.ip_forward=1
" >> /etc/sysctl.conf
###
sysctl -p
###
echo "Installing iptables rule to /etc/iptables/rules.v4"
# sed -i 's/exit 0//' /etc/rc.local
###
echo "
#!/bin/sh
iptables -t mangle -A PREROUTING -j TTL --ttl-set 64
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
ip6tables -t mangle -A PREROUTING -j HL --hl-set 64
exit 0
" >> /etc/iptables/rules.v4
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
