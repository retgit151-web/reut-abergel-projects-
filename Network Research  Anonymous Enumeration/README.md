# Anonymous Enumeration Tool

## 1. Introduction
A security-focused network reconnaissance tool that automates Nmap and Whois scans while strictly enforcing operator anonymity. The script is built 
on the principle of Attacker Anonymity, ensuring no scans are performed from an exposed local IP.

## 2. Key Features
* **Anonymity Enforcement:** Automatically detects if the public IP is from Israel if so, it utilizes Nipe to mask the address before proceeding.
* **Recursive Verification:** Continuously verifies the network status until anonymity is confirmed.
* **Automated Reconnaissance:** Executes Whois for domain details and Nmap for network discovery on remote targets.
* **SSH Automation:** Uses sshpass and disabled StrictHostKeyChecking for non-interactive remote command execution.
* **Standardized Logging:** Maintains a chronological audit trail (scan_log.txt) with precise timestamps for after-action review.

## 3. Technical Skills Demonstrated
* **Network Intelligence:** Programmatic retrieval and parsing of geolocation and IP data.
* **Automated Environment Setup:** Scripted detection, cloning, and installation of GitHub repositories and system packages.
* **Secure Data Management:** Implementation of structured logging and data redirection streams.

## 4. Requirements
* Kali Linux.
* Root/Sudo privileges.
* Target SSH credentials.
