#!/bin/bash

# MongoDB Database Restoration Script
# Restores only MongoDB databases

set -e

DB_DIR="$(dirname "$0")"

echo "========================================"
echo "MongoDB Database Restoration"
echo "========================================"
echo ""

if [ ! -d "$DB_DIR/mongodb" ]; then
    echo "[INFO] No MongoDB backup found"
    echo "Expected location: $DB_DIR/mongodb/"
    exit 0
fi

if ! command -v mongorestore &> /dev/null; then
    echo "[ERROR] MongoDB is not installed"
    echo ""
    echo "Install MongoDB first:"
    echo "  yay -S mongodb-bin"
    echo "  # or"
    echo "  sudo pacman -S mongodb-tools"
    echo "  sudo systemctl start mongodb"
    echo ""
    exit 1
fi

echo "MongoDB backup directory: $DB_DIR/mongodb"
echo ""

if [ -f "$DB_DIR/mongodb/database-list.txt" ] && [ -s "$DB_DIR/mongodb/database-list.txt" ]; then
    TOTAL=$(wc -l < "$DB_DIR/mongodb/database-list.txt")
    echo "Found $TOTAL databases to restore"
    echo ""
    echo "Databases:"
    cat "$DB_DIR/mongodb/database-list.txt" | sed 's/^/  - /'
    echo ""
fi

echo "[WARNING] This will restore all MongoDB databases from backup!"
echo ""
read -p "Continue with database restoration? (yes/no): " -r

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Restoration cancelled"
    exit 0
fi

echo ""
echo "Restoring MongoDB databases..."
echo ""

mongorestore "$DB_DIR/mongodb" 2>&1 | grep -E "(done|restoring|finished|error)" || true

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "[OK] MongoDB restoration complete"
    echo "========================================"
else
    echo ""
    echo "========================================"
    echo "[WARNING] MongoDB restoration completed with errors"
    echo "========================================"
fi

echo ""
