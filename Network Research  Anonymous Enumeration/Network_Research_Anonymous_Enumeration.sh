#!/bin/bash

# Bold for emphasis, standard colors for status tags
BOLD='\033[1m'
RED='\033[1;31m'     # Errors / Danger
GREEN='\033[1;32m'   # Success
YELLOW='\033[1;33m'  # Warnings / Process
BLUE='\033[1;34m'    # Information / Headers
CYAN='\033[1;36m'    # Data / Variables
WHITE='\033[1;37m'   # Standard text highlights
NC='\033[0m'         # No Color (Reset)

# Status Indicators
OK="${GREEN}[+]${NC}"
INFO="${BLUE}[*]${NC}"
WARN="${YELLOW}[!]${NC}"
ERR="${RED}[-]${NC}"
# -------------------------

#1. Installations and Anonymity Check
function ROOT()
{   
    if [ "$(whoami)" == "root" ]
    then 
        echo -e "${OK} User is ${BOLD}root${NC}"
    else
        echo -e "${ERR} You are not root, exiting..."
        exit 
    fi 
}           

# Banner in Cyan 
echo -e "${CYAN}$(figlet "Anonymous Scan")${NC}"
echo -e "${BLUE}:: Automated Enumeration & Anonymity Tool ::${NC}"
echo ""

#3.2 Create a log
LOG_FILE="scan_log.txt"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - $1" >> "$LOG_FILE"
}

function INSTALL() 
{
    echo -e "${BOLD}--- Checking Dependencies ---${NC}"
  
  if [ ! -z "$(find / -type d -name "nipe" 2>/dev/null | head -n 1)" ]
   then
        echo -e "${OK} Nipe directory found."
    else
        echo -e "${WARN} Nipe is not installed. Starting installation..."
        
        echo -e "${INFO} Installing tools: ${WHITE}git, perl${NC}"
        sudo apt-get update -y > /dev/null 2>&1
        sudo apt-get install -y git cpanminus libwww-perl libjson-perl > /dev/null 2>&1

        echo -e "${INFO} Cloning Nipe from GitHub..."
        git clone https://github.com/htrgouvea/nipe.git "$HOME/nipe"
        
        if [ -d "$HOME/nipe" ]
         then
            cd "$HOME/nipe"
            echo -e "${INFO} Installing Nipe dependencies..."
            sudo cpanm --notest Switch JSON LWP::UserAgent Config::Simple

            echo -e "${INFO} Running Nipe installer..."
            sudo perl nipe.pl install
            
            if [ -f "$HOME/nipe/nipe.pl" ]
             then
                echo -e "${OK} Nipe installation ${GREEN}SUCCESSFUL${NC}."
            else
                echo -e "${ERR} Nipe installation ${RED}FAILED${NC}."
                exit 1
            fi
            cd - > /dev/null
        else
            echo -e "${ERR} FAILED to clone Nipe."
            exit 1
        fi
    fi                  
    
    for pkg in  nmap geoip-bin sshpass figlet
        do
    if dpkg -l "$pkg" >/dev/null 2>&1 
    then
     echo -e "${OK} Package ${WHITE}$pkg${NC} is installed."
     sleep 0.5
    else
     echo -e "${WARN} Package ${WHITE}$pkg${NC} is missing. Installing..."
      sudo apt update -y >/dev/null 2>&1
      sudo apt install -y "$pkg"
    if dpkg -s "$pkg" >/dev/null 2>&1
    then
         echo -e "${OK} ${WHITE}$pkg${NC} installation ${GREEN}SUCCESS${NC}"
        else
     echo -e "${ERR} ${WHITE}$pkg${NC} installation ${RED}FAILED${NC}"
        fi
    fi  
 done 
}

