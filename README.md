# Bypassed Wireless Access Point with Anti-Tethering enabled using any Router with OpenWRT installed.

### [--ttl-set=64 / --ttl-inc=1](https://www.linuxtopia.org/Linux_Firewall_iptables/x4799.html) Overview.

### Note
   * Requires Internet for installation.
   * Configure OpenWRT as wireless extender `Network` => `Scan` => Select `Access Point` and save.

### How it works on WISP mode?
   * WISP 10.0.0.1 TTL/HL=1 => OpenWRT w/ bypasser => 10.0.0.1 TTL/HL=64.
   
### How to do it?
   - First connect the lan cable into the router wan port.
   - Connect your phone via wifi or pc to lan.
   - Execute `SSH` or `TELNET` using `Putty`•`Termius`•`Termux`•`JuiceSSH`•`Kali/Ubuntu` and then proceed to auto install.
     * sudo apt update ; apt install ssh openssh-server telnet puty -y

    ssh root@192.168.1.1
  
   <br>
   
    telnet 192.168.1.1
  
   * Username: `root`
   * Password: `your admin password`
    
     
### Auto install
   * Persistent /etc/rc.local
   
    opkg update ; opkg install curl ; curl https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/anti-tethering.sh >> install ; sh install

### How To check?
   
   * `iptables -vnL --line-numbers`
   * `ip6tables -vnL --line-numbers`
   * `iptables -vnL --line-numbers ; ip6tables -vnL --line-numbers`
     
<img src="https://github.com/xiv3r/anti-tethering-bypasser/blob/main/Without TTL %26 With TTL.png">
