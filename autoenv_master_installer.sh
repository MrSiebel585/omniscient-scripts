#!/bin/bash

# URL of the script to download
SCRIPT_URL='https://raw.githubusercontent.com/hyperupcall/autoenv/master/scripts/install.sh'

# Check if curl is available on the system
if command -v curl &>/dev/null; then
    echo "Using curl to download and execute the script..."
    curl -#fLo- "$SCRIPT_URL" | sh
# Check if wget is available on the system
elif command -v wget &>/dev/null; then
    echo "Using wget to download and execute the script..."
    wget --show-progress -o /dev/null -O- "$SCRIPT_URL" | sh
else
    echo "Error: Neither curl nor wget is available on your system."
    exit 1
fi

# Optionally, add any post-execution commands or cleanup here

# Clone additional Git repositories
git clone https://github.com/JeremyEngram/pipvenvmanager
git clone https://github.com/JeremyEngram/managevenv
git clone https://github.com/JeremyEngram/autoenv.git

