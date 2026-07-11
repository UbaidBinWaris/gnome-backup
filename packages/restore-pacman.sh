#!/bin/bash

# Pacman Packages Restoration Script
# Restores only native Arch Linux packages

set -e

PACKAGES_DIR="$(dirname "$0")"

echo "========================================"
echo "Pacman Packages Restoration"
echo "========================================"
echo ""

if [ ! -f "$PACKAGES_DIR/pacman-native.txt" ]; then
    echo "[ERROR] Package list not found: $PACKAGES_DIR/pacman-native.txt"
    exit 1
fi

if ! command -v pacman &> /dev/null; then
    echo "[ERROR] pacman command not found"
    echo "This script only works on Arch Linux and Arch-based distributions"
    exit 1
fi

TOTAL=$(wc -l < "$PACKAGES_DIR/pacman-native.txt")

echo "Found $TOTAL packages to install"
echo ""
echo "Package list: $PACKAGES_DIR/pacman-native.txt"
echo ""
read -p "Continue with installation? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 0
fi

echo ""
echo "Installing Pacman packages..."
echo "This will skip already installed packages (--needed flag)"
echo ""

sudo pacman -S --needed --noconfirm $(cat "$PACKAGES_DIR/pacman-native.txt") 2>&1 | \
    grep -v "warning: .* is up to date" | \
    grep -E "(installing|upgrading|error|warning)" || true

echo ""
echo "========================================"
echo "[OK] Pacman packages installation complete"
echo "========================================"
echo ""
