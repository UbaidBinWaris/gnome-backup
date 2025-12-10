#!/bin/bash

# NPM Global Package Restoration Script
# Restores only NPM global packages

PKG_DIR="$(dirname "$0")"

echo "========================================"
echo "NPM Global Package Restoration"
echo "========================================"
echo ""

if [ ! -f "$PKG_DIR/npm.txt" ]; then
    echo "[INFO] No NPM package list found"
    echo "Expected location: $PKG_DIR/npm.txt"
    exit 0
fi

PACKAGE_COUNT=$(wc -l < "$PKG_DIR/npm.txt")

if [ "$PACKAGE_COUNT" -eq 0 ]; then
    echo "[INFO] No NPM packages to restore"
    exit 0
fi

if ! command -v npm &> /dev/null; then
    echo "[ERROR] NPM is not installed"
    echo ""
    echo "Install Node.js and NPM first:"
    echo "  sudo pacman -S nodejs npm"
    echo ""
    exit 1
fi

echo "Found $PACKAGE_COUNT NPM global package(s) to restore"
echo ""
read -p "Proceed with NPM package installation? (y/N): " -r

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 0
fi

echo ""
echo "Installing NPM packages globally..."
echo ""

INSTALLED=0
FAILED=0

while IFS= read -r PACKAGE; do
    [ -z "$PACKAGE" ] && continue
    
    CURRENT=$((INSTALLED + FAILED + 1))
    echo -n "[$CURRENT/$PACKAGE_COUNT] Installing $PACKAGE... "
    
    if npm install -g "$PACKAGE" &>/dev/null; then
        echo "[OK]"
        ((INSTALLED++))
    else
        echo "[FAILED]"
        ((FAILED++))
    fi
done < "$PKG_DIR/npm.txt"

echo ""
echo "========================================"
echo "NPM Installation Summary"
echo "========================================"
echo ""
echo "Total packages: $PACKAGE_COUNT"
echo "Successfully installed: $INSTALLED"
echo "Failed: $FAILED"
echo ""

if [ "$INSTALLED" -gt 0 ]; then
    echo "[OK] NPM package restoration complete"
else
    echo "[ERROR] No packages were installed"
    exit 1
fi

echo ""
