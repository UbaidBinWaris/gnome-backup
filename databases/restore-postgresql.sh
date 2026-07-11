#!/bin/bash

# PostgreSQL Database Restoration Script
# Restores only PostgreSQL databases

set -e

DB_DIR="$(dirname "$0")"

echo "========================================"
echo "PostgreSQL Database Restoration"
echo "========================================"
echo ""

if [ ! -d "$DB_DIR/postgresql" ]; then
    echo "[INFO] No PostgreSQL backup found"
    echo "Expected location: $DB_DIR/postgresql/"
    exit 0
fi

if ! command -v psql &> /dev/null; then
    echo "[ERROR] PostgreSQL is not installed"
    echo ""
    echo "Install PostgreSQL first:"
    echo "  sudo pacman -S postgresql"
    echo "  sudo systemctl start postgresql"
    echo ""
    exit 1
fi

if [ ! -f "$DB_DIR/postgresql/database-list.txt" ]; then
    echo "[ERROR] Database list not found: $DB_DIR/postgresql/database-list.txt"
    exit 1
fi

if [ ! -s "$DB_DIR/postgresql/database-list.txt" ]; then
    echo "[INFO] No databases to restore"
    exit 0
fi

TOTAL=$(wc -l < "$DB_DIR/postgresql/database-list.txt")

echo "Found $TOTAL databases to restore"
echo ""
echo "Databases:"
cat "$DB_DIR/postgresql/database-list.txt" | sed 's/^/  - /'
echo ""
echo "[WARNING] This will overwrite existing databases with the same names!"
echo ""
read -p "Continue with database restoration? (yes/no): " -r

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Restoration cancelled"
    exit 0
fi

echo ""
echo "Restoring PostgreSQL databases..."
echo ""

# Restore global objects first
if [ -f "$DB_DIR/postgresql/globals.sql" ]; then
    echo "Restoring global objects (roles, tablespaces)..."
    sudo -u postgres psql -f "$DB_DIR/postgresql/globals.sql" 2>/dev/null && \
        echo "  [OK] Global objects restored" || \
        echo "  [WARNING] Failed to restore some global objects"
    echo ""
fi

CURRENT=0
while IFS= read -r db; do
    [ -z "$db" ] && continue
    CURRENT=$((CURRENT + 1))
    
    if [ -f "$DB_DIR/postgresql/${db}.sql" ]; then
        echo "[$CURRENT/$TOTAL] Restoring database: $db"
        
        # Create database
        sudo -u postgres createdb "$db" 2>/dev/null || \
            echo "  [INFO] Database $db may already exist"
        
        # Import dump
        sudo -u postgres psql "$db" < "$DB_DIR/postgresql/${db}.sql" 2>/dev/null && \
            echo "  [OK] $db restored successfully" || \
            echo "  [ERROR] Failed to restore $db"
    else
        echo "[$CURRENT/$TOTAL] [WARNING] Dump file not found: ${db}.sql"
    fi
done < "$DB_DIR/postgresql/database-list.txt"

echo ""
echo "========================================"
echo "[OK] PostgreSQL restoration complete"
echo "========================================"
echo ""
