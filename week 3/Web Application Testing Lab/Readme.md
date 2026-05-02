# Web Application Testing Lab

## Objective
To identify and analyze common web application vulnerabilities such as SQL Injection and Cross-Site Scripting (XSS), and understand how XSS can be used to perform CSRF attacks.

## Lab Setup
- Attacker Machine: Kali Linux  
- Target: DVWA  
- Target IP: 192.168.1.200  
- Tools: Burp Suite, sqlmap  

## Vulnerability Findings

| ID  | Vulnerability     | Severity | URL                          |
|-----|------------------|----------|-------------------------------|
| 001 | SQL Injection    | Critical | http://192.168.1.200/login   |
| 002 | XSS → CSRF       | High     | PortSwigger Lab              |

---

## 1. SQL Injection

### Description
The login page was vulnerable to SQL Injection due to improper input validation.

### Testing
Used sqlmap to test the login form:
## 1. SQL Injection (Manual – Admin Bypass)

### Description
The login functionality is vulnerable to SQL Injection due to improper input validation, allowing authentication bypass.

### Testing (Manual)
Entered the following payloads in the login form:
Payload: "admin' --"

2. XSS Leading to CSRF
Description

A Cross-Site Scripting (XSS) vulnerability can be used to execute malicious JavaScript in a user's browser, which can then perform unauthorized actions (CSRF).

Testing
Injected payload:
<script>alert('XSS')</script>
Verified script execution
Used PortSwigger lab to simulate CSRF via XSS
Attack Flow
Inject malicious script (XSS)
Script runs in victim’s browser
Sends unauthorized request
Action performed without user consent
Summary

The lab demonstrated critical vulnerabilities in the application. SQL Injection allowed backend database interaction, while XSS enabled script execution in the browser. XSS was further used to demonstrate CSRF behavior, showing how vulnerabilities can be chained for more severe attacks.

Remediation
Validate and sanitize user input
Use prepared statements for database queries
Encode output to prevent XSS
Implement CSRF tokens
Improve authentication security
