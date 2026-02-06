# Automated Security Log Parser

## 1. Introduction
[cite_start]A high-performance Python-based security auditing tool designed to transform dense Linux authentication logs (`/var/log/auth.log`) into 
actionable intelligence[cite: 25, 27]. [cite_start]This script automates the detection of unauthorized access patterns and account lifecycle changes[cite: 29, 30].

## 2. Key Features
* [cite_start]**Real-Time Parsing:** Iterates through system logs to extract timestamps, usernames, and commands[cite: 28, 47].
* [cite_start]**Blacklist Alerting:** Automatically flags high-risk activities such as `nmap`, `netcat`, and attempts to access `/etc/shadow`[cite: 49, 50].
* [cite_start]**Privilege Auditing:** Tracks `sudo` and `su` usage, distinguishing between successful sessions and failed authentication attempts[cite: 53].
* [cite_start]**Account Monitoring:** Detects and reports the creation or deletion of user accounts[cite: 52].
* [cite_start]**Data Sanitization:** Uses advanced string manipulation to remove technical noise (e.g., UIDs) for human-readable reporting[cite: 91, 109].

## 3. Technical Skills Demonstrated
* [cite_start]**Python Programming:** Advanced use of `split()`, `join()`, and `replace()` for unstructured data parsing[cite: 182].
* [cite_start]**Error Handling:** Implementation of `try...except` blocks to ensure script resilience against malformed log entries[cite: 93, 184].
* [cite_start]**Security Logic:** Translation of indicators of compromise (IOCs) into automated detection patterns[cite: 183].

## 4. Requirements
* [cite_start]Linux OS (Debian/Kali) with `rsyslog`[cite: 38].
* [cite_start]Python interpreter[cite: 39].
* [cite_start]Root/Sudo privileges (to read protected log files)[cite: 40].
