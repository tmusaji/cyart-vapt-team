# Capstone Project - Full VAPT Cycle

## Objective
To simulate a full VAPT cycle including scanning, exploitation, reporting, and remediation using Kali Linux and Metasploit.

---

## Tools Used
- Kali Linux
- Metasploit
- OpenVAS
- Google Docs

---

## Methodology (PTES Phases)

### 1. Reconnaissance & Scanning
- Identified target system and services
- Performed network scanning using Nmap
- Conducted vulnerability assessment using OpenVAS

---

### 2. Detection Log

| Timestamp            | Target IP      | Vulnerability | PTES Phase   |
|--------------------|----------------|---------------|--------------|
| 2025-08-25 13:00:00 | 192.168.1.150  | Drupal RCE    | Exploitation |

---

### 3. Exploitation
- Used Metasploit Framework for exploitation
- Selected appropriate exploit module for identified vulnerability
- Configured target IP and parameters
- Successfully executed exploit and gained access

---

### 4. Findings

- Critical vulnerability allowing remote code execution
- Weak security controls enabled unauthorized access
- System compromise was successfully demonstrated

---

### 5. Remediation

- Update vulnerable software to latest version
- Apply security patches regularly
- Restrict unnecessary services and ports
- Implement strong access controls and firewall rules

---

### 6. Verification

- Re-scanned the system after applying fixes
- Confirmed that the vulnerability was resolved

---

## PTES Report (200 Words)

### Executive Summary
A penetration test was conducted to evaluate the security posture of the target system. The assessment identified critical vulnerabilities that could allow unauthorized access. The most severe issue was a remote code execution vulnerability, which was successfully exploited using Metasploit.

### Findings
The system was vulnerable to remote code execution, enabling attackers to execute commands on the target machine. Scanning results also indicated exposed services that increased the attack surface. Exploitation confirmed that an attacker could gain control over the system.

### Recommendations
It is recommended to patch the identified vulnerabilities immediately and keep all software updated. Network access should be restricted, and strong security controls must be implemented. Regular security testing and monitoring are essential to prevent future attacks.

---

## Non-Technical Summary (100 Words)

A security assessment revealed that the system has critical weaknesses that could allow attackers to gain unauthorized access. One major issue allows attackers to control the system remotely, which can lead to data theft or system misuse. These risks can be reduced by updating software, improving security settings, and limiting unnecessary access. Regular security checks are important to ensure the system remains protected. Addressing these issues will significantly improve overall security and reduce the chances of cyberattacks.

---

## Outcome
- Understood full VAPT lifecycle  
- Gained hands-on experience with Metasploit  
- Learned vulnerability identification and reporting  
- Improved risk communication skills  
