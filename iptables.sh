#!/bin/sh

echo "Downloading Dependencies"
opkg install iptables-mod-ipopt iptables-zz-legacy ip6tables-zz-legacy

echo "
net.ipv6.conf.all.forwarding=1
net.ipv4.ip_forward=1
" >> /etc/sysctl.conf
###
sysctl -p

echo "Installing iptables rule to /etc/rc.local"
sed -i 's/exit 0//' /etc/rc.local
###
echo "
#!/bin/sh /etc/rc.local
iptables -t mangle -A PREROUTING -j TTL --ttl-set 64
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
ip6tables -t mangle -A PREROUTING -j HL --hl-set 64
iptables -A FORWARD -i wlan0 -o br-lan -j ACCEPT
iptables -A FORWARD -i br-lan -o wlan0 -j ACCEPT
exit 0
" >> /etc/rc.local
##$
chmod +x /etc/rc.local
###
sh /etc/rc.local
echo "Done Installing"
###
iptables -vnL --line-numbers
###
ip6tables -vnL --line-numbers
