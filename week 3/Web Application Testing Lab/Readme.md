# Web Application Testing Lab

## Objective
To identify and analyze common web application vulnerabilities such as SQL Injection and Cross-Site Scripting (XSS), and understand how XSS can be used to perform CSRF attacks.

## Lab Setup
- Attacker Machine: Kali Linux  
- Target: Practice Labs  
- Tools: Burp Suite  

## Vulnerability Findings

| ID  | Vulnerability     | Severity | Target       |
|-----|------------------|----------|---------------|
| 001 | SQL Injection    | Critical | Login Function|
| 002 | XSS → CSRF       | High     | Lab Environment|

---

## 1. SQL Injection (Manual – Admin Bypass)

### Description
The login functionality was vulnerable to SQL Injection due to improper input validation, allowing authentication bypass.

### Testing
Intercepted the login request using Burp Suite and modified parameters.

**Original Request**

username=wiener&password=peter


**Injected Payload**

username=administrator'--&password=anything


### Result
- Authentication bypass achieved  
- Logged in as administrator  
- Access to restricted functionality obtained  

### Explanation
The payload `administrator'--` terminates the SQL query and comments out the password check. This allows login without validating the password.

---

## 2. XSS Leading to CSRF

### Description
A Cross-Site Scripting (XSS) vulnerability allows execution of malicious JavaScript in the victim’s browser. This can be used to perform unauthorized actions (CSRF).

### Testing
- Injected payload:
<script>alert('XSS')</script>
- Verified script execution  
- Used lab environment to simulate unauthorized action  

### Attack Flow
1. Inject malicious script (XSS)  
2. Script executes in victim’s browser  
3. Sends unauthorized request  
4. Action performed without user consent  

---

## Summary
The lab demonstrated critical vulnerabilities in web applications. SQL Injection allowed authentication bypass and unauthorized access, while XSS enabled execution of malicious scripts. XSS was further used to simulate CSRF behavior, showing how vulnerabilities can be chained for more severe attacks.

---

## Remediation
- Validate and sanitize all user inputs  
- Use parameterized queries (prepared statements)  
- Encode output to prevent XSS  
- Implement CSRF protection mechanisms  
- Improve authentication and session handling  
