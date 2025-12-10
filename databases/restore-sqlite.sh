#!/bin/bash

# SQLite Database Restoration Script
# Restores only SQLite database files

set -e

DB_DIR="$(dirname "$0")"

echo "========================================"
echo "SQLite Database Restoration"
echo "========================================"
echo ""

if [ ! -d "$DB_DIR/sqlite" ]; then
    echo "[INFO] No SQLite backup found"
    echo "Expected location: $DB_DIR/sqlite/"
    exit 0
fi

if ! command -v sqlite3 &> /dev/null; then
    echo "[ERROR] SQLite3 is not installed"
    echo ""
    echo "Install SQLite first:"
    echo "  sudo pacman -S sqlite"
    echo ""
    exit 1
fi

# Count database files
DB_COUNT=$(find "$DB_DIR/sqlite" -type f -name "*.db" | wc -l)

if [ "$DB_COUNT" -eq 0 ]; then
    echo "[INFO] No SQLite database files to restore"
    exit 0
fi

echo "Found $DB_COUNT SQLite database file(s)"
echo ""
echo "Database files:"
find "$DB_DIR/sqlite" -type f -name "*.db" -exec basename {} \; | sed 's/^/  - /'

echo ""
echo "Where should SQLite databases be restored?"
echo "  1. Default location (~/.local/share/)"
echo "  2. Custom location"
echo ""
read -p "Enter choice (1-2): " -r LOCATION_CHOICE

case $LOCATION_CHOICE in
    1)
        RESTORE_DIR="$HOME/.local/share/sqlite"
        ;;
    2)
        read -p "Enter full path for restoration: " -r CUSTOM_DIR
        RESTORE_DIR="${CUSTOM_DIR/#\~/$HOME}"
        ;;
    *)
        echo "[ERROR] Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "Databases will be restored to: $RESTORE_DIR"
echo ""

# Check if directory exists and has files
if [ -d "$RESTORE_DIR" ] && [ "$(find "$RESTORE_DIR" -type f -name "*.db" 2>/dev/null | wc -l)" -gt 0 ]; then
    echo "[WARNING] This directory already contains SQLite databases"
    echo ""
    echo "Existing databases may be overwritten!"
    echo ""
    read -p "Continue with restoration? (yes/no): " -r
    
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        echo "Restoration cancelled"
        exit 0
    fi
else
    read -p "Proceed with restoration? (y/N): " -r
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Restoration cancelled"
        exit 0
    fi
fi

echo ""
echo "Creating directory structure..."
mkdir -p "$RESTORE_DIR"

echo "Restoring SQLite databases..."
echo ""

RESTORED=0
FAILED=0

while IFS= read -r -d '' DB_FILE; do
    DB_NAME=$(basename "$DB_FILE")
    DB_SUBDIR=$(dirname "${DB_FILE#$DB_DIR/sqlite/}")
    
    TARGET_DIR="$RESTORE_DIR/$DB_SUBDIR"
    mkdir -p "$TARGET_DIR"
    
    TARGET_FILE="$TARGET_DIR/$DB_NAME"
    
    echo -n "[$((RESTORED + FAILED + 1))/$DB_COUNT] Restoring $DB_NAME... "
    
    # Validate source database
    if ! sqlite3 "$DB_FILE" "PRAGMA integrity_check;" &>/dev/null; then
        echo "[ERROR] Source database is corrupted"
        ((FAILED++))
        continue
    fi
    
    # Copy database file
    if cp "$DB_FILE" "$TARGET_FILE"; then
        # Verify copied database
        if sqlite3 "$TARGET_FILE" "PRAGMA integrity_check;" &>/dev/null; then
            echo "[OK]"
            ((RESTORED++))
        else
            echo "[ERROR] Copy verification failed"
            rm -f "$TARGET_FILE"
            ((FAILED++))
        fi
    else
        echo "[ERROR] Copy failed"
        ((FAILED++))
    fi
done < <(find "$DB_DIR/sqlite" -type f -name "*.db" -print0)

echo ""
echo "========================================"
echo "SQLite Restoration Summary"
echo "========================================"
echo ""
echo "Total databases: $DB_COUNT"
echo "Successfully restored: $RESTORED"
echo "Failed: $FAILED"
echo ""
echo "Restoration directory: $RESTORE_DIR"
echo ""

if [ "$RESTORED" -gt 0 ]; then
    echo "[OK] SQLite restoration complete"
else
    echo "[ERROR] No databases were restored"
    exit 1
fi

echo ""
