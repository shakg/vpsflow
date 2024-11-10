#!/bin/bash
# Name: PostgreSQL
# Category: Database
# Description: PostgreSQL is an advanced, open-source relational database management system.
# SupportedVersion: 15.0
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

# Install PostgreSQL
print_message "Installing PostgreSQL..."
if brew install postgresql; then
    print_message "PostgreSQL installed successfully."
else
    handle_error "Failed to install PostgreSQL."
fi

# Start PostgreSQL service
print_message "Starting PostgreSQL service..."
if brew services start postgresql; then
    print_message "PostgreSQL service started successfully."
else
    handle_error "Failed to start PostgreSQL service."
fi

# Initialize PostgreSQL database (if not already initialized)
print_message "Initializing PostgreSQL database..."
if ! pg_ctl -D /usr/local/var/postgres status >/dev/null 2>&1; then
    if initdb /usr/local/var/postgres; then
        print_message "PostgreSQL database initialized successfully."
    else
        handle_error "Failed to initialize PostgreSQL database."
    fi
else
    print_message "PostgreSQL database is already initialized."
fi

# Verify PostgreSQL installation
print_message "Verifying PostgreSQL installation..."
if psql --version >/dev/null 2>&1; then
    print_message "PostgreSQL version: $(psql --version)"
else
    handle_error "PostgreSQL installation verification failed."
fi

print_message "PostgreSQL installation and setup completed successfully!"
