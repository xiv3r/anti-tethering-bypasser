# Bypassed Wireless AP Anti-Tethering using any Router with OpenWRT installed.

## [--ttl-set=64 / --ttl-inc=1](https://www.linuxtopia.org/Linux_Firewall_iptables/x4799.html) Overview.

### Notes
- Requires Internet for installation.

### How it works on WISP mode?
- WISP 10.0.0.1 TTL/HL=1 -> OpenWRT w/ bypassed -> 10.0.0.1 TTL/HL=64


### Auto install

    opkg install curl -y ; curl https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/persistent.sh | sh persistent.sh
