#!/bin/sh /etc/init.d/
# Run after Boot
opkg install wget iptables-mod-ipopt iptables-zz-legacy -y
wget -O antitethering https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/anti-tethering.sh
chmod +x antitehering
cp -r antitethering /etc/init.d/
chmod +x /etc/init.d/antitethering
