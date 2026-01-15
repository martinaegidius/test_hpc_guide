#!/bin/bash 
#shell script for adding an interactive node to user's launch.json to enable debugging on interactive HPC nodes. 
#Usage: start a session on the specific interactive node and run the script. Enter the name of the machine. 
#Note: the script strips comments, and assumes valid json files (no trailing "," before {}-blocks)
#authors: Ludvik Petersen and Martin Ægidius, Technical University of Denmark 

read -p "Enter interactive node name: " MACHINENAME
echo "Fetching ip adress eth0..."
IPAddr=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
echo "Appending to existing launch.json"

# Strip comments
grep -v '^\s*//' .vscode/launch.json > .vscode/launch_clean.json

jq --arg ip "$IPAddr" --arg name "$MACHINENAME" '.configurations += [{
    "name": ("Attach to " + $name + " debugger using shell script"),
    "type": "debugpy",
    "request": "attach",
    "connect": {
        "host": $ip,
        "port": 5678
    },
    "pathMappings": [{
        "localRoot": "${workspaceFolder}",
        "remoteRoot": "."
    }],
    "justMyCode": false
}]' .vscode/launch_clean.json > .vscode/tmp.json

echo "cleaning up..."
mv .vscode/launch.json .vscode/launch.json.old 
mv .vscode/tmp.json .vscode/launch.json
rm -f .vscode/launch_clean.json  
echo ".vscode/launch.json updated for $MACHINENAME. Old config saved to .vscode/launch.json.old"