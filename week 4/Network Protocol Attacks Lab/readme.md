# Network Protocol Attacks Lab

## Overview

This project demonstrates practical network protocol attacks performed within a controlled lab environment using Responder, Ettercap, and Wireshark. The assessment focused on LLMNR/NBT-NS poisoning, ARP spoofing, traffic interception, and network packet analysis to understand common Man-in-the-Middle (MitM) attack techniques.

---

# Tools Used

* Kali Linux
* Responder
* Ettercap
* Wireshark
* Metasploit VM

---

# Objectives

* Perform LLMNR/NBT-NS poisoning
* Simulate SMB/hostname interception attacks
* Execute ARP spoofing attacks
* Capture and analyze network traffic
* Document attack methodology and findings

---

# Lab Environment

| Machine       | Role     | IP Address    |
| ------------- | -------- | ------------- |
| Kali Linux    | Attacker | 192.168.1.100 |
| MSFconsole VM | Victim   | 192.168.1.200 |

---

# Attack Simulation — Responder

## Description

Responder was used to perform LLMNR/NBT-NS poisoning attacks within the local network. The attacker system listened for hostname resolution requests and responded with spoofed replies to impersonate requested network resources.

---

## Responder Execution

### Command Used

```bash id="v2k7m4"
sudo responder -I eth0
```
<img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/c54a9cc8-616a-4a74-891d-3cf7a080788a" />

### Victim Activity

The victim machine generated fake hostname traffic:

```bash id="u8m1x5"
ping fakehost
```
<img width="768" height="257" alt="image" src="https://github.com/user-attachments/assets/0e9bd179-2276-4a91-b0a6-114251d583e1" />

and:

```bash id="q4v9k2"
smbclient -L //FAKEHOST
```

---

## Result

Responder successfully intercepted hostname resolution traffic and spoofed responses to the victim system. The attack demonstrated how attackers can abuse insecure name resolution protocols to intercept authentication-related traffic and impersonate network resources.

--<img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/9f8efaf9-267e-41a7-af04-08cba30ba155" />
-

# Attack Log

| Attack ID | Technique                   | Target IP     | Status  | Outcome                      |
| --------- | --------------------------- | ------------- | ------- | ---------------------------- |
| 015       | SMB Relay / LLMNR Poisoning | 192.168.1.200 | Success | Intercepted Network Requests |

---

# ARP Spoofing — Ettercap

## Description

Ettercap was used to perform ARP spoofing attacks and position the attacker system between the victim and gateway for Man-in-the-Middle interception.

---

## Enable IP Forwarding

```bash id="x5m2v8"
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
```
<img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/30677d79-3fea-4eb7-b030-eacc84f2deb9" />

---

## Ettercap Execution

```bash id="p9k4m1"
sudo ettercap -G
```
<img width="1280" height="800" alt="image" src="https://github.com/user-attachments/assets/a07d6de4-00a5-4145-98d0-e8cf72ad87d5" />

---

## Attack Methodology

* Unified sniffing mode enabled
* Hosts scanned and selected
* Victim assigned as Target 1
* Gateway assigned as Target 2
* ARP poisoning initiated with remote sniffing enabled

---

## Result

ARP spoofing successfully redirected victim network traffic through the attacker machine, allowing interception and monitoring of network communications.

---

# Packet Analysis — Wireshark

## Description

Wireshark was used to capture and analyze network traffic flowing through the attacker system during the MitM attack simulation.

---

## Traffic Captured

The following protocols were analyzed:

* ARP
* DNS
* SMB
* HTTP

---

## Example Filters

```text id="t7v3m6"
arp
dns
smb
http
```

---

## Result

Captured packets confirmed successful interception of victim traffic and visibility into network communication flows during the attack simulation.

---

# Checklist

```text id="m1k8v4"
✔ Captured LLMNR/NBT-NS requests using Responder

✔ Simulated SMB relay and hostname spoofing attacks

✔ Performed ARP spoofing using Ettercap

✔ Intercepted and analyzed network traffic

✔ Captured packets using Wireshark
```

---

# Summary

The network protocol attack assessment demonstrated successful interception and analysis of network traffic within a controlled lab environment. Responder captured hostname resolution traffic through LLMNR poisoning, while Ettercap performed ARP spoofing to intercept communications between hosts. Wireshark analysis confirmed successful packet capture and visibility into network protocol activity.

---

# Screenshots

```text id="r4x9m2"
screenshots/
│
├── 01-lab-setup.png
├── 02-responder-running.png
├── 03-responder-traffic.png
├── 04-arp-spoofing.png
└── 05-wireshark-analysis.png
```

---

# Disclaimer

This project was conducted within an isolated lab environment for educational and authorized security testing purposes only.
