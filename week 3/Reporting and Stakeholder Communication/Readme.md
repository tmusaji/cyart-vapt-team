# Reporting Practice

## Objective
To document vulnerabilities, visualize an attack path, and communicate security risks clearly.

---

## Tools Used
- Google Docs
- Draw.io

---

## Attack Overview
An external attacker targets a web application and exploits a vulnerability to gain internal access. The attacker then moves laterally across systems and extracts sensitive data.

---

## Attack Flow
1. Attacker performs reconnaissance  
2. Sends HTTP request through firewall  
3. Exploits SQL Injection (F001) on web server  
4. Gains access to internal network  
5. Moves laterally:
   - DB Server (weak password)
   - File Server (SMB access)  
6. Escalates privileges on admin workstation  
7. Exfiltrates data  
<img width="613" height="451" alt="Screenshot 2026-05-02 154741" src="https://github.com/user-attachments/assets/c36dba90-eca4-4ba5-a115-7eeb3fd29660" />

---

## Findings Table

| Finding ID | Vulnerability  | CVSS Score | Remediation        |
|------------|---------------|------------|--------------------|
| F001       | SQL Injection | 9.1        | Input validation   |
| F002       | Weak Password | 7.5        | Strong passwords   |

---

## Technical Findings

### F001 - SQL Injection
- Affects web server  
- Allows unauthorized database access  
- Can be used to enter internal network  

### F002 - Weak Password
- Affects database server  
- Allows unauthorized login  
- Leads to data theft  

---

## Remediation
- Use input validation and parameterized queries  
- Enforce strong password policies  
- Limit internal access  
- Monitor suspicious activity  

---

## Visualization
Attack path diagram created using Draw.io showing:
- Entry point  
- Exploitation  
- Lateral movement  
- Data exfiltration  

---

## Stakeholder Summary
A vulnerability in the web application allows attackers to gain access to internal systems. Weak passwords further increase the risk, allowing access to sensitive data. Fixing these issues will significantly improve system security.
