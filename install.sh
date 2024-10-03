#!/bin/sh 

opkg update ; opkg install curl ; rm -rf /etc/rc.local ; curl https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/persistent.sh | sh
