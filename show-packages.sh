#!/bin/bash

# View statistics and details of backed up packages

PACKAGES_DIR="$(dirname "$0")/packages"

if [ ! -d "$PACKAGES_DIR" ]; then
    echo "❌ No packages directory found. Run backup-gnome.sh first."
    exit 1
fi

echo "╔═══════════════════════════════════════════╗"
echo "║   📦 Package Backup Statistics           ║"
echo "╚═══════════════════════════════════════════╝"
echo ""

total=0

# Function to count and display packages
show_stats() {
    local file="$1"
    local name="$2"
    local icon="$3"
    
    if [ -f "$PACKAGES_DIR/$file" ] && [ -s "$PACKAGES_DIR/$file" ]; then
        count=$(wc -l < "$PACKAGES_DIR/$file")
        total=$((total + count))
        printf "%s %-25s %5d packages\n" "$icon" "$name:" "$count"
    else
        printf "%s %-25s %5s\n" "$icon" "$name:" "none"
    fi
}

show_stats "pacman-native.txt" "Pacman (native)" "📦"
show_stats "aur-packages.txt" "AUR packages" "🔧"
show_stats "flatpak.txt" "Flatpak apps" "📱"
show_stats "snap.txt" "Snap packages" "📦"
show_stats "pip3.txt" "Python (pip3)" "🐍"
show_stats "npm-global.txt" "Node.js (npm)" "📗"
show_stats "cargo.txt" "Rust (cargo)" "🦀"
show_stats "ruby-gems.txt" "Ruby gems" "💎"
show_stats "go-binaries.txt" "Go binaries" "🐹"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "%-25s %5d total\n" "TOTAL:" "$total"
echo ""

# Show recent backup timestamp
if [ -f "$PACKAGES_DIR/install-all.sh" ]; then
    backup_date=$(date -r "$PACKAGES_DIR/install-all.sh" "+%Y-%m-%d %H:%M:%S")
    echo "📅 Last backup: $backup_date"
fi

echo ""
echo "╔═══════════════════════════════════════════╗"
echo "║   💾 Database Backup Statistics          ║"
echo "╚═══════════════════════════════════════════╝"
echo ""

DB_DIR="$(dirname "$0")/databases"
db_count=0

if [ -d "$DB_DIR" ]; then
    # MySQL/MariaDB
    if [ -d "$DB_DIR/mysql" ] && [ -f "$DB_DIR/mysql/database-list.txt" ]; then
        mysql_count=$(wc -l < "$DB_DIR/mysql/database-list.txt" 2>/dev/null || echo 0)
        mysql_size=$(du -sh "$DB_DIR/mysql" 2>/dev/null | cut -f1 || echo "0")
        printf "[MYSQL]  %-25s %5d databases (%s)\n" "MySQL/MariaDB:" "$mysql_count" "$mysql_size"
        db_count=$((db_count + mysql_count))
    fi
    
    # PostgreSQL
    if [ -d "$DB_DIR/postgresql" ] && [ -f "$DB_DIR/postgresql/database-list.txt" ]; then
        pg_count=$(wc -l < "$DB_DIR/postgresql/database-list.txt" 2>/dev/null || echo 0)
        pg_size=$(du -sh "$DB_DIR/postgresql" 2>/dev/null | cut -f1 || echo "0")
        printf "[POSTGRESQL] %-25s %5d databases (%s)\n" "PostgreSQL:" "$pg_count" "$pg_size"
        db_count=$((db_count + pg_count))
    fi
    
    # MongoDB
    if [ -d "$DB_DIR/mongodb" ] && [ -f "$DB_DIR/mongodb/database-list.txt" ]; then
        mongo_count=$(wc -l < "$DB_DIR/mongodb/database-list.txt" 2>/dev/null || echo 0)
        mongo_size=$(du -sh "$DB_DIR/mongodb" 2>/dev/null | cut -f1 || echo "0")
        printf "[MONGODB] %-25s %5d databases (%s)\n" "MongoDB:" "$mongo_count" "$mongo_size"
        db_count=$((db_count + mongo_count))
    fi
    
    # Redis
    if [ -d "$DB_DIR/redis" ] && [ -f "$DB_DIR/redis/dump.rdb" -o -f "$DB_DIR/redis/appendonly.aof" ]; then
        redis_size=$(du -sh "$DB_DIR/redis" 2>/dev/null | cut -f1 || echo "0")
        printf "[REDIS] %-25s %5s (%s)\n" "Redis:" "✓" "$redis_size"
        db_count=$((db_count + 1))
    fi
    
    # SQLite
    if [ -d "$DB_DIR/sqlite" ] && [ -f "$DB_DIR/sqlite/database-paths.txt" ]; then
        sqlite_count=$(wc -l < "$DB_DIR/sqlite/database-paths.txt" 2>/dev/null || echo 0)
        sqlite_size=$(du -sh "$DB_DIR/sqlite" 2>/dev/null | cut -f1 || echo "0")
        printf "[SQLITE] %-25s %5d files (%s)\n" "SQLite:" "$sqlite_count" "$sqlite_size"
        db_count=$((db_count + sqlite_count))
    fi
    
    if [ $db_count -eq 0 ]; then
        echo "   No databases backed up"
    else
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        total_db_size=$(du -sh "$DB_DIR" 2>/dev/null | cut -f1 || echo "0")
        printf "%-25s %5d total (%s)\n" "TOTAL DATABASES:" "$db_count" "$total_db_size"
    fi
else
    echo "   No database backups found"
fi

echo ""
echo "💡 Tips:"
echo "   - View packages: cat packages/<filename>.txt"
echo "   - Install packages: ./packages/install-all.sh"
echo "   - Restore databases: ./databases/restore-databases.sh"
echo "   - Update backup: ./backup-gnome.sh"
