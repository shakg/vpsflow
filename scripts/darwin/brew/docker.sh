#!/bin/bash
# Name: Docker
# Category: DevOps
# Description: Docker is a platform for developing, shipping, and running applications in containers, enabling consistent environments.
# SupportedVersion: 20.10.14
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

# Install Docker
print_message "Installing Docker..."
if brew install --cask docker; then
    print_message "Docker installed successfully."
else
    handle_error "Failed to install Docker."
fi

# Start Docker
print_message "Starting Docker..."
open -a Docker || handle_error "Failed to start Docker."

# Check Docker version
print_message "Verifying Docker installation..."
if docker --version >/dev/null 2>&1; then
    print_message "Docker version: $(docker --version)"
else
    handle_error "Docker installation verification failed."
fi

print_message "Docker installation and setup completed successfully!"
