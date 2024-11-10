#!/bin/bash
# Name: MySQL
# Category: Database
# Description: MySQL is an open-source relational database management system known for its reliability and ease of use.
# SupportedVersion: 8.0
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

# Install MySQL
print_message "Installing MySQL..."
if brew install mysql; then
    print_message "MySQL installed successfully."
else
    handle_error "Failed to install MySQL."
fi

# Start MySQL service
print_message "Starting MySQL service..."
if brew services start mysql; then
    print_message "MySQL service started successfully."
else
    handle_error "Failed to start MySQL service."
fi

# Secure MySQL installation
print_message "Securing MySQL installation..."
if mysql_secure_installation; then
    print_message "MySQL secured successfully."
else
    handle_error "Failed to secure MySQL installation."
fi

# Verify MySQL installation
print_message "Verifying MySQL installation..."
if mysql --version >/dev/null 2>&1; then
    print_message "MySQL version: $(mysql --version)"
else
    handle_error "MySQL installation verification failed."
fi

print_message "MySQL installation and setup completed successfully!"
