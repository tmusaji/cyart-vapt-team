
## 6. Capstone Project

This capstone project was created to demonstrate the complete Vulnerability Assessment and Penetration Testing (VAPT) lifecycle in one automated workflow. The Bash script was designed to run against Metasploitable 2 in a legal lab environment and perform multiple phases of security testing.

### Objective

The purpose of this project was to combine reconnaissance, scanning, vulnerability identification, exploitation, post exploitation, reporting, and remediation into a single script.

### Target Environment

- Metasploitable 2
- Kali Linux
- Bash Script Automation

### How the Script Works

The script performs the following phases automatically:

1. **Reconnaissance**  
   Checks target availability, collects basic network details, and gathers information using shodan.io or simillar passive tools.
   <img width="1335" height="657" alt="image" src="https://github.com/user-attachments/assets/2f3e2419-7248-4105-8642-dcfc15ad36bb" />

2. **Scanning**  
   Uses Nmap to identify open ports, running services, versions, and possible vulnerabilities.
   <img width="1366" height="768" alt="Screenshot 2026-03-31 153745" src="https://github.com/user-attachments/assets/227327e8-2e1d-490e-b694-f92ee6e93f66" />

3. **Vulnerability Identification**  
   Reviews scan results and maps known vulnerabilities related to detected services.
   <img width="975" height="548" alt="image" src="https://github.com/user-attachments/assets/b912a7d4-0d17-4de0-b634-de85b3b4d64c" />

4. **Exploitation**  
   Uses Metasploit resource commands to test known vulnerabilities in the lab environment.
     <img width="975" height="548" alt="image" src="https://github.com/user-attachments/assets/db1f122d-9a0e-42e5-a95d-6325f2a243a4" />

5. **Post Exploitation**  
   Runs basic enumeration commands after access is obtained, such as checking user privileges and system information.
     <img width="975" height="548" alt="image" src="https://github.com/user-attachments/assets/0736e92f-ece5-4999-bfae-6e946c5157f7" />

6. **Reporting**  
   Generates output files containing scan results, findings, and activity logs.

7. **Remediation Suggestions**  
   Provides recommended fixes such as patching outdated services, changing weak passwords, and reducing exposed services.
    
### Output Generated

The script creates a report folder containing:

- Nmap scan results
- Vulnerability summary
- Exploitation logs
- Final report
- Remediation notes

### Result

The project successfully demonstrated a complete VAPT workflow on a training machine using automation.

### Key Learnings

- VAPT follows multiple structured phases.
- Automation helps save time during assessments.
- Weak and outdated services can lead to compromise.
- Reporting and remediation are important after testing.

