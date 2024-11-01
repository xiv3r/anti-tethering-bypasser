<h1 align="center"> Bypassed Wireless Access Point with Anti-Tethering enabled using any Router with OpenWRT installed.

<h1 align="center">
  
  [--ttl-set=64 / --ttl-inc=1](https://www.linuxtopia.org/Linux_Firewall_iptables/x4799.html)
 
</h1>

### Note
   * Requires Internet for installation.
   * Configure OpenWRT as wireless extender `Network` => `Scan` => Select `Access Point` and save.

### How it works on WISP mode?
   * WISP 10.0.0.1 TTL/HL=1 => OpenWRT w/ bypasser => 10.0.0.1 TTL/HL=64.
   
### How to do it?
   - First connect the lan cable into the router wan port.
   - Connect your phone via wifi or pc to lan.
   - Execute `SSH` or `TELNET` using `Putty`•`Termius`•`Termux`•`JuiceSSH`•`Kali/Ubuntu` and then proceed to auto install.
    `sudo apt update ; apt install ssh telnet puty -y`

    ssh root@192.168.1.1
  
   <br>
   
    telnet 192.168.1.1
  
   * Username: `root`
   * Password: `your admin password`

<h1 align="center"> Using IPTABLES & IP6TABLES </h1>
     
### Auto install
`/etc/rc.local`
   
    opkg update ; opkg install curl ; curl https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/iptables.sh | sh

```sh
# IPTABLES for IPv4 (recommended)
# _______________________________

# Flush all rules in the filter table
iptables -F

# Flush all rules in the nat table
iptables -t nat -F

# Flush all rules in the mangle table
iptables -t mangle -F

# Set TTL for incoming packets (PREROUTING)
iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 65

# Set TTL for outgoing packets (POSTROUTING)
iptables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-set 65

# NAT (Masquerading) to route traffic through wlan0 interface
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Allow forwarding between interfaces (if applicable)
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
```
```sh
# IP6TABLES for IPv6 (optional)
# _____________________________

# Flush all rules in the filter table
ip6tables -F

# Flush all rules in the mangle table
ip6tables -t mangle -F

# Setting TTL for incoming traffic on wlan0
ip6tables -t mangle -A PREROUTING -i wlan0 -j HL --hl-set 65

# Setting TTL for outgoing traffic on wlan0
ip6tables -t mangle -A POSTROUTING -o wlan0 -j HL --hl-set 65
```

### How To check?
   
   * `iptables -vnL --line-numbers`
   * `ip6tables -vnL --line-numbers`
   * `iptables -vnL --line-numbers ; ip6tables -vnL --line-numbers`
     
<img src="https://github.com/xiv3r/anti-tethering-bypasser/blob/main/Without TTL %26 With TTL.png">

<h1 align="center "> Using NFTABLES </h1>

To achieve the setup where incoming packets with TTL=1 on the `wlan0` interface are modified to have TTL=64 and forwarded to the `eth0` interface, and the outgoing packets are modified with TTL=64 when sent back from `eth0` to `wlan0`, you can configure nftables as follows:

# Getting root access via SSH
```sh
ssh root@192.168.1.1
```
# Getting root access via Telnet
```sh
telnet 192.168.1.1
```

## Install Dependencies 
```sh
opkg update && opkg install curl wget iptables iptables-mod-ipopt iptables-zz-legacy ip6tables ip6tables-zz-legacy nftables
```

# Using nftables.conf (optional)
```sh
# NFTABLES for IPv4 only
# /etc/nftables.conf

nft add table inet custom_table
# Prerouting: Change TTL=1 to TTL=64 on incoming packets from wlan0
nft add chain inet custom_table prerouting { type filter hook prerouting priority 0 \; }
nft add rule inet custom_table prerouting iif "wlan0" ip ttl set 65

# Postrouting: Enable masquerading on eth0 and set outgoing TTL for wlan0
nft add chain inet custom_table postrouting { type nat hook postrouting priority 100 \; }
nft add rule inet custom_table postrouting oif "eth0" masquerade
nft add rule inet custom_table postrouting oif "wlan0" ip ttl set 64

# Forwarding: Allow traffic between wlan0 and eth0 in both directions
nft add chain inet custom_table forward { type filter hook forward priority 0 \; }
nft add rule inet custom_table forward iif "wlan0" oif "eth0" accept
nft add rule inet custom_table forward iif "eth0" oif "wlan0" accept
```
- ## Install Nftables.conf
```sh
opkg update ; opkg install curl ; curl https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/nftables.sh | sh
```

# Using nftables.nft (recommended)
`etc/nftables.d/12-mangle-ttl-65.nft`
```sh
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
```
- ## Install Nftables.nft
```sh
cd /etc/nftables.d/ && wget https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/12-mangle-ttl-65.nft && chmod +x /etc/nftables.d/12-mangle-ttl-65.nft && fw4 check && /etc/init.d/firewall restart
```
<img src="https://github.com/xiv3r/anti-tethering-bypasser/blob/main/Nftables.nft.png">

## Check nftables existing ruleset
```sh
fw4 check && nft list ruleset
```
# Explanation:
- **Prerouting chain**: Incoming packets on `wlan0` with TTL=1 are changed to TTL=64 before forwarding.
- **Postrouting chain**: Outgoing packets through `wlan0` are set to TTL=64.
- **Forward chain**: Allows forwarding between `wlan0` and `eth0` in both directions.

This configuration should modify the TTL values as requested and enable forwarding between the interfaces.
