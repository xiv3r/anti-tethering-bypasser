#!/bin/sh /etc/init.d/

# Run after Boot
opkg install wget iptables-mod-ipopt iptables-zz-legacy -y
cd /etc/
wget -O rc.local https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/anti-tethering.sh
chmod +x rc.local
