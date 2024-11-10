#!/bin/bash
# Name: Go (Golang)
# Category: Language
# Description: Open source programming language that makes it easy to build simple, reliable, and efficient software.
# SupportedVersion: 1.20
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

# Install Go
print_message "Installing Go (Golang)..."
if brew install go; then
    print_message "Go installed successfully."
else
    handle_error "Failed to install Go."
fi

# Check Go version
print_message "Checking Go version..."
if go version >/dev/null 2>&1; then
    print_message "Go version: $(go version)"
else
    handle_error "Go installation verification failed."
fi

# Setting up Go workspace environment
print_message "Setting up Go workspace environment..."
GO_PATH="$HOME/go"
mkdir -p "$GO_PATH" || handle_error "Failed to create Go workspace directory."
export GOPATH="$GO_PATH"
export PATH="$PATH:$GOPATH/bin"

print_message "Go installation and setup completed successfully!"
print_message "GOPATH is set to $GOPATH. Add it to your shell profile if necessary."
