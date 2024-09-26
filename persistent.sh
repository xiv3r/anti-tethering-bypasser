#!/bin/sh /etc/rc.local

# Run after Boot
opkg install wget iptables-mod-ipopt kmod-ipt-ipopt iptables-zz-legacy
cd /etc/
wget -O rc.local https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/anti-tethering.sh
chmod +x rc.local
