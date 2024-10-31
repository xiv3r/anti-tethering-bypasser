chain mangle_prerouting_ttl65 {
  type filter hook prerouting priority 300; policy accept;
  iifname "wlan0" counter ip ttl set 65
  iifname "wlan0" counter ip6 hoplimit set 65
}

chain mangle_postrouting_ttl65 {
  type filter hook postrouting priority 300; policy accept;
  oifname "wlan0" counter ip ttl set 65
  oifname "wlan0" counter ip6 hoplimit set 65
}