#1.3/1.4 Anonymity Check
function ANON() 
{
     echo -e "\n${BOLD}--- Network Anonymity Check ---${NC}"
     IP=$(curl -s ifconfig.co) 
     if [ -z "$IP" ]
      then
        echo -e "${ERR} Could not fetch IP. Retrying..." 
        sleep 5
        ANON
        return
     fi
     
     CN=$(geoiplookup $IP| awk '{print $4}' |tr -d ",") 

     if [ "$CN" == "IL" ]
     then
           echo -e "${RED}[!!!] ALERT:${NC} IP is from ${RED}IL${NC}. Connecting to Nipe..."
           NIPE_PATH=$(find / -type d -name "nipe" 2>/dev/null | head -n 1) 
           cd $NIPE_PATH
            perl nipe.pl restart 
            perl nipe.pl restart 
            perl nipe.pl restart 
            ANON
     else 
            echo -e "${OK} Status: ${GREEN}Anonymous${NC} | Country: ${WHITE}$CN${NC}"
     fi
}

#2. Remote Scan
function RMSCAN()
 {
    echo -e "\n${BOLD}--- Remote Target Configuration ---${NC}"
    
    # We use echo -n for input to keep the cursor on the same line nicely
    echo -e -n "${INFO} Enter remote ssh username: "
    read SSH_USER
    
    echo -e -n "${INFO} Enter remote server password: "
    read -s SSH_PASS # -s hides the password typing for security
    echo "" 
    
    echo -e -n "${INFO} Enter remote server IP: "
    read SSH_IP
    
    echo -e "${INFO} Target locked: ${CYAN}$SSH_IP${NC}"
    
    #2.1 Display Details
    REMOTE_IP=$(sshpass -p "$SSH_PASS"  ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_IP "curl -s ifconfig.co")
    REMOTE_COUNTRY=$(sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_IP "geoiplookup $REMOTE_IP" | awk '{print $5}')
    REMOTE_UPTIME=$(sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_IP "uptime")
    
    echo -e "\n${BOLD}--- Remote Server Recon ---${NC}"
    echo -e "IP Address : ${CYAN}$REMOTE_IP${NC}"
    sleep 1
    echo -e "Location   : ${CYAN}$REMOTE_COUNTRY${NC}"
    sleep 1
    echo -e "Uptime     : ${WHITE}$REMOTE_UPTIME${NC}"
    sleep 1
    
    log_message "Scan started."
    log_message "Remote used: $REMOTE_IP ($REMOTE_COUNTRY)"
    
    #2.2 Whois
    echo -e "\n${INFO} Starting ${BOLD}Whois${NC} scan on ${CYAN}$SSH_IP${NC}..."
    sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_IP "whois $SSH_IP" >>whois_data.txt
    echo -e "${OK} Whois data saved to: ${WHITE}whois_data.txt${NC}"
    log_message "Whois saved."
    
    #2.3 Nmap
    echo -e "${INFO} Starting ${BOLD}Nmap${NC} scan on ${CYAN}$SSH_IP${NC} (Please wait...)"
    sshpass -p "$SSH_PASS" ssh $SSH_USER@$SSH_IP "nmap -A $SSH_IP" >> nmap_data.txt
    echo -e "${OK} Nmap results saved to: ${WHITE}nmap_data.txt${NC}"
    log_message "Nmap saved."

    echo -e "\n${GREEN}✔ Scan Process Complete.${NC} Log updated."
    log_message "Scan finished."

    echo -e "\n${WARN} Display created files? (y/n)"
    read -r answer


    if [[ "$answer" =~ ^[yY] ]]
     then
        echo -e "\n${BOLD}=== [ whois_data.txt ] ===${NC}"
        cat whois_data.txt | head -n 20 # Only showing first 20 lines to keep it clean
        echo -e "${CYAN}... (output truncated) ...${NC}"
        sleep 2
        
        echo -e "\n${BOLD}=== [ nmap_data.txt ] ===${NC}"
        cat nmap_data.txt
        sleep 2

        echo -e "\n${BOLD}=== [ scan_log.txt ] ===${NC}"
        cat scan_log.txt 
    else
        echo -e "${INFO} Exiting."
        exit 0
    fi
}

ROOT
INSTALL 
ANON
RMSCAN
INSPCT
