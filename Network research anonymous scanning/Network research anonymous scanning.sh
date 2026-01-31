#!/bin/bash
#1. Installations and Anonymity Check
#1.1 Install the needed applications.
#1.2 If the applications are already installed, don’t install them again.
function ROOT()
{	 
	if [ "$(whoami)" == "root" ]
	then 
		echo "[(:] you are root"
	else
		echo "[!] you are not root,exiting..."
		exit 
	fi 
}			
figlet "welcome  to  my  script"
#3.2 Create a log and audit your data collecting.
LOG_FILE="scan_log.txt"

# This function receives a message (a text string) as an argument
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] - $1" >> "$LOG_FILE"
}
function INSTALL() {
    echo "--- Checking tools ---"
  if [ ! -z "$(find / -type d -name "nipe" 2>/dev/null | head -n 1)" ]
   then
        echo "[(:] Nipe directory already exists.it is installed."
    else
        echo "[!] Nipe is not installed. Starting installation..."
        
        echo "[*] Installing necessary tools to use nipe: git, perl"
        sudo apt-get update -y > /dev/null 2>&1
        sudo apt-get install -y git cpanminus libwww-perl libjson-perl > /dev/null 2>&1

        echo "[*] Cloning Nipe from GitHub into your home directory..."
        git clone https://github.com/htrgouvea/nipe.git "$HOME/nipe"
        
        if [ -d "$HOME/nipe" ]; then
            cd "$HOME/nipe"
            echo "[*] installing all the modules that Nipe depends on"
            sudo cpanm --notest Switch JSON LWP::UserAgent Config::Simple

            echo "[*] Running Nipe's main installer..."
            sudo perl nipe.pl install
            
            if [ -f "$HOME/nipe/nipe.pl" ]; then
                echo "[(:] Nipe installation was SUCCESSFUL."
            else
                echo "[):] Nipe installation FAILED. Please check for errors."
                exit 1
            fi
            cd - > /dev/null
        else
            echo "[):] FAILED to clone Nipe from GitHub. Please check your internet connection."
            exit 1
        fi
    fi   	     
	for pkg in  nmap geoip-bin sshpass figlet
		do
	if dpkg -l "$pkg" >/dev/null 2>&1 
	    then
	     echo "[(:]$pkg is installed"
	     sleep 2
	    else
	     echo "[!]$pkg is not installed now installing"
	      sudo apt update -y >/dev/null 2>&1
      sudo apt install -y "$pkg"
	if dpkg -s "$pkg" >/dev/null 2>&1
	    then
		 echo "[(:]$pkg installation SUCCESS"
		else
	     echo "[):]$pkg installation FAILED"
		fi
	fi	
 
 
 done 
}
#1.3 Check if the network connection is anonymous; if not, alert the user and exit.
#1.4 If the network connection is anonymous, display the spoofed country name.
function ANON() {

	 IP=$(curl -s ifconfig.co) # public IP
	 CN=$(geoiplookup $IP| awk '{print $4}' |tr -d ",")  # country code of IP

	 if [ "$CN" == "IL" ]
	 then
		   echo "[!!!]NOT anonymous - IP is from IL taking action,connecting to nipe...."
		   #finding nipe
		   NIPE_PATH=$(find / -type d -name "nipe" 2>/dev/null | head -n 1) 
		   cd $NIPE_PATH
		    perl nipe.pl restart 
		    perl nipe.pl restart 
		    perl nipe.pl restart 
		    ANON
	 else 
			echo "you are anonymous Country: $CN"
	 fi
   

}
#1.5 Allow the user to specify the address to scan via remote server; save into a variable.
#2. Automatically Connect and Execute Commands on the Remote Server via SSH
function RMSCAN()
 {
    echo "you are all set Starting Remote Scan process..."
    read -p "[*] enter remote ssh username:" SSH_USER
    read -p "[*] Enter the remote server password:" SSH_PASS
    read -p "[*] Enter the remote server public IP address:" SSH_IP
    echo "Target ip/domain is : $SSH_IP"
    #2.1 Display the details of the remote server (country, IP, and Uptime).
     REMOTE_IP=$(sshpass -p "$SSH_PASS"  ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_IP "curl -s ifconfig.co")
    REMOTE_COUNTRY=$(sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_IP "geoiplookup $REMOTE_IP" | awk '{print $5}')
    REMOTE_UPTIME=$(sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_IP "uptime")
    echo "--- Remote Server Details---"
    echo "IP: $REMOTE_IP"
    sleep 2
    echo "Country: $REMOTE_COUNTRY"
    sleep 2
    echo "Uptime: $REMOTE_UPTIME"
    sleep 2
    echo 
    sleep 2
     # --- Start Logging ---
    log_message "Scan started ."
    log_message "Remote server used: $REMOTE_IP ($REMOTE_COUNTRY)"
    log_message "Target address: $SSH_IP"
    log_message "remote uptime is: $REMOTE_UPTIME"
    
    
     #2.2 Get the remote server to check the Whois of the given address +3.1(logging)
    echo "[*] starting remote Whois scan on target: $SSH_IP"
    sshpass -p "$SSH_PASS" ssh -o StrictHostKeyChecking=no $SSH_USER@$SSH_IP "whois $SSH_IP" >>whois_data.txt
    echo "[*] Whois results saved to local file: whois_data.txt"
    log_message "Whois scan finished. Output saved to whois_data.txt."
    
     #2.3 Get the remote server to scan for open ports on the given address +3.1(logging)
    echo "[*] starting remote Nmap scan on target: $SSH_IP (This may take some time...)"
    sshpass -p "$SSH_PASS" ssh $SSH_USER@$SSH_IP "nmap -A $SSH_IP" >> nmap_data.txt
    echo "[*] Nmap results saved to local file: nmap_data.txt"
    log_message "Nmap scan performed. Output saved to nmap_data.txt."

 echo "Scan Complete See $LOG_FILE for info"
    log_message "Scan finished (:."

echo "[!] would you like to Display the files you have created ? (y/n)"
read -r answer

if [[ "$answer" =~ ^[yY] ]]; then
    
    echo ""
    echo "[*] Displaying ALL files..."

    echo "---[ whois_data.txt ]---"
    cat whois_data.txt
    sleep 5
    
    echo ""
    
    echo "---[ nmap_data.txt ]---"
    cat nmap_data.txt
    sleep 5
    echo ""

    echo "---[ scan_log.txt  ]---"
    cat scan_log.txt 
    
else
    echo "[*] Exiting without displaying files."
    exit 0
fi

# The script continues here if the user answered 'y'
    
    

    
}
ROOT
INSTALL 
ANON
RMSCAN



