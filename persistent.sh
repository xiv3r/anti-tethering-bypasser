#!/bin/sh /etc/init.d/

# Run after Boot
opkg install wget iptables-mod-ipopt iptables-zz-legacy -y
cd /etc/init.d/
wget -O antitethering https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/anti-tethering.sh
chmod +x antitehering
