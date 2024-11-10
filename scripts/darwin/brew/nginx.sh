#!/bin/bash
# Name: Nginx
# Category: Web Server
# Description: Nginx is a high-performance web server, reverse proxy, and load balancer known for its stability and scalability.
# SupportedVersion: 1.21.6
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

# Install Nginx
print_message "Installing Nginx..."
if brew install nginx; then
    print_message "Nginx installed successfully."
else
    handle_error "Failed to install Nginx."
fi

# Start Nginx service
print_message "Starting Nginx service..."
if brew services start nginx; then
    print_message "Nginx service started successfully."
else
    handle_error "Failed to start Nginx service."
fi

# Verify Nginx installation
print_message "Verifying Nginx installation..."
if nginx -v >/dev/null 2>&1; then
    print_message "Nginx version: $(nginx -v)"
else
    handle_error "Nginx installation verification failed."
fi

# Print out the default Nginx page URL
print_message "You can access the default Nginx page at http://localhost:8080"

print_message "Nginx installation and setup completed successfully!"
