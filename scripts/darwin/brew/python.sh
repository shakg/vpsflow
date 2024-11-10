#!/bin/bash
# Name: Python
# Category: Language
# Description: Python is a high-level, interpreted programming language known for its readability and versatility.
# SupportedVersion: 3.11
# LastUpdate: 11-11-2024

# Function to print messages
function print_message {
    echo -e "\n\033[1;34m$1\033[0m"  # Blue text
}

# Function to handle errors
function handle_error {
    echo -e "\n\033[1;31mERROR: $1\033[0m"  # Red text
    exit 1
}

# Check if Homebrew is installed
print_message "Checking if Homebrew is installed..."
if command -v brew >/dev/null 2>&1; then
    print_message "Homebrew is already installed."
else
    print_message "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || handle_error "Failed to install Homebrew."
fi

# Update Homebrew
print_message "Updating Homebrew..."
if brew update; then
    print_message "Homebrew updated successfully."
else
    handle_error "Failed to update Homebrew."
fi

# Install Python
print_message "Installing Python..."
if brew install python; then
    print_message "Python installed successfully."
else
    handle_error "Failed to install Python."
fi

# Verify Python installation
print_message "Verifying Python installation..."
if python3 --version >/dev/null 2>&1; then
    print_message "Python version: $(python3 --version)"
else
    handle_error "Python installation verification failed."
fi

# Set up pip (Python package installer)
print_message "Ensuring pip is installed..."
if python3 -m ensurepip --upgrade >/dev/null 2>&1; then
    print_message "Pip is set up successfully."
else
    handle_error "Failed to set up pip."
fi

# Check pip version
print_message "Checking pip version..."
if pip3 --version >/dev/null 2>&1; then
    print_message "Pip version: $(pip3 --version)"
else
    handle_error "Pip installation verification failed."
fi

print_message "Python and pip installation completed successfully!"
