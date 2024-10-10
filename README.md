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
   * Persistent /etc/rc.local
   
    opkg update ; opkg install curl ; curl https://raw.githubusercontent.com/xiv3r/anti-tethering-bypasser/refs/heads/main/anti-tethering.sh | sh

### How To check?
   
   * `iptables -vnL --line-numbers`
   * `ip6tables -vnL --line-numbers`
   * `iptables -vnL --line-numbers ; ip6tables -vnL --line-numbers`
     
<img src="https://github.com/xiv3r/anti-tethering-bypasser/blob/main/Without TTL %26 With TTL.png">

<h1 align="center "> Using NFTABLES </h1>

To achieve the setup where incoming packets with TTL=1 on the `wlan0` interface are modified to have TTL=64 and forwarded to the `eth0` interface, and the outgoing packets are modified with TTL=64 when sent back from `eth0` to `wlan0`, you can configure nftables as follows:

### 1. **Install nftables (if not installed)**
```bash
sudo apt-get install nftables
```

### 2. **Enable forwarding between wlan0 and eth0**
You must enable IP forwarding on the system.

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

To make this change persistent, edit `/etc/sysctl.conf` and ensure the following line is present:

```bash
net.ipv4.ip_forward=1
```

### 3. **Configure the nftables Rules**

Here is a basic nftables configuration to change TTL and allow forwarding between `wlan0` and `eth0`:

#### 3.1 Create the nftables rules file

Create or edit the nftables configuration file `/etc/nftables.conf`:

```bash
#!/usr/sbin/nft -f

table inet filter {
    chain input {
        type filter hook input priority 0; policy accept;
    }

    chain forward {
        type filter hook forward priority 0; policy drop;

        # Allow forwarding between wlan0 and eth0
        iif "wlan0" oif "eth0" accept
        iif "eth0" oif "wlan0" accept
    }

    chain output {
        type filter hook output priority 0; policy accept;
    }
}

table ip nat {
    chain prerouting {
        type nat hook prerouting priority -100; policy accept;

        # Change incoming TTL=1 to TTL=64 for packets on wlan0
        iif "wlan0" ip ttl 1 ttl set 64
    }

    chain postrouting {
        type nat hook postrouting priority 100; policy accept;

        # Change TTL=64 on outgoing packets to wlan0
        oif "wlan0" ip ttl set 64
    }
}
```

#### 3.2 Save and apply the nftables rules

After saving the configuration file, apply the rules using the following command:

```bash
sudo nft -f /etc/nftables.conf
```

### 4. **Ensure nftables Service is Enabled**

To ensure nftables starts on boot and the rules persist across reboots, enable and start the nftables service:

```bash
sudo systemctl enable nftables
sudo systemctl start nftables
```

### Explanation:
- **Prerouting chain**: Incoming packets on `wlan0` with TTL=1 are changed to TTL=64 before forwarding.
- **Postrouting chain**: Outgoing packets through `wlan0` are set to TTL=64.
- **Forward chain**: Allows forwarding between `wlan0` and `eth0` in both directions.

This configuration should modify the TTL values as requested and enable forwarding between the interfaces.
