#!/bin/bash
# Name: Node.js
# Category: Runtime
# Description: JavaScript runtime built on Chrome V8 engine, suitable for data-intensive real-time applications.
# SupportedVersion: 16.0.0
# LastUpdate: 11-10-2024

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

# Install Node.js and npm
print_message "Installing Node.js and npm..."
if brew install node; then
    print_message "Node.js and npm installed successfully."
else
    handle_error "Failed to install Node.js and npm."
fi

# Check Node.js version
print_message "Checking Node.js version..."
if node -v >/dev/null 2>&1; then
    print_message "Node.js version: $(node -v)"
else
    handle_error "Node.js installation verification failed."
fi

# Check npm version
print_message "Checking npm version..."
if npm -v >/dev/null 2>&1; then
    print_message "npm version: $(npm -v)"
else
    handle_error "npm installation verification failed."
fi

print_message "Node.js and npm installation completed successfully!"