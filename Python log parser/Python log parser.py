import os
import sys

failed_attempts = 0
sudo_usage_count = 0
su_usage_count = 0
suspicious_words = ['etc/shadow', 'nmap', 'nc', 'cat /etc/passwd', 'chmod 777']

# Check if file exists
if not os.path.exists('/var/log/auth.log'):
    print("[!!!]Error: file not found please download rsyslog using:sudo apt-get install rsyslog[!!!]")
    sys.exit()

# 1. Log Parse auth.log: Extract command usage.
print("---auth log parsing resultes---")

with open('/var/log/auth.log') as f:
    for line in f:
        # spliting the lines
        spliting = line.split()

        # Safety check: skip empty lines to prevent crashes
        if len(spliting) < 1:
            continue
        
        # 1.1. Include the Timestamp.    
        timestamp = spliting[0]

        # Check for suspicious words
        for word in suspicious_words:
            if word in line:
                print(f"!!! RED FLAG DETECTED !!!Time=[{timestamp}]| suspicus word detected:'{word}' ")
        
        if 'COMMAND' in line:
            try:
                # 1.2. Include the executing user (i add area of execution it seemd also importent to me)
                area = spliting[7]
                user = spliting[3]
                
                # 1.3. Include the command
                command = " ".join(spliting[11:])       
                print(f"Time=[{timestamp}] | {area} | USER={user} | {command}")
            except IndexError: # decided to put it in every elif incase of an error so the script wont stop 
                continue

        # 2. Log Parse auth.log: Monitor user authentication changes.
        # 2.1. Print details of newly added users, including the Timestamp.
        elif "new user: name=" in line:
            try:
                usernameD = line.split('name=')[1].split(',')[0]
                usernameC = usernameD.split(",")[0]
                print(f"Time=[{timestamp}] | New User created: New User: {usernameC}")
            except IndexError:
                pass
         
        # 2.2. Print details of deleted users, including the Timestamp.
        elif "delete user" in line:
            try:
                username = line.split('user')[2].strip()
                print(f"Time=[{timestamp}] | user {username} Deleted ") 
            except IndexError:
                pass

        # 2.3. Print details of changing passwords, including the Timestamp.        
        elif "password changed" in line:
            try:
                usergrep = line.split('password')[1].strip()
                print(f"Time=[{timestamp}] | password {usergrep}")
            except IndexError:
                pass 

        # 2.4. Print details of when users used the su command.
        elif "pam_unix(su:session)" in line:
            try:        
                rootgrep = line.split('pam_unix(su:session)')[1].strip()
                clean_msg = rootgrep.replace('(uid=0)', '').replace('(uid=0)', '')
                print(f"Time=[{timestamp}] | note!!{clean_msg} using su")
                su_usage_count += 1
            except IndexError:
                pass

        # 2.5. Print details of users who used the sudo; include the command.
        elif "pam_unix(sudo:session)" in line:
            try:        
                rootgrep2 = line.split('pam_unix(sudo:session)')[1].strip()
                clean_msg2 = rootgrep2.replace('(uid=0)', '').replace('(uid=1000)', '')
                print(f"Time=[{timestamp}] | note!!{clean_msg2} using sudo")
                sudo_usage_count += 1
            except IndexError:
                pass 

        # 2.6. Print ALERT! If users failed to use the sudo command; include the command.  
        elif "pam_unix(sudo:auth)" in line:
            try:
                arrange = line.split('kali', 1)[1]
                clean_msg3 = arrange.replace('uid=1000', '').replace('euid=0', '').replace('tty=/dev/pts/1', '').replace(';', '').strip()
                print(f"Time=[{timestamp}] |!!!!!ALERT!!!!! {clean_msg3}")
                failed_attempts += 1
            except IndexError:
                pass 

print("-" * 40)
print("summary")
print("-" * 40)
print(f"!!failed login attempt Alerts!!: {failed_attempts}")
print(f"sudo sessions: {sudo_usage_count}")
print(f"su sessions: {sudo_usage_count}")
