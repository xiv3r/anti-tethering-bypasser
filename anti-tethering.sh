echo "Downloading Dependencies"
opkg install iptables-mod-ipopt kmod-ipt-ipopt kmod-ipt-nat iptables-zz-legacy iptables ip6tables ip6tables-zz-legacy ip6tables-mod-nat kmod-ipt-nat6 kmod-ip6tables kmod-zram

echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

echo "Installing iptables rule to /etc/rc.local"
sed -i 's/exit 0//' /etc/rc.local
echo "#!/bin/sh /etc/rc.local" >> /etc/rc.local
echo "# WISP 10.0.0.1 TTL/HL=1 -> OpenWRT w/ bypassed -> LAN/WLAN=>10.0.0.1 TTL/HL=64" >> /etc/rc.local

echo "iptables -F" >> /etc/rc.local
echo "iptables -t mangle -F" >> /etc/rc.local
echo "iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 65" >> /etc/rc.local
echo "iptables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-set 64" >> /etc/rc.local
echo "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> /etc/rc.local
echo "iptables -A FORWARD -i wlan0 -o br-lan -j ACCEPT" >> /etc/rc.local
echo "iptables -A FORWARD -i br-lan -o wlan0 -j ACCEPT" >> /etc/rc.local

echo "Installing ip6tables rule to /etc/rc.local"
echo "ip6tables -F" >> /etc/rc.local
echo "ip6tables -t mangle -F" >> /etc/rc.local
echo "ip6tables -t mangle -A PREROUTING -i wlan0 -j HL --hl-set 65" >> /etc/rc.local
echo "ip6tables -t mangle -A POSTROUTING -o wlan0 -j HL --hl-set 64" >> /etc/rc.local
echo "ip6tables -A FORWARD -i wlan0 -o br-lan -j ACCEPT" >> /etc/rc.local
echo "ip6tables -A FORWARD -i br-lan -o wlan0 -j ACCEPT" >> /etc/rc.local

echo "exit 0" >> /etc/rc.local
chmod +x /etc/rc.local
sh /etc/rc.local

echo "Done Installing iptables and ip6tables rule into /etc/rc.local"
echo "iptables and ip6tables is running now on wlan0 to eth0 with ttl=64"
