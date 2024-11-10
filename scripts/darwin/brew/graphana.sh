#!/bin/bash
# Name: Grafana
# Category: Monitoring
# Description: Grafana is an open-source platform for monitoring and observability. It allows you to query, visualize, and alert on metrics from various data sources.
# SupportedVersion: 9.0.0
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

# Install Grafana
print_message "Installing Grafana..."
if brew install grafana; then
    print_message "Grafana installed successfully."
else
    handle_error "Failed to install Grafana."
fi

# Start Grafana service
print_message "Starting Grafana service..."
if brew services start grafana; then
    print_message "Grafana service started successfully."
else
    handle_error "Failed to start Grafana service."
fi

# Verify Grafana installation
print_message "Verifying Grafana installation..."
if grafana-cli -v >/dev/null 2>&1; then
    print_message "Grafana version: $(grafana-cli -v)"
else
    handle_error "Grafana installation verification failed."
fi

# Print out the default Grafana URL
print_message "You can access the Grafana web interface at http://localhost:3000"
print_message "The default login is: Username: admin, Password: admin"

print_message "Grafana installation and setup completed successfully!"
