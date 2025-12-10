#!/bin/bash

# Auto-generated script to reinstall all backed up packages
# Run this script to restore all applications and tools

set -e

PACKAGES_DIR="$(dirname "$0")"

echo "[INSTALL] Installing all backed up applications and tools..."
echo "This may take a while. Please be patient."
echo ""

# Install pacman packages
if [ -f "$PACKAGES_DIR/pacman-native.txt" ] && command -v pacman &> /dev/null; then
    echo "[BACKUP] Installing pacman packages..."
    sudo pacman -S --needed --noconfirm $(cat "$PACKAGES_DIR/pacman-native.txt") || true
fi

# Install AUR packages (requires yay or paru)
if [ -f "$PACKAGES_DIR/aur-packages.txt" ] && [ -s "$PACKAGES_DIR/aur-packages.txt" ]; then
    if command -v yay &> /dev/null; then
        echo "[BACKUP] Installing AUR packages with yay..."
        yay -S --needed --noconfirm $(cat "$PACKAGES_DIR/aur-packages.txt") || true
    elif command -v paru &> /dev/null; then
        echo "[BACKUP] Installing AUR packages with paru..."
        paru -S --needed --noconfirm $(cat "$PACKAGES_DIR/aur-packages.txt") || true
    else
        echo "[WARNING]  No AUR helper found. Please install yay or paru to install AUR packages."
    fi
fi

# Install Flatpak packages
if [ -f "$PACKAGES_DIR/flatpak.txt" ] && [ -s "$PACKAGES_DIR/flatpak.txt" ] && command -v flatpak &> /dev/null; then
    echo "[BACKUP] Installing Flatpak applications..."
    while IFS= read -r app; do
        [ -z "$app" ] && continue
        flatpak install -y flathub "$app" 2>/dev/null || true
    done < "$PACKAGES_DIR/flatpak.txt"
fi

# Install Snap packages
if [ -f "$PACKAGES_DIR/snap.txt" ] && [ -s "$PACKAGES_DIR/snap.txt" ] && command -v snap &> /dev/null; then
    echo "[BACKUP] Installing Snap packages..."
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        sudo snap install "$pkg" 2>/dev/null || true
    done < "$PACKAGES_DIR/snap.txt"
fi

# Install pip packages
if [ -f "$PACKAGES_DIR/pip3.txt" ] && [ -s "$PACKAGES_DIR/pip3.txt" ] && command -v pip3 &> /dev/null; then
    echo "[PYTHON] Installing pip3 packages..."
    pip3 install --user -r "$PACKAGES_DIR/pip3.txt" || true
fi

# Install npm global packages
if [ -f "$PACKAGES_DIR/npm-global.txt" ] && [ -s "$PACKAGES_DIR/npm-global.txt" ] && command -v npm &> /dev/null; then
    echo "[BACKUP] Installing npm global packages..."
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        npm install -g "$pkg" 2>/dev/null || true
    done < "$PACKAGES_DIR/npm-global.txt"
fi

# Install cargo packages
if [ -f "$PACKAGES_DIR/cargo.txt" ] && [ -s "$PACKAGES_DIR/cargo.txt" ] && command -v cargo &> /dev/null; then
    echo "[RUST] Installing cargo packages..."
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        cargo install "$pkg" 2>/dev/null || true
    done < "$PACKAGES_DIR/cargo.txt"
fi

# Install Ruby gems
if [ -f "$PACKAGES_DIR/ruby-gems.txt" ] && [ -s "$PACKAGES_DIR/ruby-gems.txt" ] && command -v gem &> /dev/null; then
    echo "[RUBY] Installing Ruby gems..."
    while IFS= read -r gem; do
        [ -z "$gem" ] && continue
        gem install "$gem" 2>/dev/null || true
    done < "$PACKAGES_DIR/ruby-gems.txt"
fi

echo ""
echo "[OK] Package installation complete!"
echo "Note: Go binaries must be reinstalled manually from their sources."
