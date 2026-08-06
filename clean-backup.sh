#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR"

echo "========================================"
echo "[BACKUP] Starting Clean Backup"
echo "========================================"

# 1. GNOME Shell Extensions
echo "-> Backing up GNOME Shell Extensions..."
mkdir -p "$BACKUP_DIR/extensions"
rm -rf "$BACKUP_DIR/extensions/"*
if [ -d "$HOME/.local/share/gnome-shell/extensions" ]; then
    cp -r "$HOME/.local/share/gnome-shell/extensions/"* "$BACKUP_DIR/extensions/" 2>/dev/null || true
fi

# 2. Package lists (Pacman native, AUR, npm global)
echo "-> Backing up Package Lists (Pacman, AUR, npm)..."
mkdir -p "$BACKUP_DIR/packages"

if command -v pacman &> /dev/null; then
    # Native explicit pacman packages
    pacman -Qqen > "$BACKUP_DIR/packages/pacman-native.txt"
    # AUR packages
    pacman -Qqm > "$BACKUP_DIR/packages/aur-packages.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/aur-packages.txt"
fi

if command -v npm &> /dev/null; then
    # Global npm packages
    npm list -g --depth=0 --parseable 2>/dev/null \
        | tail -n +2 \
        | xargs -r -n1 basename \
        | awk 'NF {
            pkg=$1
            if (pkg ~ /^@[^/]+\/[^@]+@[0-9]/) {
                sub(/@[0-9].*$/, "", pkg)
            } else if (pkg !~ /^@/ && pkg ~ /@[0-9]/) {
                sub(/@[0-9].*$/, "", pkg)
            }
            print pkg
        }' | sort -u > "$BACKUP_DIR/packages/npm-global.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/npm-global.txt"
fi

# 3. Databases (MySQL/MariaDB & PostgreSQL)
echo "-> Backing up Databases..."
mkdir -p "$BACKUP_DIR/databases"

# MySQL / MariaDB
if command -v mysqldump &> /dev/null && systemctl is-active --quiet mysqld mariadb mysql 2>/dev/null; then
    echo "   * Backing up MySQL/MariaDB..."
    MYSQL_DIR="$BACKUP_DIR/databases/mysql"
    mkdir -p "$MYSQL_DIR"
    
    dbs=$(mysql -e "SHOW DATABASES;" 2>/dev/null | grep -Ev "^(Database|information_schema|performance_schema|mysql|sys)$" || true)
    for db in $dbs; do
        echo "     - Dumping: $db"
        mysqldump --single-transaction --routines --triggers "$db" > "$MYSQL_DIR/${db}.sql" 2>/dev/null || true
    done
fi

# PostgreSQL
if command -v pg_dump &> /dev/null && systemctl is-active --quiet postgresql 2>/dev/null; then
    echo "   * Backing up PostgreSQL..."
    PG_DIR="$BACKUP_DIR/databases/postgresql"
    mkdir -p "$PG_DIR"
    
    dbs=$(sudo -u postgres psql -t -c "SELECT datname FROM pg_database WHERE datistemplate = false AND datname != 'postgres';" 2>/dev/null | grep -v '^$' | sed 's/^[ \t]*//' || true)
    for db in $dbs; do
        echo "     - Dumping: $db"
        sudo -u postgres pg_dump "$db" > "$PG_DIR/${db}.sql" 2>/dev/null || true
    done
    sudo -u postgres pg_dumpall --globals-only > "$PG_DIR/globals.sql" 2>/dev/null || true
fi

echo "========================================"
echo "[SUCCESS] Clean backup complete!"
echo "Saved to: $BACKUP_DIR"
echo "========================================"
