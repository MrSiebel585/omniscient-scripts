#!/bin/bash

gorilla-cli open-intrepreter sgpt ollama  llm

# try pipx install first 

# Function to create and set up a virtual environment
setup_virtualenv() {
    # Create a virtual environment
    python -m venv gorilla-cli

    # Activate the virtual environment
    source gorilla-cli/bin/activate

    # Install dependencies using pip
    pip install -r requirements.txt

    # Deactivate the virtual environment
    deactivate
}

# Example usage in a for loop
for i in {1..5}; do
    echo "Setting up environment $i"
    setup_virtualenv
done

export PATH=$PATH:/home/jeremy/.local/bin
