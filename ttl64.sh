#!/bin/sh

echo "
chain mangle_prerouting_ttl64 {
  type filter hook prerouting priority 300; policy accept;
  counter ip ttl set 64
  counter ip6 hoplimit set 64
}
" > /etc/nftables.d/ttl64.nft

###
fw4 check
###
/etc/init.d/firewall restart
