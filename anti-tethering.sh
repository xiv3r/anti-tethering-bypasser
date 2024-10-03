opkg install wget iptables-mod-ipopt kmod-ipt-ipopt kmod-ipt-nat iptables-zz-legacy iptables ip6tables ip6tables-zz-legacy ip6tables-mod-nat kmod-ipt-nat6 kmod-ip6tables kmod-zram

echo "#!/bin/sh /etc/rc.local" >> /etc/rc.local
echo "# WISP 10.0.0.1 TTL/HL=1 -> OpenWRT w/ bypassed -> LAN/WLAN=>10.0.0.1 TTL/HL=64" >> /etc/rc.local
echo "iptables -F" >> /etc/rc.local
echo "iptables -t mangle -F" >> /etc/rc.local
echo "iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 64" >> /etc/rc.local
echo "iptables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-set 64" >> /etc/rc.local
echo "iptables -A FORWARD -i wlan0 -o br-lan -j ACCEPT" >> /etc/rc.local
echo "iptables -A FORWARD -i br-lan -o wlan0 -j ACCEPT" >> /etc/rc.local
echo "iptables -P FORWARD ACCEPT" >> /etc/rc.local

echo "ip6tables -F" >> /etc/rc.local
echo "ip6tables -t mangle -F" >> /etc/rc.local
echo "ip6tables -t mangle -A PREROUTING -i wlan0 -j HL --hl-set 64" >> /etc/rc.local
echo "ip6tables -t mangle -A POSTROUTING -o wlan0 -j HL --hl-set 64" >> /etc/rc.local
echo "ip6tables -A FORWARD -i wlan0 -o br-lan -j ACCEPT" >> /etc/rc.local
echo "ip6tables -A FORWARD -i br-lan -o wlan0 -j ACCEPT" >> /etc/rc.local
echo "ip6tables -P FORWARD ACCEPT" >> /etc/rc.local

echo "exit 0" >> /etc/rc.local
chmod +x /etc/rc.local
