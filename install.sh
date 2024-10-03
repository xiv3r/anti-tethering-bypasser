#!/bin/sh 

echo ' Installing Iptables/Ip6tables'
rm -rf /etc/rc.local
curl https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/persistent.sh | sh
