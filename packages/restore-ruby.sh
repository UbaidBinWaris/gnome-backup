#!/bin/bash

# Ruby Gem Restoration Script
# Restores only Ruby gems

PKG_DIR="$(dirname "$0")"

echo "========================================"
echo "Ruby Gem Restoration"
echo "========================================"
echo ""

if [ ! -f "$PKG_DIR/ruby.txt" ]; then
    echo "[INFO] No Ruby gem list found"
    echo "Expected location: $PKG_DIR/ruby.txt"
    exit 0
fi

PACKAGE_COUNT=$(wc -l < "$PKG_DIR/ruby.txt")

if [ "$PACKAGE_COUNT" -eq 0 ]; then
    echo "[INFO] No Ruby gems to restore"
    exit 0
fi

if ! command -v gem &> /dev/null; then
    echo "[ERROR] Ruby gem is not installed"
    echo ""
    echo "Install Ruby first:"
    echo "  sudo pacman -S ruby"
    echo ""
    exit 1
fi

echo "Found $PACKAGE_COUNT Ruby gem(s) to restore"
echo ""
read -p "Proceed with Ruby gem installation? (y/N): " -r

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Installation cancelled"
    exit 0
fi

echo ""
echo "Installing Ruby gems..."
echo ""

INSTALLED=0
FAILED=0

while IFS= read -r PACKAGE; do
    [ -z "$PACKAGE" ] && continue
    
    CURRENT=$((INSTALLED + FAILED + 1))
    echo -n "[$CURRENT/$PACKAGE_COUNT] Installing $PACKAGE... "
    
    if gem install "$PACKAGE" --user-install &>/dev/null; then
        echo "[OK]"
        ((INSTALLED++))
    else
        echo "[FAILED]"
        ((FAILED++))
    fi
done < "$PKG_DIR/ruby.txt"

echo ""
echo "========================================"
echo "Ruby Gem Installation Summary"
echo "========================================"
echo ""
echo "Total packages: $PACKAGE_COUNT"
echo "Successfully installed: $INSTALLED"
echo "Failed: $FAILED"
echo ""

if [ "$INSTALLED" -gt 0 ]; then
    echo "[OK] Ruby gem restoration complete"
else
    echo "[ERROR] No packages were installed"
    exit 1
fi

echo ""
