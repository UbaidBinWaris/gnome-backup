#!/bin/bash

# Redis Database Restoration Script
# Restores only Redis data

set -e

DB_DIR="$(dirname "$0")"

echo "========================================"
echo "Redis Database Restoration"
echo "========================================"
echo ""

if [ ! -d "$DB_DIR/redis" ]; then
    echo "[INFO] No Redis backup found"
    echo "Expected location: $DB_DIR/redis/"
    exit 0
fi

if ! command -v redis-cli &> /dev/null; then
    echo "[ERROR] Redis is not installed"
    echo ""
    echo "Install Redis first:"
    echo "  sudo pacman -S redis"
    echo "  sudo systemctl start redis"
    echo ""
    exit 1
fi

HAS_RDB=false
HAS_AOF=false

if [ -f "$DB_DIR/redis/dump.rdb" ]; then
    HAS_RDB=true
    echo "Found Redis RDB dump: $(du -h "$DB_DIR/redis/dump.rdb" | cut -f1)"
fi

if [ -f "$DB_DIR/redis/appendonly.aof" ]; then
    HAS_AOF=true
    echo "Found Redis AOF file: $(du -h "$DB_DIR/redis/appendonly.aof" | cut -f1)"
fi

if [ "$HAS_RDB" = false ] && [ "$HAS_AOF" = false ]; then
    echo "[INFO] No Redis data files to restore"
    exit 0
fi

echo ""
echo "[WARNING] This will:"
echo "  1. Stop the Redis service"
echo "  2. Replace Redis data files"
echo "  3. Restart the Redis service"
echo ""
echo "All current Redis data will be lost!"
echo ""
read -p "Continue with Redis restoration? (yes/no): " -r

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Restoration cancelled"
    exit 0
fi

echo ""
echo "Stopping Redis service..."
sudo systemctl stop redis 2>/dev/null || {
    echo "[WARNING] Failed to stop Redis service"
    echo "You may need to stop it manually"
}

sleep 2

echo "Restoring Redis data files..."

if [ "$HAS_RDB" = true ]; then
    echo "  Copying dump.rdb..."
    sudo cp "$DB_DIR/redis/dump.rdb" /var/lib/redis/dump.rdb 2>/dev/null && \
        echo "  [OK] dump.rdb restored" || \
        echo "  [ERROR] Failed to copy dump.rdb"
    sudo chown redis:redis /var/lib/redis/dump.rdb 2>/dev/null || true
fi

if [ "$HAS_AOF" = true ]; then
    echo "  Copying appendonly.aof..."
    sudo cp "$DB_DIR/redis/appendonly.aof" /var/lib/redis/appendonly.aof 2>/dev/null && \
        echo "  [OK] appendonly.aof restored" || \
        echo "  [ERROR] Failed to copy appendonly.aof"
    sudo chown redis:redis /var/lib/redis/appendonly.aof 2>/dev/null || true
fi

echo ""
echo "Starting Redis service..."
sudo systemctl start redis 2>/dev/null && \
    echo "[OK] Redis service started" || \
    echo "[ERROR] Failed to start Redis service"

sleep 2

# Test connection
if redis-cli ping &>/dev/null; then
    echo ""
    echo "========================================"
    echo "[OK] Redis restoration complete"
    echo "========================================"
    echo ""
    echo "Redis is running and responding to commands"
else
    echo ""
    echo "========================================"
    echo "[WARNING] Redis restoration complete"
    echo "========================================"
    echo ""
    echo "Redis may not be responding. Check the service:"
    echo "  sudo systemctl status redis"
fi

echo ""
