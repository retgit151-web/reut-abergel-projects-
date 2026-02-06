#!/bin/bash


BOLD='\033[1m'
RED='\033[0;31m'    # Muted Crimson
GREEN='\033[0;32m'  # Forest Green
YELLOW='\033[0;33m' # Muted Gold/Brown
BLUE='\033[0;34m'   # Deep Blue
CYAN='\033[0;36m'   # Dark Teal
WHITE='\033[0;37m'  # Light Gray
GRAY='\033[1;30m'   # Dim Gray
NC='\033[0m'

# Refined Status Indicators
OK="${GREEN}[+]${NC}"
INFO="${GRAY}[*]${NC}"


#Network Information
function NET_INFO() 
{
    echo -e "${BOLD}${BLUE}==> displaying the user information on kali <==${NC}"
    #Identify the system's public IP
    echo -e "${INFO} system public ip is: ${CYAN}$(curl -s ifconfig.me)${NC}"
    #Identify the private IP address 
    echo -e "${INFO} this is the user private ip: ${CYAN}$(hostname -I)${NC}"
    #display the mac address 
    echo -e "${INFO} this is the system mac address: ${CYAN}$(ifconfig eth0 | grep ether | awk '{print $2}')${NC}" 
}

#System Statistics 
function SYS_STATS() 
{
    #Display the percentage of CPU usage for the top 5 processes.
    echo -e "\n${BOLD}${WHITE}[=>] the percentage of CPU usage for the top 5 processes is:${NC}"
    top -b -n 1 -o %CPU | sed -n '8,12p'

    #Display memory usage statistics: total and available memory
    echo -e "\n${BOLD}${WHITE}[=>] this is the memory usage statistics:${NC}"
    free -h | awk -v gray="$GRAY" -v white="$WHITE" -v nc="$NC" 'NR==1{print gray "Total      Available" nc} NR==2{print white $2 "       " $7 nc}'

    #List active system services with their status
    echo -e "\n${BOLD}${WHITE}[=>] active system services (Top 20):${NC}"
    systemctl list-units --type=service --state=running | awk -v green="$GREEN" -v nc="$NC" '{print "+ " $1 " " green $4 nc}' | tail -27 | head -21
}

#File Analysis
function FILE_ANALYSIS()
 {
    #Locate the Top 10 Largest Files in /home
    echo -e "\n${BOLD}${WHITE}[=>] top 10 largest files in the /home directory:${NC}"
    find /home -type f -exec du -h {} + 2>/dev/null | sort -hr | head -n 10
}

# INTERACTIVE MENU
function SHOW_MENU() 
{
    clear
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${BOLD}   LINUX INFO AUTOMATION TOOL   ${NC}"
    echo -e "${BLUE}=========================================${NC}"
    echo -e "${WHITE}1.${NC} Network Information (IP/MAC)"
    echo -e "${WHITE}2.${NC} System Statistics (CPU/Mem/Services)"
    echo -e "${WHITE}3.${NC} File Analysis (Largest Files)"
    echo -e "${WHITE}4.${NC} Run Full Scan (All)"
    echo -e "${WHITE}5.${NC} Exit"
    echo -e "${BLUE}-----------------------------------------${NC}"
    
    read -p "$(echo -e ${INFO}" Select an option [1-5]: "${NC})" CHOICE
    
    case $CHOICE in
        1)
            NET_INFO
            ;;
        2)
            SYS_STATS
            ;;
        3)
            FILE_ANALYSIS
            ;;
        4)
            NET_INFO
            SYS_STATS
            FILE_ANALYSIS
            ;;
        5)
            echo -e "${OK} Exiting tool. Goodbye!"
            exit 0
            ;;
        *)
            echo -e "${RED}[!] Invalid option. Please try again.${NC}"
            sleep 1
            SHOW_MENU
            ;;
    esac
}
SHOW_MENU
