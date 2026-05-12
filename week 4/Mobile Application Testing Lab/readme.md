# Mobile Application Testing Lab

## Overview

This project demonstrates basic mobile application security testing using static and dynamic analysis techniques. The assessment focused on identifying insecure API communication, exposed sensitive information, weak authentication controls, and insecure application configurations within an Android application testing environment.

---

# Tools Used

* Burp Suite
* MobSF
* JADX
* Android Emulator / Android Device
* ADB

---

# Objectives

* Perform static analysis on Android APK files
* Intercept and analyze mobile application traffic
* Identify insecure API communication
* Test authentication and authorization mechanisms
* Document mobile application security findings

---

# Lab Environment

| Component        | Purpose                    |
| ---------------- | -------------------------- |
| Android Emulator | Mobile Testing Environment |
| Vulnerable APK   | Target Application         |
| Burp Suite       | Traffic Interception       |
| MobSF            | Static Analysis            |
| JADX             | APK Decompilation          |

---

# Step 1 — Install Vulnerable APK

A vulnerable Android application APK was installed on the emulator/device using ADB.

```bash id="q7m2v4"
adb install app.apk
```
<img width="939" height="528" alt="image" src="https://github.com/user-attachments/assets/6974e40b-cb39-4a7f-994d-d8d01697ab7b" />

---

# Step 2 — Start MobSF
<img width="820" height="495" alt="image" src="https://github.com/user-attachments/assets/d492492d-1d8e-4f67-8f13-b9431a9ded82" />

MobSF was started for static APK analysis.

```bash id="u4k8m1"
docker run -it -p 8000:8000 opensecurity/mobile-security-framework-mobsf
```

The MobSF dashboard was accessed through:

```text id="m9x3v5"
http://127.0.0.1:8000
```

---

# Step 3 — Perform Static Analysis

The APK file was uploaded into MobSF for analysis.

The following areas were reviewed:

* Android permissions
* Exported activities
* Hardcoded API keys
* Sensitive strings
* Weak cryptographic implementations
* Application configuration issues

---
<img width="935" height="419" alt="image" src="https://github.com/user-attachments/assets/5192d0e4-ebf9-42da-8572-683134d283c6" />
<img width="940" height="505" alt="image" src="https://github.com/user-attachments/assets/d6be382c-97f1-4982-a97f-ec5b44f1afc0" />

# Step 4 — Configure Burp Suite Proxy

Burp Suite was configured as the proxy server for the Android emulator/device.

Proxy settings:

```text id="x2v7m9"
IP Address: Burp Host IP
Port: 8080
```
<img width="1345" height="711" alt="image" src="https://github.com/user-attachments/assets/141686f9-9c63-45e8-b764-7935e608977c" />

---

# Step 5 — Install Burp Certificate

The Burp Suite CA certificate was installed on the Android device to enable HTTPS traffic interception.

```text id="p5k1v8"
http://burp
```

---

# Step 6 — Intercept Mobile Traffic

Application requests were intercepted and analyzed through Burp Suite during normal application usage.

The following activities were tested:

* Login requests
* API communication
* Session handling
* Parameter manipulation
* Authentication tokens

---

# Step 7 — Test Authorization and API Security

Manual testing was performed against API requests to identify authorization weaknesses and insecure parameter handling.

Example parameter manipulation:

```json id="r8m4x2"
"userId":1
```

Modified request:

```json id="k6v1m7"
"userId":2
```

---

# Step 8 — Decompile APK

The APK file was decompiled using JADX for source code analysis.

```bash id="t3m9v4"
jadx-gui app.apk
```

The following components were reviewed:

* API endpoints
* Embedded credentials
* Firebase configuration
* Authentication logic
* Sensitive data storage

---

# Findings

| Test ID | Vulnerability                  | Severity | Component          |
| ------- | ------------------------------ | -------- | ------------------ |
| 021     | Hardcoded API Key              | Medium   | Android APK        |
| 022     | Insecure Authentication        | High     | Login API          |
| 023     | Sensitive Information Exposure | Medium   | Application Source |

---

# Impact

Security weaknesses within mobile applications may expose sensitive information, weaken authentication security, and allow unauthorized access to backend resources or user data.

---

# Remediation

* Remove hardcoded credentials and API keys
* Enforce secure authentication mechanisms
* Implement certificate pinning
* Secure sensitive data storage
* Validate authorization checks server-side
* Minimize excessive application permissions

---

# Summary

The mobile application assessment identified insecure API communication, exposed sensitive information, and weak authorization controls. Static and dynamic analysis using MobSF, Burp Suite, and JADX revealed multiple security weaknesses affecting application confidentiality and authentication mechanisms.

---

# Disclaimer

This project was conducted within an isolated lab environment for educational and authorized security testing purposes only.
