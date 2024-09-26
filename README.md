# Bypassed Wireless Access Point with Anti-Tethering enabled using any Router with OpenWRT installed.

### [--ttl-set=64 / --ttl-inc=1](https://www.linuxtopia.org/Linux_Firewall_iptables/x4799.html) Overview.

### Note
   * Requires Internet for installation.

### How it works on WISP mode?
   * WISP 10.0.0.1 TTL/HL=1 => OpenWRT w/ bypasser => 10.0.0.1 TTL/HL=64.

### How to do it?
   * first connect the lan cable into the router wan port.
   * execute ssh or telnet using |putty|termius|termux|juicessh|kali and proceed to auto install.

      ssh root@192.168.1.1
      telnet 192.168.1.1
### Auto install
   * persistent
   
    opkg update ; opkg install curl -y ; curl https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/persistent.sh | sh persistent.sh

### To check
   * iptables -L -n -v --line-numbers
   * iptables  -t nat -L --line-numbers

### Fixed DNS Issue
- Goto Network => Interface => wwan => Advanced Settings
  * Custom DNS Server => 8.8.8.8
  * DNS Search Domain => dns.google
  
<img src="https://github.com/xiv3r/anti-tethering-bypasser/blob/main/Without TTL %26 With TTL.png">
