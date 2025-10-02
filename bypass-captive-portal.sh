#!/bin/sh

# Captive portal bypass 
IP="10.0.15.100"
MAC="32:0C:43:01:76:80"

# Captive portal bypass rules
iptables -t mangle -I PREROUTING 1 -s "$IP" -j MARK --set-xmark 0x13/0xffffffff
iptables -t mangle -I PREROUTING 2 -s "$IP" -j RETURN
iptables -I FORWARD 1 -m mac --mac-source "$MAC" -j ACCEPT
iptables -I FORWARD 2 -d "$IP" -j ACCEPT

# TTL adjust bypass 
iptables -t mangle -I POSTROUTING 1 -s "$IP" -o eth0.22 -j TTL --ttl-set 64
iptables -t mangle -I POSTROUTING 1 -d "$IP" -o eth0.22 -j TTL --ttl-set 64
