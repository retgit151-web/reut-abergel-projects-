Network Research: Anonymous Enumeration
A professional Bash-based automation tool for secure network reconnaissance. This script streamlines the process of environment setup, anonymity verification, and remote target scanning using Nmap and Whois.

🎯 Purpose
The script is designed to perform network scans while strictly adhering to two security principles:


Attacker Anonymity: Ensuring the user's public IP is masked via Nipe before any scanning activity begins.


Professional Documentation: Automatically generating timestamped logs and data files required for an audit trail and final engagement reports.

🛠 Features

Privilege Management: Automatically verifies root/sudo permissions, which are required for network operations and tool installations.


Automatic Dependency Resolution: Checks for and installs all necessary tools: nmap, geoip-bin, sshpass, figlet, and nipe.


Geo-IP Anonymity Check: If the script detects a public IP originating from Israel ("IL"), it automatically activates Nipe to route traffic through the Tor network.


Remote Scanning: Connects to a remote server via SSH to perform the enumeration from a secondary location, further decoupling the attacker from the target.


Centralized Logging: Uses a custom logging function to document every step with a precise timestamp.

📋 Prerequisites

OS: Kali Linux (for apt package management).


Permissions: Root or Sudo access.


Connectivity: Active internet connection.


Remote Target: A secondary Linux machine or VPS with SSH access (IP, Username, and Password).

🚀 Usage
Clone and Prepare:

Bash
git clone <your-repository-link>
cd <repository-folder>
chmod +x Network_Research_Anonymous_Enumeration.sh
Execute the Script:

Bash
sudo ./Network_Research_Anonymous_Enumeration.sh
Provide Inputs: When prompted, enter the remote SSH credentials and the target IP address to begin the automated scan.

📁 Output Files
The script generates three local files for analysis:


whois_data.txt: Detailed Whois information of the target.


nmap_data.txt: Comprehensive Nmap scan results.


scan_log.txt: A full, timestamped audit trail of the script's execution.

🔍 Technical Deep Dive
Core Functions 


ROOT(): Validates administrative privileges to allow tool installation and network masking.


INSTALL(): Uses dpkg and find to ensure all software dependencies are met.

ANON(): Performs a Geo-IP lookup. If the country code matches "IL", it restarts Nipe and uses recursion to re-verify anonymity.


RMSCAN(): The main engine that gathers user input, connects to the remote server using sshpass, and executes the scans.


log_message(): A utility function that appends formatted, timestamped messages to the log file.

Key Logic: IP Masking
The script uses the following command to isolate the country code from the public IP:

Bash
CN=$(geoiplookup $(curl -s ifconfig.co) | awk '{print $4}' | tr -d ',')
If the result is IL, the ANON function triggers the Nipe restart process.


Developer: Reut Abergel
