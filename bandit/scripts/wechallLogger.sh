#!/bin/bash

HOST="bandit.labs.overthewire.org"
PORT=2220

if [ -z "$WECHALLUSER" ] || [ -z "$WECHALLTOKEN" ]; then
    echo "Error: WeChall credentials not found."
    echo "Please export them before running the script:"
    echo "export WECHALLUSER='your_username'"
    echo "export WECHALLTOKEN='your_token'"
    exit 1
fi

if ! command -v sshpass &> /dev/null; then
    echo "Error: 'sshpass' is required but not installed."
    exit 1
fi

echo "Starting automated WeChall registration for Bandit..."
echo "==================================================="

for i in {1..33}; do
    USER="bandit${i}"
    PASSFILE="./passwords/${USER}.txt"

    if [ -f "$PASSFILE" ]; then
        echo "[*] Attempting to register ${USER}..."
        
        PASSWORD=$(cat "$PASSFILE" | tr -d '[:space:]')
        
        sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no -o LogLevel=ERROR -p "$PORT" "${USER}@${HOST}" \
            "export WECHALLUSER='$WECHALLUSER'; export WECHALLTOKEN='$WECHALLTOKEN'; wechall"
            
        echo "[+] Finished ${USER}"
        echo "---------------------------------------------------"
    else
        echo "[-] ${PASSFILE} not found. Skipping ${USER}."
    fi
done

echo "Done!"
