#!/usr/bin/env bash

# This relies on the macOS text to speech `say` tool, so exit if not on Mac
if [[ "$(uname)" != "Darwin" ]]; then
    echo "This script can only be run on macOS."
    exit 1
fi

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# Install `ncat` using Homebrew; the version we need is in the `nmap` package
HOMEBREW_NO_AUTO_UPDATE=1 brew install --quiet --force nmap

# Download and extract the `netsay` repository to the user's home directory
NETSAY_URL="https://github.com/sklampo/netsay/archive/refs/heads/main.zip"
TARGET_DIR="$HOME/netsay"

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Downloading and extracting the netsay repository..."
    TEMP_ZIP=$(mktemp /tmp/netsay.XXXXXX.zip)
    curl -L "$NETSAY_URL" -o "$TEMP_ZIP"
    unzip -q "$TEMP_ZIP" -d "$HOME"
    mv -v "$HOME/netsay-main" "$TARGET_DIR"
    rm -vf "$TEMP_ZIP"
else
    echo "The netsay repository is already downloaded."
fi

# Ensure the $HOME/bin directory exists
mkdir -pv "$HOME/bin"

# Copy the netsay script to $HOME/bin
cp -v "$TARGET_DIR/netsay-main/netsay" "$HOME/bin/"

# Make the script executable
chmod +x "$HOME/bin/netsay"

# Start up netsay in server mode
"$HOME/bin/netsay" -s
