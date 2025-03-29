<h1 align="center"> Bypass Wireless Access Point with Tethering Restrictions using any OpenWRT Router 

<h1 align="center">
  TTL=1 to TTL=64
  
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
    telnet 192.168.1.1
  
   * Username: `root`
   * Password: `your admin password`

<h1 align="center"> Using IPTABLES & IP6TABLES </h1>
     
### Auto install
`/etc/rc.local`
```sh
opkg update && opkg install bash wget && wget -qO- https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/iptables.sh | bash
```
```sh
# IPTABLES for IPv4 (recommended)
# ______________________________

# Flush all rules in the mangle table
iptables -t mangle -F

# Set TTL for incoming packets (PREROUTING)
iptables -t mangle -A PREROUTING -i wlan0 -j TTL --ttl-set 64

# Set TTL for outgoing packets (POSTROUTING)
iptables -t mangle -A POSTROUTING -o wlan0 -j TTL --ttl-set 64

# Allow forwarding between interfaces (if applicable)
iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o wlan0 -j ACCEPT
```
```sh
# IP6TABLES for IPv6 (optional)
# _____________________________

# Flush all rules in the mangle table
ip6tables -t mangle -F

# Setting TTL for incoming traffic on wlan0
ip6tables -t mangle -A PREROUTING -i wlan0 -j HL --hl-set 64

# Setting TTL for outgoing traffic on wlan0
ip6tables -t mangle -A POSTROUTING -o wlan0 -j HL --hl-set 64
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
opkg update && opkg install bash wget iptables iptables-mod-ipopt iptables-zz-legacy ip6tables ip6tables-zz-legacy nftables
```

# Using nftables.nft (recommended)
`/etc/nftables.d/ttl64.nft`
```sh
chain mangle_prerouting_ttl64 {
  type filter hook prerouting priority 300; policy accept;
  counter ip ttl set 64
  counter ip6 hoplimit set 64
}
```
- ## Install Nftables.nft
```
wget -O /etc/nftables.d/ttl64.nft https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/ttl64.sh && fw4 check && /etc/nftables.d/firewall restart
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
