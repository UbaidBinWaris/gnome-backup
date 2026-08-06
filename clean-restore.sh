#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR"

echo "========================================"
echo "[RESTORE] Starting Clean Restore"
echo "========================================"

# 1. Restore GNOME Extensions
echo "-> Restoring GNOME Shell Extensions..."
if [ -d "$BACKUP_DIR/extensions" ] && [ "$(ls -A "$BACKUP_DIR/extensions" 2>/dev/null)" ]; then
    EXT_DEST="$HOME/.local/share/gnome-shell/extensions"
    mkdir -p "$EXT_DEST"
    cp -r "$BACKUP_DIR/extensions/"* "$EXT_DEST/" 2>/dev/null || true
    echo "   [OK] Extensions copied to $EXT_DEST"
else
    echo "   [SKIP] No extensions found to restore."
fi

# 2. Restore Packages
echo "-> Restoring Packages (Pacman, AUR, npm)..."

# Native Pacman packages
if [ -f "$BACKUP_DIR/packages/pacman-native.txt" ] && command -v pacman &> /dev/null; then
    echo "   * Installing Pacman packages..."
    sudo pacman -S --needed --noconfirm $(cat "$BACKUP_DIR/packages/pacman-native.txt") || true
fi

# AUR packages
if [ -f "$BACKUP_DIR/packages/aur-packages.txt" ] && [ -s "$BACKUP_DIR/packages/aur-packages.txt" ]; then
    if command -v yay &> /dev/null; then
        echo "   * Installing AUR packages with yay..."
        yay -S --needed --noconfirm $(cat "$BACKUP_DIR/packages/aur-packages.txt") || true
    elif command -v paru &> /dev/null; then
        echo "   * Installing AUR packages with paru..."
        paru -S --needed --noconfirm $(cat "$BACKUP_DIR/packages/aur-packages.txt") || true
    else
        echo "   [WARNING] Neither yay nor paru found. Please install an AUR helper to install AUR packages."
    fi
fi

# npm global packages
if [ -f "$BACKUP_DIR/packages/npm-global.txt" ] && [ -s "$BACKUP_DIR/packages/npm-global.txt" ] && command -v npm &> /dev/null; then
    echo "   * Installing global npm packages..."
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        npm install -g "$pkg" 2>/dev/null || true
    done < "$BACKUP_DIR/packages/npm-global.txt"
fi

# 3. Restore Databases
echo "-> Restoring Databases..."

# MySQL / MariaDB
if [ -d "$BACKUP_DIR/databases/mysql" ] && command -v mysql &> /dev/null; then
    echo "   * Restoring MySQL/MariaDB databases..."
    for sql in "$BACKUP_DIR/databases/mysql"/*.sql; do
        [ -f "$sql" ] || continue
        db=$(basename "$sql" .sql)
        echo "     - Restoring database: $db"
        mysql -e "CREATE DATABASE IF NOT EXISTS \`$db\`;" 2>/dev/null || true
        mysql "$db" < "$sql" 2>/dev/null || true
    done
fi

# PostgreSQL
if [ -d "$BACKUP_DIR/databases/postgresql" ] && command -v psql &> /dev/null; then
    echo "   * Restoring PostgreSQL databases..."
    if [ -f "$BACKUP_DIR/databases/postgresql/globals.sql" ]; then
        sudo -u postgres psql -f "$BACKUP_DIR/databases/postgresql/globals.sql" 2>/dev/null || true
    fi
    for sql in "$BACKUP_DIR/databases/postgresql"/*.sql; do
        [ -f "$sql" ] || continue
        [ "$(basename "$sql")" = "globals.sql" ] && continue
        db=$(basename "$sql" .sql)
        echo "     - Restoring database: $db"
        sudo -u postgres createdb "$db" 2>/dev/null || true
        sudo -u postgres psql "$db" < "$sql" 2>/dev/null || true
    done
fi

echo "========================================"
echo "[SUCCESS] Clean restore complete!"
echo "Log out and log back in to activate GNOME extensions."
echo "========================================"
