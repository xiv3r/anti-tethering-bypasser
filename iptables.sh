echo "Downloading Dependencies"
opkg install iptables-mod-ipopt iptables-zz-legacy ip6tables-zz-legacy

echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

echo "Installing iptables rule to /etc/rc.local"
sed -i 's/exit 0//' /etc/rc.local
echo "#!/bin/sh /etc/rc.local" >> /etc/rc.local
echo "iptables -F" >> /etc/rc.local
echo "iptables -t mangle -F" >> /etc/rc.local
echo "iptables -t nat -F" >> /etc/rc.local
echo "ip6tables -F" >> /etc/rc.local
echo "ip6tables -t mangle -F" >> /etc/rc.local
echo "iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 64" >> /etc/rc.local
echo "iptables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-set 64" >> /etc/rc.local
echo "iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> /etc/rc.local
echo "ip6tables -t mangle -A PREROUTING -i wlan0 -j HL --hl-set 64" >> /etc/rc.local
echo "ip6tables -t mangle -A POSTROUTING -o wlan0 -j HL --hl-set 64" >> /etc/rc.local
echo "iptables -A FORWARD -i wlan0 -o br-lan -j ACCEPT" >> /etc/rc.local
echo "iptables -A FORWARD -i br-lan -o wlan0 -j ACCEPT" >> /etc/rc.local

echo "exit 0" >> /etc/rc.local
chmod +x /etc/rc.local
sh /etc/rc.local

echo "Done Installing iptables and ip6tables rule into /etc/rc.local"
echo "iptables and ip6tables is running now on wlan0 to eth0 with ttl=64"
iptables -vnL --line-numbers
ip6tables -vnL --line-numbers
