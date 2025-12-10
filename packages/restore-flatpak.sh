#!/bin/bash

# Flatpak Applications Restoration Script
# Restores Flatpak applications

set -e

PACKAGES_DIR="$(dirname "$0")"

echo "========================================"
echo "Flatpak Applications Restoration"
echo "========================================"
echo ""

if ! command -v flatpak &> /dev/null; then
    echo "[ERROR] Flatpak is not installed"
    echo ""
    echo "Install Flatpak first:"
    echo "  sudo pacman -S flatpak"
    echo ""
    exit 1
fi

if [ ! -f "$PACKAGES_DIR/flatpak.txt" ]; then
    echo "[ERROR] Package list not found: $PACKAGES_DIR/flatpak.txt"
    exit 1
fi

if [ ! -s "$PACKAGES_DIR/flatpak.txt" ]; then
    echo "[INFO] No Flatpak applications to install"
    exit 0
fi

TOTAL=$(wc -l < "$PACKAGES_DIR/flatpak.txt")

echo "Found $TOTAL Flatpak applications to install"
echo ""
echo "Package list: $PACKAGES_DIR/flatpak.txt"
echo ""
read -p "Continue with installation? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 0
fi

echo ""
echo "Installing Flatpak applications..."
echo ""

CURRENT=0
while IFS= read -r app; do
    [ -z "$app" ] && continue
    CURRENT=$((CURRENT + 1))
    echo "[$CURRENT/$TOTAL] Installing: $app"
    flatpak install -y --noninteractive flathub "$app" 2>&1 | grep -E "(Installing|Already installed|error)" || true
done < "$PACKAGES_DIR/flatpak.txt"

echo ""
echo "========================================"
echo "[OK] Flatpak installation complete"
echo "========================================"
echo ""
