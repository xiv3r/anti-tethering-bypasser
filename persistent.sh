#!/bin/sh /etc/rc.local

# Run after Boot
opkg install wget iptables-mod-ipopt kmod-ipt-ipopt kmod-ipt-nat iptables-zz-legacy iptables ip6tables ip6tables-zz-legacy ip6tables-mod-nat kmod-ipt-nat6 kmod-ip6tables kmod-zram 
curl https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/anti-tethering.sh >>/etc/rc.local
chmod +x /etc/rc.local
