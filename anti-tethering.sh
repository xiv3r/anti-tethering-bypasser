#!/bin/sh /etc/rc.local

# Setup
# WISP 10.0.0.1 TTL/HL=1 -> OpenWRT w/ bypassed -> 10.0.0.1 TTL/HL=64

# Interfaces 
LAN="eth0"
WAN="wlan0"

# Flush Tables
iptables -F
iptables -t nat -F -t mangle -F

# Apply Routing
iptables -t mangle -I POSTROUTING -o $WAN -j TTL --ttl-set 64
iptables -t mangle -I POSTROUTING -o $WAN -m ttl ! --ttl-eq 255 -j TTL --ttl-set 64
iptables -t nat -A POSTROUTING -o $WAN -j MASQUERADE
iptables -t mangle -A PREROUTING -j TTL --ttl-set 64
iptables -A FORWARD -i $WAN -o $LAN -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables  i-A FORWARD -i $LAN -o $WAN -j ACCEPT

exit 0
