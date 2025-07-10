#!/bin/bash

# Path to the authorized directories file
AUTOENV_AUTHORIZED_FILE=~/.autoenv_authorized

# Path to the not authorized directories file
AUTOENV_NOT_AUTHORIZED_FILE=~/.autoenv_not_authorized

# Function to add a directory to the authorized list
add_directory() {
    dir=$1
    if [[ -d $dir ]]; then
        echo "Adding $dir to the authorized list"
        echo $dir >> $AUTOENV_AUTHORIZED_FILE
    else
        echo "Error: $dir is not a valid directory"
    fi
}

# Function to remove a directory from the authorized list
remove_directory() {
    dir=$1
    if grep -q "$dir" $AUTOENV_AUTHORIZED_FILE; then
        echo "Removing $dir from the authorized list"
        sed -i "/$dir/d" $AUTOENV_AUTHORIZED_FILE
    else
        echo "Error: $dir is not in the authorized list"
    fi
}

# Function to list all authorized directories
list_directories() {
    echo "Authorized directories:"
    cat $AUTOENV_AUTHORIZED_FILE
    echo "Not authorized directories:"
    cat $AUTOENV_NOT_AUTHORIZED_FILE
}

# Main script logic
while true; do
    echo "Select an option:"
    echo "1. Add a directory"
    echo "2. Remove a directory"
    echo "3. List directories"
    echo "4. Exit"
    read -p "Option: " option
    case $option in
        1)
            read -p "Enter the directory to add: " dir
            add_directory $dir
            ;;
        2)
            read -p "Enter the directory to remove: " dir
            remove_directory $dir
            ;;
        3)
            list_directories
            ;;
        4)
            exit
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
