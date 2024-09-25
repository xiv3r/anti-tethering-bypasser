# Bypassed Wireless Access Point with Anti-Tethering enabled using any Router with OpenWRT installed.

## [--ttl-set=64 / --ttl-inc=1](https://www.linuxtopia.org/Linux_Firewall_iptables/x4799.html) Overview.

### Notes
- Requires Internet for installation.

### How it works on WISP mode?
- WISP 10.0.0.1 TTL/HL=1 => OpenWRT w/ bypasser => 10.0.0.1 TTL/HL=64.
- All Devices connected under the 192.168.1.1/24 will got the internet connection freely.
### Auto install

    opkg install curl -y ; curl https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/persistent.sh | sh persistent.sh

<img src="https://github.com/xiv3r/anti-tethering-bypasser/blob/main/Without TTL %26 With TTL.png">
