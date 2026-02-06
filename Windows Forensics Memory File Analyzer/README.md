# Automated Memory Analyzer

## 1. Introduction
An end-to-end forensics automation script that streamlines the extraction and analysis of raw memory dumps. This tool integrates industry-standard
utilities to provide a rapid triage of system state and artifacts.

## 2. Key Features
* **Multi-Tool File Carving:** Parallel execution of Binwalk, Foremost, Bulk Extractor, and Scalpel to recover hidden files and signatures.
* **Memory Analysis Integration:** Automates Volatility to parse RAM for running processes, network connections, and registry hives.
* **Intelligent Profiling:** Automatically identifies the correct OS profile via imageinfo to execute subsequent Volatility plugins.
* **Dynamic Configuration:** Programmatically modifies tool configuration files using sed to target specific evidence types (e.g., .jpg, .pdf).
* **Automated Dependency Management:** Checks for and installs required forensics tools and Volatility binaries.

## 3. Technical Skills Demonstrated
* **Advanced Bash Scripting:** Modular function design and complex tool chaining.
* **Stream Editing:** Professional use of sed and awk for dynamic system configuration and output parsing.
* **Evidence Integrity:** Structured, timestamped reporting with automated ZIP archiving for secure transport.

## 4. Requirements
* Kali Linux.
* Root privileges.
* Active internet connection for standalone binary retrieval.
