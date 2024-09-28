#!/bin/sh /etc/rc.local

# WISP 10.0.0.1 TTL/HL=1 -> OpenWRT w/ bypassed -> 10.0.0.1 TTL/HL=64

# Flush table
iptables -F

# Flush NAT table rules
iptables -t nat -F

# Flush mangle table rules
iptables -t mangle -F

# Input TTL=1 and Output TTL=64
iptables -t mangle -A PREROUTING -j TTL --ttl-set 64
iptables -t mangle -I POSTROUTING -o wlan0 -j TTL --ttl-set 64

# Redirect all traffic from wlan0 to eth0
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT

exit 0
