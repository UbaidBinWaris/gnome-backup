#!/bin/bash

# Go Package Restoration Script
# Restores only Go packages

PKG_DIR="$(dirname "$0")"

echo "========================================"
echo "Go Package Restoration"
echo "========================================"
echo ""

if [ ! -f "$PKG_DIR/go.txt" ]; then
    echo "[INFO] No Go package list found"
    echo "Expected location: $PKG_DIR/go.txt"
    exit 0
fi

PACKAGE_COUNT=$(wc -l < "$PKG_DIR/go.txt")

if [ "$PACKAGE_COUNT" -eq 0 ]; then
    echo "[INFO] No Go packages to restore"
    exit 0
fi

if ! command -v go &> /dev/null; then
    echo "[ERROR] Go is not installed"
    echo ""
    echo "Install Go first:"
    echo "  sudo pacman -S go"
    echo ""
    exit 1
fi

echo "Found $PACKAGE_COUNT Go package(s) to restore"
echo ""
read -p "Proceed with Go package installation? (y/N): " -r

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 0
fi

echo ""
echo "Installing Go packages..."
echo ""

INSTALLED=0
FAILED=0

while IFS= read -r PACKAGE; do
    [ -z "$PACKAGE" ] && continue
    
    CURRENT=$((INSTALLED + FAILED + 1))
    echo -n "[$CURRENT/$PACKAGE_COUNT] Installing $PACKAGE... "
    
    if go install "$PACKAGE@latest" &>/dev/null; then
        echo "[OK]"
        ((INSTALLED++))
    else
        echo "[FAILED]"
        ((FAILED++))
    fi
done < "$PKG_DIR/go.txt"

echo ""
echo "========================================"
echo "Go Installation Summary"
echo "========================================"
echo ""
echo "Total packages: $PACKAGE_COUNT"
echo "Successfully installed: $INSTALLED"
echo "Failed: $FAILED"
echo ""

if [ "$INSTALLED" -gt 0 ]; then
    echo "[OK] Go package restoration complete"
else
    echo "[ERROR] No packages were installed"
    exit 1
fi

echo ""
