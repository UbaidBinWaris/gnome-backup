#!/bin/bash

# AUR Packages Restoration Script
# Restores AUR packages using yay or paru

set -e

PACKAGES_DIR="$(dirname "$0")"

echo "========================================"
echo "AUR Packages Restoration"
echo "========================================"
echo ""

if [ ! -f "$PACKAGES_DIR/aur-packages.txt" ]; then
    echo "[ERROR] Package list not found: $PACKAGES_DIR/aur-packages.txt"
    exit 1
fi

if [ ! -s "$PACKAGES_DIR/aur-packages.txt" ]; then
    echo "[INFO] No AUR packages to install"
    exit 0
fi

# Check for AUR helper
if command -v yay &> /dev/null; then
    AUR_HELPER="yay"
elif command -v paru &> /dev/null; then
    AUR_HELPER="paru"
else
    echo "[ERROR] No AUR helper found"
    echo ""
    echo "Please install yay or paru first:"
    echo ""
    echo "To install yay:"
    echo "  sudo pacman -S --needed base-devel git"
    echo "  git clone https://aur.archlinux.org/yay.git"
    echo "  cd yay"
    echo "  makepkg -si"
    echo ""
    exit 1
fi

TOTAL=$(wc -l < "$PACKAGES_DIR/aur-packages.txt")

echo "Found $TOTAL AUR packages to install"
echo "Using AUR helper: $AUR_HELPER"
echo ""
echo "Package list: $PACKAGES_DIR/aur-packages.txt"
echo ""
read -p "Continue with installation? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 0
fi

echo ""
echo "Installing AUR packages with $AUR_HELPER..."
echo "This will skip already installed packages (--needed flag)"
echo ""

$AUR_HELPER -S --needed --noconfirm $(cat "$PACKAGES_DIR/aur-packages.txt") 2>&1 | \
    grep -v "warning: .* is up to date" | \
    grep -E "(installing|upgrading|error|warning)" || true

echo ""
echo "========================================"
echo "[OK] AUR packages installation complete"
echo "========================================"
echo ""
