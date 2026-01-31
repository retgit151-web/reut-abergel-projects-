#!/bin/bash

function START ()
{
	figlet "welcome to WF proj"
    #3.1 setup 
    START_TIME=$(date +%s)
    
    #1.1 Check the current user; exit if not ‘root’
    if [ "$(whoami)" != "root" ]
    then 
        echo "[):]you are not root"
        exit 1
    fi
    echo "[(:]you are root"
    
    #1.2 Allow the user to specify the filename; check if the file exists.
    read -p "[(:]please write mem file: " MEM_FILE
    # export makes sure that other functions can see the Variable 
    export MEM_FILE
    
    echo "[!]the memory file to analyze is: $MEM_FILE"
    
    if [ -f "$MEM_FILE" ]
     then
        echo "[(:]file exists"
    else 
        echo "[!!]file does not exists"
        exit 1
    fi 

     ##1.5 Data should be saved into a directory.
     export RESULTS_DIR="forensics_output_$(date +%F_%H-%M-%S)"
    
    sudo rm -rf $RESULTS_DIR
    mkdir -p "$RESULTS_DIR/memory_analsys_post_carving"
    echo "All results will be saved in: $RESULTS_DIR"
    
    export REPORT_FILE="$RESULTS_DIR/main_report.txt"

    echo "Forensics Report for Case: $MEM_FILE" > "$REPORT_FILE"
    echo "Date Started: $(date)" >> "$REPORT_FILE"
    echo "--------------------------------------" >> "$REPORT_FILE"
   
}

function INSTALL()
{
    #1.3 Create a function to install the forensics tools if missing
    echo "--- Checking tools ---"
    if [ -f "vol" ] 
    then
        echo "[(:] volatility directory already installed."
    else 
        echo "[!] volatility is not installed. Starting installation into your current directory..."
        wget http://downloads.volatilityfoundation.org/releases/2.6/volatility_2.6_lin64_standalone.zip
        unzip -o volatility_2.6_lin64_standalone.zip    
        echo "[*]Running volatility help manuel and adujsting name..."
        mv volatility_2.6_lin64_standalone/volatility_2.6_lin64_standalone vol 
        rm -rf volatility_2.6_lin64_standalone
        rm volatility_2.6_lin64_standalone.zip
        
        
        if [ -f "vol" ]
         then
            echo "[(:] volatility installation was SUCCESSFUL."
        else
            echo "[):] volatility installation FAILED. Please check for errors."
            exit 1
        fi
    fi
    
    APPS="foremost strings binwalk scalpel bulk_extractor exiftool"
    for tools in $APPS
     do
        if command -v $tools >/dev/null 2>&1
         then 
            echo "[(:] $tools is installed"
        else 
            echo "[!] $tools is not installed"
            echo "[#] installing $tools"
            apt-get install -y $tools
        fi
    done        
}

function VOL()
{ 
    #2.1 Check if the file can be analyzed in Volatility if yes, run Volatility 
    mkdir -p "$RESULTS_DIR/memory"
    
    if ./vol -f "$MEM_FILE" imageinfo >/dev/null 2>&1 | grep -q "No suggestion"
     then 
        echo "[!] $MEM_FILE is not a memory file"
    else 
        echo "[(:] $MEM_FILE can be analyzed using volatility"
        ./vol -f "$MEM_FILE" imageinfo > "$RESULTS_DIR/memory/imageinfo.txt" 2>&1
    fi
     #2.2 Find the memory profile and save it into a variable.
    export export PRO=$(./vol -f "$MEM_FILE" imageinfo 2>/dev/null | grep "Suggested" | awk '{print $4}' | tr -d " ,")
    
    #2.3 Display the running processes.
    #2.4 Display network connections.
    #2.5 Attempt to extract registry information.
    echo "[!] getting more information with volatility flags"
    PLUGINS="pslist pstree filescan connections connscan sockets hivelist"
    PRO=$(./vol -f "$MEM_FILE" imageinfo 2>/dev/null | grep "Suggested" | awk '{print $4}' | tr -d " , " )
    for i in $PLUGINS
    do
        echo "[*]----------parsing memmory using volatility $i-----------"
        ./vol -f "$MEM_FILE" --profile=$PRO $i > "$RESULTS_DIR/memory/file-$i.txt"2>/dev/null
    done
}

