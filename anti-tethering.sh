#!/bin/sh /etc/rc.local

# WISP 10.0.0.1 TTL/HL=1 -> OpenWRT w/ bypassed -> LAN/WLAN=>10.0.0.1 TTL/HL=64
iptables -F
iptables -t mangle -F
iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 64
iptables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-set 64
iptables -A FORWARD -i wlan0 -o br-lan -j ACCEPT
iptables -A FORWARD -i br-lan -o wlan0 -j ACCEPT
iptables -P FORWARD ACCEPT

ip6tables -F
ip6tables -t mangle -F
ip6tables -t mangle -A PREROUTING -i wlan0 -j HL --hl-set 64
ip6tables -t mangle -A POSTROUTING -o wlan0 -j HL --hl-set 64
ip6tables -A FORWARD -i wlan0 -o br-lan -j ACCEPT
ip6tables -A FORWARD -i br-lan -o br-lan -j ACCEPT
ip6tables -P FORWARD ACCEPT

exit 0
