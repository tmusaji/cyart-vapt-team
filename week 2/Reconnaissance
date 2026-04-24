# Reconnaissance Practice

## Introduction

Reconnaissance is the information gathering phase of a security assessment. It is used to collect publicly available and technical information about a target before deeper testing begins.

The main goal is to understand the target’s external exposure, identify assets, discover technologies in use, and detect possible attack surfaces.

Reconnaissance can be:

- Passive Reconnaissance – Collecting information without directly interacting with the target.
- Active Reconnaissance – Sending requests or scanning systems to gather details.

---

## Tools Used

## Shodan

Shodan is a search engine used to discover internet-connected devices and exposed services.

It helps identify:

- Open ports
- Public servers
- SSL certificates
- Webcams, routers, IoT devices
- Server banners and versions

Example Findings:

- Port 22 open (SSH)
- Port 443 open (HTTPS)
- Apache server exposed

---

## WHOIS

WHOIS is used to gather domain registration details.

Typical information includes:

- Registrar name
- Domain creation date
- Expiry date
- Name servers
- Registrant details (if public)

Usefulness:

- Understand domain ownership
- Check domain age
- Verify legitimacy

---

## Subdomain Finder

Subdomain enumeration tools are used to discover subdomains linked to the main domain.

Examples:

- blog.example.com
- dev.example.com
- api.example.com
- mail.example.com

Why it matters:

Organizations sometimes forget to secure development or old subdomains.

Common tools:

- Sublist3r
- Amass

---

## Google Search

Search engines can reveal publicly indexed information.

Examples:

- Login pages
- Public documents
- Old websites
- Exposed directories
- Employee PDFs
- Technology hints from job posts

This helps understand the public footprint of a target.

---

## Information Collected

## Domain Information

Collected details may include:

- Main domain
- Registrar
- Creation date
- DNS records
- SSL certificate details

---

## Subdomains

Discovered subdomains increase the visible attack surface.

Examples:

- dev.company.com
- support.company.com
- mail.company.com

Possible risks:

- Old software
- Test panels
- Weak authentication

---

## Exposed Ports

Open ports indicate services running on a server.

| Port | Service |
|------|---------|
| 22   | SSH |
| 80   | HTTP |
| 443  | HTTPS |
| 21   | FTP |
| 3389 | RDP |

Unnecessary open ports increase risk.

---

## Technologies Used

Reconnaissance may identify:

- Apache / Nginx
- WordPress
- React
- PHP
- Cloudflare
- Analytics tools

This helps understand the target environment.

---

## Example Workflow

1. Perform WHOIS lookup on target domain.
2. Enumerate subdomains.
3. Search target on Shodan.
4. Use Google search for public assets.
5. Document all findings.

---

## Example Findings

- Domain active for 8 years
- dev.example.com discovered
- Port 22 and 443 exposed
- Public employee PDF indexed
- WordPress CMS detected

---

## Conclusion

Reconnaissance is an important first step in security testing. It helps identify assets, services, technologies, and possible weak points before further assessment begins.

Using tools such as Shodan, WHOIS, subdomain finders, and search engines allows analysts to better understand the target’s public attack surface.
