#!/bin/bash

# Function to print messages
function print_message {
    echo -e "\n\033[1;34m$1\033[0m"  # Blue text
}

# Function to handle errors
function handle_error {
    echo -e "\n\033[1;31mERROR: $1\033[0m"  # Red text
    exit 1
}

# Update package list
print_message "Updating package list..."
if sudo apt update; then
    print_message "Package list updated successfully."
else
    handle_error "Failed to update package list."
fi

# Install Node.js and npm
print_message "Installing Node.js and npm..."
if sudo apt install -y nodejs npm; then
    print_message "Node.js and npm installed successfully."
else
    handle_error "Failed to install Node.js and npm."
fi

# Check Node.js version
print_message "Checking Node.js version..."
if node -v; then
    print_message "Node.js is installed successfully."
else
    handle_error "Node.js installation verification failed."
fi

# Check npm version
print_message "Checking npm version..."
if npm -v; then
    print_message "npm is installed successfully."
else
    handle_error "npm installation verification failed."
fi

print_message "Node.js and npm installation completed successfully!"