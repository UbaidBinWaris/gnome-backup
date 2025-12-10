#!/bin/bash

# Cargo Package Restoration Script
# Restores only Rust Cargo packages

PKG_DIR="$(dirname "$0")"

echo "========================================"
echo "Cargo Package Restoration"
echo "========================================"
echo ""

if [ ! -f "$PKG_DIR/cargo.txt" ]; then
    echo "[INFO] No Cargo package list found"
    echo "Expected location: $PKG_DIR/cargo.txt"
    exit 0
fi

PACKAGE_COUNT=$(wc -l < "$PKG_DIR/cargo.txt")

if [ "$PACKAGE_COUNT" -eq 0 ]; then
    echo "[INFO] No Cargo packages to restore"
    exit 0
fi

if ! command -v cargo &> /dev/null; then
    echo "[ERROR] Cargo is not installed"
    echo ""
    echo "Install Rust and Cargo first:"
    echo "  sudo pacman -S rust"
    echo "  or"
    echo "  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
    echo ""
    exit 1
fi

echo "Found $PACKAGE_COUNT Cargo package(s) to restore"
echo ""
read -p "Proceed with Cargo package installation? (y/N): " -r

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 0
fi

echo ""
echo "Installing Cargo packages..."
echo ""

INSTALLED=0
FAILED=0

while IFS= read -r PACKAGE; do
    [ -z "$PACKAGE" ] && continue
    
    CURRENT=$((INSTALLED + FAILED + 1))
    echo -n "[$CURRENT/$PACKAGE_COUNT] Installing $PACKAGE... "
    
    if cargo install "$PACKAGE" &>/dev/null; then
        echo "[OK]"
        ((INSTALLED++))
    else
        echo "[FAILED]"
        ((FAILED++))
    fi
done < "$PKG_DIR/cargo.txt"

echo ""
echo "========================================"
echo "Cargo Installation Summary"
echo "========================================"
echo ""
echo "Total packages: $PACKAGE_COUNT"
echo "Successfully installed: $INSTALLED"
echo "Failed: $FAILED"
echo ""

if [ "$INSTALLED" -gt 0 ]; then
    echo "[OK] Cargo package restoration complete"
else
    echo "[ERROR] No packages were installed"
    exit 1
fi

echo ""
