#!/bin/bash

# Snap Package Restoration Script
# Restores only Snap packages

PKG_DIR="$(dirname "$0")"

echo "========================================"
echo "Snap Package Restoration"
echo "========================================"
echo ""

if [ ! -f "$PKG_DIR/snap.txt" ]; then
    echo "[INFO] No Snap package list found"
    echo "Expected location: $PKG_DIR/snap.txt"
    exit 0
fi

PACKAGE_COUNT=$(wc -l < "$PKG_DIR/snap.txt")

if [ "$PACKAGE_COUNT" -eq 0 ]; then
    echo "[INFO] No Snap packages to restore"
    exit 0
fi

if ! command -v snap &> /dev/null; then
    echo "[ERROR] Snap is not installed"
    echo ""
    echo "Install Snap first:"
    echo "  sudo pacman -S snapd"
    echo "  sudo systemctl enable --now snapd.socket"
    echo "  sudo ln -s /var/lib/snapd/snap /snap"
    echo ""
    exit 1
fi

echo "Found $PACKAGE_COUNT Snap package(s) to restore"
echo ""
read -p "Proceed with Snap package installation? (y/N): " -r

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 0
fi

echo ""
echo "Installing Snap packages..."
echo ""

INSTALLED=0
FAILED=0

while IFS= read -r PACKAGE; do
    [ -z "$PACKAGE" ] && continue
    
    CURRENT=$((INSTALLED + FAILED + 1))
    echo -n "[$CURRENT/$PACKAGE_COUNT] Installing $PACKAGE... "
    
    if sudo snap install "$PACKAGE" 2>&1 | grep -qE '(installed|already installed)'; then
        echo "[OK]"
        ((INSTALLED++))
    else
        echo "[FAILED]"
        ((FAILED++))
    fi
done < "$PKG_DIR/snap.txt"

echo ""
echo "========================================"
echo "Snap Installation Summary"
echo "========================================"
echo ""
echo "Total packages: $PACKAGE_COUNT"
echo "Successfully installed: $INSTALLED"
echo "Failed: $FAILED"
echo ""

if [ "$INSTALLED" -gt 0 ]; then
    echo "[OK] Snap package restoration complete"
else
    echo "[ERROR] No packages were installed"
    exit 1
fi

echo ""
