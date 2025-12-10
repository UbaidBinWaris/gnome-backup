#!/bin/bash

# Yay AUR Helper Installation Script
# Installs yay from source if not already installed

echo "========================================"
echo "Yay AUR Helper Installation"
echo "========================================"
echo ""

if command -v yay &> /dev/null; then
    YAY_VERSION=$(yay --version | head -n1)
    echo "[INFO] Yay is already installed"
    echo "Version: $YAY_VERSION"
    echo ""
    exit 0
fi

if command -v paru &> /dev/null; then
    echo "[INFO] Paru is already installed as AUR helper"
    echo ""
    read -p "Do you still want to install yay? (y/N): " -r
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled"
        exit 0
    fi
fi

echo "Checking dependencies..."

# Check for required packages
MISSING_DEPS=()

if ! command -v git &> /dev/null; then
    MISSING_DEPS+=("git")
fi

if ! command -v makepkg &> /dev/null; then
    MISSING_DEPS+=("base-devel")
fi

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo ""
    echo "Installing required dependencies: ${MISSING_DEPS[*]}"
    sudo pacman -S --needed --noconfirm "${MISSING_DEPS[@]}" || {
        echo "[ERROR] Failed to install dependencies"
        exit 1
    }
fi

echo ""
echo "This will:"
echo "  1. Clone yay repository from AUR"
echo "  2. Build yay from source"
echo "  3. Install yay on your system"
echo ""
read -p "Proceed with yay installation? (y/N): " -r

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 0
fi

echo ""
echo "Creating temporary build directory..."
BUILD_DIR=$(mktemp -d)
cd "$BUILD_DIR" || {
    echo "[ERROR] Failed to create build directory"
    exit 1
}

echo "Cloning yay repository..."
if ! git clone https://aur.archlinux.org/yay.git; then
    echo "[ERROR] Failed to clone yay repository"
    rm -rf "$BUILD_DIR"
    exit 1
fi

cd yay || {
    echo "[ERROR] Failed to enter yay directory"
    rm -rf "$BUILD_DIR"
    exit 1
}

echo ""
echo "Building yay..."
if ! makepkg -si --noconfirm; then
    echo "[ERROR] Failed to build yay"
    cd ~
    rm -rf "$BUILD_DIR"
    exit 1
fi

echo ""
echo "Cleaning up..."
cd ~
rm -rf "$BUILD_DIR"

echo ""
echo "========================================"
echo "[OK] Yay Installation Complete"
echo "========================================"
echo ""

if command -v yay &> /dev/null; then
    YAY_VERSION=$(yay --version | head -n1)
    echo "Installed: $YAY_VERSION"
    echo ""
    echo "You can now use yay to install AUR packages:"
    echo "  yay -S <package-name>"
    echo ""
    echo "Update all packages (including AUR):"
    echo "  yay -Syu"
    echo ""
else
    echo "[ERROR] Yay installation verification failed"
    exit 1
fi
