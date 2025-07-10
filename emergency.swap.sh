#!/bin/bash

# Prompt user for swap file size
read -p "Enter the size of swap file (e.g., 1G, 2G): " swap_size

# Create swap file
if sudo fallocate -l "$swap_size" /swapfile 2>/dev/null; then
    echo "Swap file created successfully."
else
    sudo dd if=/dev/zero of=/swapfile bs=1024 count=$(echo "$swap_size" | tr -cd [:digit:])"M"
    if [ $? -eq 0 ]; then
        echo "Swap file created successfully."
    else
        echo "Failed to create swap file."
        exit 1
    fi
fi

# Set permissions
sudo chmod 600 /swapfile

# Set up swap area
sudo mkswap /swapfile

# Enable swap
sudo swapon /swapfile

# Add entry to /etc/fstab
echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab

echo "Swap file setup completed."

