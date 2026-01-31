#!/bin/bash

 echo "==>displaying the user information on kali<=="
 
 #Identify the system's public IP
 echo "[=>]system public ip is:$(curl -s ifconfig.me)"
 
 #Identify the private IP address assigned to the system's network interface
 echo "[=>]this is the user privte ip:$(hostname -I)"
 
 #display the mac address 
 echo "[=>]this is the system mac address:$(ifconfig eth0 |grep ether |awk '{print $2}')" 
 
 #Display the percentage of CPU usage for the top 5 processes.
 echo '[=>]the percentage of CPU usage for the top 5 processes is:'
top -b -n 1 -o %CPU | sed -n '8,12p'

#Display memory usage statistics: total and available memory
echo '[=>]this is the memory usege statistics:'
 free -h | awk 'NR==1{print "Total","Available"} NR==2{print $2,$7}'

#List active system services with their status
echo '[=>]**the runing services and there names are:'
systemctl list-units --type=service --state=running |awk '{print $1,$4}' |tail -27|head -21

#Locate the Top 10 Largest Files in /home
echo '[=>]**this are the top 10 largest files in the /home directory'
find /home -type f -exec du -h {} + 2>/dev/null | sort -hr | head -n 10