function CARVERS()
{
   
    
    
    #1.4 Use different carvers to automatically extract data
    echo "[!!]Running multiple carvers to gather as much information as possible."
    
    #Foremost
    echo "-----------Running Foremost---------"
    mkdir -p "$RESULTS_DIR/memory/foremost"
    foremost -v -T -i "$MEM_FILE" -o "$RESULTS_DIR/memory"> /dev/null 2>&1
    
    #strings 
    echo "-------------Running Strings---------"
    mkdir -p "$RESULTS_DIR/memory/strings"
    strings -n 8 "$MEM_FILE" > "$RESULTS_DIR/memory/strings/strings.txt" 2>/dev/null
    
    #Binwalk
    echo "-----------Running Binwalk---------"
    mkdir -p "$RESULTS_DIR/memory/binwalk"
    binwalk -eM --run-as=root "$MEM_FILE" --directory="$RESULTS_DIR/memory/binwalk"> /dev/null 2>&1
    
    #scalpel 
    echo "---------Configuring and Running Scalpel----------"
    mkdir -p "$RESULTS_DIR/memory/scalpel"
    CONF_FILE="/etc/scalpel/scalpel.conf"
   
    
    if [ -f "$CONF_FILE" ]
    then
    sudo sed -i 's/^[^#]/#&/' "$CONF_FILE"
    EXT="jpg png gif pdf doc zip rar"
    for i in $EXT
    do
    sudo sed -i "s/^#*\s*$i/$i/" "$CONF_FILE"
    done
        scalpel -v -c "$CONF_FILE" -o "$RESULTS_DIR/memory/scalpel" "$MEM_FILE"> /dev/null 2>&1
    else
        echo "[!] Scalpel config not found at $CONF_FILE"
    fi
    
    # Bulk Extractor
    echo "---------Running Bulk Extractor---------------"
    mkdir -p "$RESULTS_DIR/memory/bulk_extractor"
    bulk_extractor -o "$RESULTS_DIR/memory/bulk_extractor" "$MEM_FILE"> /dev/null 2>&1
    
    # Exiftool
    echo "---------------Running Exiftool-------------"
    mkdir -p "$RESULTS_DIR/memory/exiftool"
    exiftool "$MEM_FILE" > "$RESULTS_DIR/memory/exiftool/exif_metadata.txt"2>/dev/null
   
}

function PCAP ()
{
    #1.6 attempt to extract network traffic; if found, display to the user the location and size
    # Fixed spaces in $() syntax
    pcapF=$(find . -type f -name "packets.pcap") 
    if [ -n "$pcapF" ]
    then
        size=$(ls -lh "$pcapF" | awk '{print $(NF -4)}') 
        echo "PCAP found: $pcapF (Size: $size)"
		else
		echo "[!!] cannot find pcap file"
    fi
}

function STR()
{
    #1.7 Check for human-readable (exe files, passwords, usernames, etc.).
    STRINGS_LIST="exe password username http dll"
    for i in $STRINGS_LIST
    do
        strings "$MEM_FILE" | grep "$i" > "$RESULTS_DIR/file_$i.txt"
    done 
}

START
INSTALL
CARVERS 
VOL
STR
PCAP

#3.1 Display general statistics (time of analysis, number of found files, etc.).
# This must happen AFTER the functions run
END_TIME=$(date +%s)
TOTAL_TIME=$((END_TIME - START_TIME))
TOTAL_FILES=$(find "$RESULTS_DIR" -type f | wc -l)


echo "--- Analysis Statistics ---"
echo "Total Time: $TOTAL_TIME seconds"
echo "Total Files Found: $TOTAL_FILES"
echo "Report saved to: $REPORT_FILE"
{
    echo ""
    echo "--- Final Statistics ---"
    echo "Analysis Completed at: $(date)"
    echo "Total Time Taken: $TOTAL_TIME seconds"
    echo "Total Files Extracted: $TOTAL_FILES"
    echo "------------------------"
} >> "$REPORT_FILE"

#3.3 Zip the extracted files and the report file
ZIP_NAME="forensics_results_$(date +%F_%H-%M-%S).zip"
zip -r "$ZIP_NAME" "$RESULTS_DIR"> /dev/null 2>&1 && rm -rf "$RESULTS_DIR" 
if [ -f "$ZIP_NAME" ]
 then
    echo "[(:] Zip successful. Original folder removed."
else
    echo "[!] Error: Zip failed! I kept the folder '$RESULTS_DIR' so you don't lose data."
fi

