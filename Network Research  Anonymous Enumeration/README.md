# Network Research: Anonymous Enumeration

[cite_start]**Author:** Reut Abergel [cite: 1]  
[cite_start]**Unit:** TMagen7736.38 [cite: 3] | [cite_start]**Program Code:** NX201 [cite: 4]  
[cite_start]**Project:** Network Research [cite: 5]

---

## 📖 Introduction
[cite_start]This project is an automated network reconnaissance tool designed to streamline the intelligence-gathering phase of a security engagement[cite: 16]. [cite_start]It automates the setup of a secure environment, ensures attacker anonymity, and executes remote scans against target IP addresses[cite: 26].

[cite_start]The script transforms a complex manual process—involving tool installation, IP masking, and SSH piping—into a single, automated workflow[cite: 81].

## 🎯 Purpose & Key Goals
[cite_start]The primary goal is to perform `Nmap` and `Whois` scans while strictly adhering to two security principles[cite: 77]:

1.  **Attacker Anonymity:** The script verifies that the host machine is not exposing an Israeli IP ("IL"). [cite_start]If an Israeli IP is detected, it automatically utilizes **Nipe** to mask the address before proceeding[cite: 18, 78].
2.  [cite_start]**Audit Trail & Documentation:** It generates a reliable audit trail by saving all outputs to specific data files (`whois_data.txt`, `nmap_data.txt`) and maintaining a timestamped execution log (`scan_log.txt`) [cite: 20-22, 79].

---

## 🛠 Features
* [cite_start]**Privilege Management:** Automatically checks for Root/Sudo permissions required for network operations[cite: 19, 33].
* [cite_start]**Dependency Management:** Automatically detects and installs missing dependencies: `nmap`, `geoip-bin`, `sshpass`, `figlet`, `nipe` [cite: 40-41].
* **Geo-IP Anonymity Logic:** Uses `geoiplookup` to verify the country of origin. [cite_start]If "IL" is detected, it restarts Nipe and recurses until the IP is anonymous [cite: 53-54, 177-178].
* [cite_start]**Remote Scanning:** Connects to a remote server via SSH to execute commands, decoupling the attacker from the target[cite: 26, 35].
* [cite_start]**Centralized Logging:** Uses a custom function to append precise timestamps to every action taken by the script[cite: 22, 90].

---

## 📋 Prerequisites
[cite_start]To run this tool successfully, you need[cite: 31]:
* [cite_start]**Operating System:** Kali Linux (VM or hardware) to utilize `apt` for package management[cite: 32].
* [cite_start]**Permissions:** Root or Sudo access[cite: 33].
* [cite_start]**Connectivity:** Active internet connection for downloading tools and remote server communication[cite: 34].
* [cite_start]**Remote Infrastructure:** A secondary Kali Linux machine or VPS with SSH access (Username, Password, and IP)[cite: 35].

---

## 🚀 Usage Guide

### 1. Installation & Setup
Clone the repository and ensure the script has executable permissions.

### 2. Execution
[cite_start]Run the script using sudo privileges [cite: 37-38]:
```bash
sudo ./Network_Research_Anonymous_Enumeration
