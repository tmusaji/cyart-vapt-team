
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
   Checks target availability, collects basic network details, and gathers information.

2. **Scanning**  
   Uses Nmap to identify open ports, running services, versions, and possible vulnerabilities.

3. **Vulnerability Identification**  
   Reviews scan results and maps known vulnerabilities related to detected services.

4. **Exploitation**  
   Uses Metasploit resource commands to test known vulnerabilities in the lab environment.

5. **Post Exploitation**  
   Runs basic enumeration commands after access is obtained, such as checking user privileges and system information.

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

