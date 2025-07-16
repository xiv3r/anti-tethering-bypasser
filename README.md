# Bypass WiFi Tethering Restrictions using any OpenWRT Router.

# Requirements 
- Openwrt version 22.03.5/6/7

# Note
   * Internet is required for installation.
   * Configure OpenWRT as wireless extender `Network` => `Scan` => Select `Access Point` and save.

# How it works on repeater mode?
   * WISP 10.0.0.1 TTL/HL=1 => OpenWRT w/ bypass => 10.0.0.1 TTL/HL=64.
   
# How to do it?
   - First connect the lan cable into the router wan port.
   - Connect your phone via wifi or pc to lan.
   - Execute `SSH` or `TELNET` using `Putty`•`Termius`•`Termux`•`JuiceSSH`•`Kali/Ubuntu` and then proceed to auto install.
    `sudo apt update && sudo apt install ssh telnet puty -y`

    ssh root@192.168.1.1  
    telnet 192.168.1.1
  
   * Username: `root`
   * Password: `your admin password`

<h1 align="center"> Using IPTABLES & IP6TABLES </h1>
     
### Auto install
`/etc/rc.local`
```sh
opkg update && opkg install wget && wget -qO- https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/iptables.sh | bash
```
```sh
# IPTABLES for IPv4 (recommended)
# ______________________________

# Flush the rules in the mangle prerouting table
iptables -t mangle -D PREROUTING

# Set TTL for incoming packets
iptables -t mangle -I PREROUTING -j TTL --ttl-set 64
```
```sh
# IP6TABLES for IPv6 (optional)
# _____________________________

# Flush the rules in the mangle prerouting table
ip6tables -t mangle -D PREROUTING

# Setting TTL for incoming packets
ip6tables -t mangle -I PREROUTING -j HL --hl-set 64
```

### How To check?
   
`iptables-legacy -vnL --line-numbers`
`ip6tables-legacy -Lvn --line-numbers`
`iptables-legacy -vnL --line-numbers ; ip6tables -vnL --line-numbers`
     
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

# Dependencies 
```sh
opkg update && opkg install bash wget
```

# Using nftables.nft (recommended)
`vi /etc/nftables.d/ttl64.nft`
```sh
chain mangle_prerouting_ttl64 {
                type filter hook prerouting priority 300; policy accept;
                ip ttl set 64
                ip6 hoplimit set 64
        }
```
# Install Nftables.nft
```
wget -O /etc/nftables.d/ttl64.nft https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/ttl64.sh && fw4 check && /etc/nftables.d/firewall restart
```
<img src="https://github.com/xiv3r/anti-tethering-bypasser/blob/main/Nftables.nft.png">

# Check nftables ruleset
```sh
fw4 check && nft list ruleset
```
