#!/bin/bash

# MySQL/MariaDB Database Restoration Script
# Restores only MySQL/MariaDB databases

set -e

DB_DIR="$(dirname "$0")"

echo "========================================"
echo "MySQL/MariaDB Database Restoration"
echo "========================================"
echo ""

if [ ! -d "$DB_DIR/mysql" ]; then
    echo "[INFO] No MySQL/MariaDB backup found"
    echo "Expected location: $DB_DIR/mysql/"
    exit 0
fi

if ! command -v mysql &> /dev/null; then
    echo "[ERROR] MySQL/MariaDB is not installed"
    echo ""
    echo "Install MySQL/MariaDB first:"
    echo "  sudo pacman -S mysql"
    echo "  # or"
    echo "  sudo pacman -S mariadb"
    echo ""
    exit 1
fi

if [ ! -f "$DB_DIR/mysql/database-list.txt" ]; then
    echo "[ERROR] Database list not found: $DB_DIR/mysql/database-list.txt"
    exit 1
fi

if [ ! -s "$DB_DIR/mysql/database-list.txt" ]; then
    echo "[INFO] No databases to restore"
    exit 0
fi

TOTAL=$(wc -l < "$DB_DIR/mysql/database-list.txt")

echo "Found $TOTAL databases to restore"
echo ""
echo "Databases:"
cat "$DB_DIR/mysql/database-list.txt" | sed 's/^/  - /'
echo ""
echo "[WARNING] This will overwrite existing databases with the same names!"
echo ""
read -p "Continue with database restoration? (yes/no): " -r

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Restoration cancelled"
    exit 0
fi

echo ""
echo "Restoring MySQL/MariaDB databases..."
echo ""

CURRENT=0
while IFS= read -r db; do
    [ -z "$db" ] && continue
    CURRENT=$((CURRENT + 1))
    
    if [ -f "$DB_DIR/mysql/${db}.sql" ]; then
        echo "[$CURRENT/$TOTAL] Restoring database: $db"
        
        # Create database
        mysql -e "CREATE DATABASE IF NOT EXISTS \`$db\`;" 2>/dev/null || {
            echo "  [WARNING] Failed to create database: $db"
            continue
        }
        
        # Import dump
        mysql "$db" < "$DB_DIR/mysql/${db}.sql" 2>/dev/null && \
            echo "  [OK] $db restored successfully" || \
            echo "  [ERROR] Failed to restore $db"
    else
        echo "[$CURRENT/$TOTAL] [WARNING] Dump file not found: ${db}.sql"
    fi
done < "$DB_DIR/mysql/database-list.txt"

echo ""
echo "========================================"
echo "[OK] MySQL/MariaDB restoration complete"
echo "========================================"
echo ""
