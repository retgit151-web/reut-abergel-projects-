# Automated Security Log Parser

## 1. Introduction
A high-performance Python-based security auditing tool designed to transform dense Linux authentication logs (/var/log/auth.log)
into actionable intelligence. This script automates the detection of unauthorized access patterns and account lifecycle changes.

## 2. Key Features
* **Real-Time Parsing:** Iterates through system logs to extract timestamps, usernames, and commands.
* **Blacklist Alerting:** Automatically flags high-risk activities such as nmap, netcat, and attempts to access /etc/shadow.
* **Privilege Auditing:** Tracks sudo and su usage, distinguishing between successful sessions and failed authentication attempts.
* **Account Monitoring:** Detects and reports the creation or deletion of user accounts.
* **Data Sanitization:** Uses advanced string manipulation to remove technical noise (e.g., UIDs) for human-readable reporting.

## 3. Technical Skills Demonstrated
* **Python Programming:** Advanced use of split(), join(), and replace() for unstructured data parsing.
* **Error Handling:** Implementation of try...except blocks to ensure script resilience against malformed log entries.
* **Security Logic:** Translation of indicators of compromise (IOCs) into automated detection patterns.

## 4. Requirements
* Linux OS (Debian/Kali) with rsyslog.
* Python interpreter.
* Root/Sudo privileges (to read protected log files).
