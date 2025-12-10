#!/bin/bash

# Auto-generated script to restore all backed up databases

set -e

DB_DIR="$(dirname "$0")"

echo "[DATABASE] Restoring databases..."
echo "[WARNING]  WARNING: This will restore database backups. Existing data may be affected."
echo ""
read -p "Continue with database restoration? (yes/no) " -r
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Database restoration cancelled."
    exit 0
fi

# Restore MySQL/MariaDB databases
if [ -d "$DB_DIR/mysql" ] && [ -f "$DB_DIR/mysql/database-list.txt" ]; then
    if command -v mysql &> /dev/null; then
        echo "[BACKUP] Restoring MySQL/MariaDB databases..."
        while IFS= read -r db; do
            [ -z "$db" ] && continue
            if [ -f "$DB_DIR/mysql/${db}.sql" ]; then
                echo "   * Restoring database: $db"
                mysql -e "CREATE DATABASE IF NOT EXISTS \`$db\`;" 2>/dev/null || true
                mysql "$db" < "$DB_DIR/mysql/${db}.sql" 2>/dev/null || echo "    [WARNING]  Failed to restore $db"
            fi
        done < "$DB_DIR/mysql/database-list.txt"
    else
        echo "[WARNING]  MySQL/MariaDB not installed, skipping..."
    fi
fi

# Restore PostgreSQL databases
if [ -d "$DB_DIR/postgresql" ] && [ -f "$DB_DIR/postgresql/database-list.txt" ]; then
    if command -v psql &> /dev/null; then
        echo "[BACKUP] Restoring PostgreSQL databases..."
        
        # Restore global objects first
        if [ -f "$DB_DIR/postgresql/globals.sql" ]; then
            sudo -u postgres psql -f "$DB_DIR/postgresql/globals.sql" 2>/dev/null || true
        fi
        
        # Restore each database
        while IFS= read -r db; do
            [ -z "$db" ] && continue
            if [ -f "$DB_DIR/postgresql/${db}.sql" ]; then
                echo "   * Restoring database: $db"
                sudo -u postgres createdb "$db" 2>/dev/null || true
                sudo -u postgres psql "$db" < "$DB_DIR/postgresql/${db}.sql" 2>/dev/null || echo "    [WARNING]  Failed to restore $db"
            fi
        done < "$DB_DIR/postgresql/database-list.txt"
    else
        echo "[WARNING]  PostgreSQL not installed, skipping..."
    fi
fi

# Restore MongoDB databases
if [ -d "$DB_DIR/mongodb" ]; then
    if command -v mongorestore &> /dev/null; then
        echo "[BACKUP] Restoring MongoDB databases..."
        mongorestore "$DB_DIR/mongodb" 2>/dev/null || echo "[WARNING]  Failed to restore MongoDB databases"
    else
        echo "[WARNING]  MongoDB not installed, skipping..."
    fi
fi

# Restore Redis data
if [ -d "$DB_DIR/redis" ]; then
    if command -v redis-cli &> /dev/null; then
        echo "[BACKUP] Restoring Redis data..."
        
        # Stop Redis to restore files
        sudo systemctl stop redis 2>/dev/null || true
        
        if [ -f "$DB_DIR/redis/dump.rdb" ]; then
            sudo cp "$DB_DIR/redis/dump.rdb" /var/lib/redis/dump.rdb 2>/dev/null || echo "[WARNING]  Failed to copy Redis dump"
        fi
        
        if [ -f "$DB_DIR/redis/appendonly.aof" ]; then
            sudo cp "$DB_DIR/redis/appendonly.aof" /var/lib/redis/appendonly.aof 2>/dev/null || echo "[WARNING]  Failed to copy Redis AOF"
        fi
        
        # Restart Redis
        sudo systemctl start redis 2>/dev/null || true
    else
        echo "[WARNING]  Redis not installed, skipping..."
    fi
fi

# Restore SQLite databases
if [ -d "$DB_DIR/sqlite" ] && [ -f "$DB_DIR/sqlite/database-paths.txt" ]; then
    echo "[BACKUP] Restoring SQLite databases..."
    echo "[WARNING]  SQLite databases found at original paths:"
    cat "$DB_DIR/sqlite/database-paths.txt"
    echo ""
    echo "SQLite databases are in: $DB_DIR/sqlite/"
    echo "You may need to manually copy them to their original locations."
fi

echo ""
echo "[OK] Database restoration complete!"
echo "Note: Check logs above for any warnings or errors."
