#!/bin/bash

# Clever Rails Template Installer
# This script installs the clever-rails command globally

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info "Installing Clever Rails Template..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLEVER_RAILS_SCRIPT="$SCRIPT_DIR/clever-rails"

# Check if the clever-rails script exists
if [ ! -f "$CLEVER_RAILS_SCRIPT" ]; then
    print_error "clever-rails script not found in $SCRIPT_DIR"
    exit 1
fi

# Try user-local directory first, fallback to system-wide
if [ -d "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin" 2>/dev/null; then
    INSTALL_DIR="$HOME/.local/bin"
    print_info "Installing to user directory: $INSTALL_DIR"
elif [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
    print_info "Installing to system directory: $INSTALL_DIR"
else
    print_error "Cannot install to /usr/local/bin (requires sudo)"
    print_info "Trying to install to user directory instead..."
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
    print_warning "Make sure $INSTALL_DIR is in your PATH"
    print_info "Add this to your shell config (~/.bashrc, ~/.zshrc, etc.):"
    print_info "export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

INSTALL_PATH="$INSTALL_DIR/clever-rails"

# Check if clever-rails is already installed
if [ -L "$INSTALL_PATH" ]; then
    EXISTING_TARGET="$(readlink "$INSTALL_PATH")"
    if [ "$EXISTING_TARGET" = "$CLEVER_RAILS_SCRIPT" ]; then
        print_success "clever-rails is already installed and up to date"
        exit 0
    else
        print_warning "clever-rails is already installed but points to a different location"
        print_info "Current: $EXISTING_TARGET"
        print_info "New: $CLEVER_RAILS_SCRIPT"
        read -p "Do you want to update it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
        rm "$INSTALL_PATH"
    fi
elif [ -f "$INSTALL_PATH" ]; then
    print_error "A file already exists at $INSTALL_PATH (not a symlink)"
    print_info "Please remove it manually and try again"
    exit 1
fi

# Create the symlink
print_info "Creating symlink: $INSTALL_PATH -> $CLEVER_RAILS_SCRIPT"
ln -s "$CLEVER_RAILS_SCRIPT" "$INSTALL_PATH"

# Make sure the script is executable
chmod +x "$CLEVER_RAILS_SCRIPT"

print_success "clever-rails installed successfully!"
print_info "You can now use 'clever-rails' from anywhere"
print_info ""
print_info "Usage examples:"
print_info "  cd ~/Projects"
print_info "  clever-rails new myapp api"
print_info "  clever-rails new myapp fullstack"
print_info ""
print_info "For help: clever-rails --help"