# Network Research: Anonymous Enumeration

**Author:** Reut Abergel  
**Unit:** TMagen7736.38 | **Program Code:** NX201  
**Project:** Network Research

---

## 📖 Introduction
This project is an automated network reconnaissance tool designed to streamline the intelligence-gathering phase of a security engagement. It automates the setup of a secure environment, ensures attacker anonymity, and executes remote scans against target IP addresses.

The script transforms a complex manual process—involving tool installation, IP masking, and SSH piping—into a single, automated workflow.

## 🎯 Purpose & Key Goals
The primary goal is to perform `Nmap` and `Whois` scans while strictly adhering to two security principles:

1.  **Attacker Anonymity:** The script verifies that the host machine is not exposing an Israeli IP ("IL"). If an Israeli IP is detected, it automatically utilizes **Nipe** to mask the address before proceeding.
2.  **Audit Trail & Documentation:** It generates a reliable audit trail by saving all outputs to specific data files (`whois_data.txt`, `nmap_data.txt`) and maintaining a timestamped execution log (`scan_log.txt`).

---

## 🛠 Features
* **Privilege Management:** Automatically checks for Root/Sudo permissions required for network operations.
* **Dependency Management:** Automatically detects and installs missing dependencies: `nmap`, `geoip-bin`, `sshpass`, `figlet`, `nipe`.
* **Geo-IP Anonymity Logic:** Uses `geoiplookup` to verify the country of origin. If "IL" is detected, it restarts Nipe and recurses until the IP is anonymous.
* **Remote Scanning:** Connects to a remote server via SSH to execute commands, decoupling the attacker from the target.
* **Centralized Logging:** Uses a custom function to append precise timestamps to every action taken by the script.

---

## 📋 Prerequisites
To run this tool successfully, you need:
* **Operating System:** Kali Linux (VM or hardware) to utilize `apt` for package management.
* **Permissions:** Root or Sudo access.
* **Connectivity:** Active internet connection for downloading tools and remote server communication.
* **Remote Infrastructure:** A secondary Kali Linux machine or VPS with SSH access (Username, Password, and IP).

---

## 🚀 Usage Guide

### 1. Installation & Setup
Clone the repository and ensure the script has executable permissions.

### 2. Execution
Run the script using sudo privileges:
```bash
sudo ./Network_Research_Anonymous_Enumeration
