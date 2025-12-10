#!/bin/bash

set -e

BACKUP_DIR="$HOME/gnome-backup"

echo "[BACKUP] Backing up GNOME settings to $BACKUP_DIR"

mkdir -p "$BACKUP_DIR/extensions"
mkdir -p "$BACKUP_DIR/dconf"

echo "  - Saving GNOME settings..."
dconf dump / > "$BACKUP_DIR/dconf/gnome-settings.conf"

echo "  - Backing up GNOME extensions..."
EXT_DIR="$BACKUP_DIR/extensions"
rm -rf "$EXT_DIR/*"
cp -r ~/.local/share/gnome-shell/extensions/* "$EXT_DIR/"

echo "  - Backing up GTK themes..."
mkdir -p "$BACKUP_DIR/themes"
cp -r ~/.themes/* "$BACKUP_DIR/themes/" 2>/dev/null || true

echo "  - Backing up Icons..."
mkdir -p "$BACKUP_DIR/icons"
cp -r ~/.icons/* "$BACKUP_DIR/icons/" 2>/dev/null || true

echo "  - Saving keyboard shortcuts..."
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ \
  > "$BACKUP_DIR/dconf/keyboard-shortcuts.conf"

# Create packages directory
mkdir -p "$BACKUP_DIR/packages"

# Create databases directory
mkdir -p "$BACKUP_DIR/databases"

echo "[BACKUP] Backing up installed applications and tools..."

# Backup native pacman packages (explicitly installed)
if command -v pacman &> /dev/null; then
    echo "   * Saving pacman packages..."
    pacman -Qqe > "$BACKUP_DIR/packages/pacman-explicit.txt"
    pacman -Qqm > "$BACKUP_DIR/packages/aur-packages.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/aur-packages.txt"
    pacman -Qqen > "$BACKUP_DIR/packages/pacman-native.txt"
fi

# Backup Flatpak packages
if command -v flatpak &> /dev/null; then
    echo "   * Saving Flatpak applications..."
    flatpak list --app --columns=application > "$BACKUP_DIR/packages/flatpak.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/flatpak.txt"
fi

# Backup Snap packages
if command -v snap &> /dev/null; then
    echo "   * Saving Snap packages..."
    snap list | awk 'NR>1 {print $1}' > "$BACKUP_DIR/packages/snap.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/snap.txt"
fi

# Python packages are skipped (too slow to restore)
# To backup Python packages manually, run:
# pip3 list --format=freeze > packages/pip3.txt

# Backup npm global packages (Node.js)
if command -v npm &> /dev/null; then
    echo "   * Saving npm global packages..."
    npm list -g --depth=0 --json | grep -oP '(?<=")[^"]*(?=":)' | tail -n +2 > "$BACKUP_DIR/packages/npm-global.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/npm-global.txt"
fi

# Backup cargo packages (Rust)
if command -v cargo &> /dev/null; then
    echo "   * Saving cargo packages..."
    cargo install --list | grep -E '^[a-z0-9_-]+ v[0-9]' | awk '{print $1}' > "$BACKUP_DIR/packages/cargo.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/cargo.txt"
fi

# Backup go packages
if command -v go &> /dev/null && [ -d "$HOME/go/bin" ]; then
    echo "   * Saving Go binaries..."
    ls "$HOME/go/bin" > "$BACKUP_DIR/packages/go-binaries.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/go-binaries.txt"
fi

# Backup gem packages (Ruby)
if command -v gem &> /dev/null; then
    echo "   * Saving Ruby gems..."
    gem list --local --no-versions > "$BACKUP_DIR/packages/ruby-gems.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/ruby-gems.txt"
fi

# Create a comprehensive install script
echo "   * Creating install script..."
cat > "$BACKUP_DIR/packages/install-all.sh" << 'INSTALL_SCRIPT'
#!/bin/bash

# Auto-generated script to reinstall all backed up packages
# Run this script to restore all applications and tools

set -e

PACKAGES_DIR="$(dirname "$0")"

echo "[INSTALL] Installing all backed up applications and tools..."
echo "This may take a while. Please be patient."
echo ""

# Install pacman packages
if [ -f "$PACKAGES_DIR/pacman-native.txt" ] && command -v pacman &> /dev/null; then
    echo "[BACKUP] Installing pacman packages..."
    sudo pacman -S --needed --noconfirm $(cat "$PACKAGES_DIR/pacman-native.txt") || true
fi

# Install AUR packages (requires yay or paru)
if [ -f "$PACKAGES_DIR/aur-packages.txt" ] && [ -s "$PACKAGES_DIR/aur-packages.txt" ]; then
    if command -v yay &> /dev/null; then
        echo "[BACKUP] Installing AUR packages with yay..."
        yay -S --needed --noconfirm $(cat "$PACKAGES_DIR/aur-packages.txt") || true
    elif command -v paru &> /dev/null; then
        echo "[BACKUP] Installing AUR packages with paru..."
        paru -S --needed --noconfirm $(cat "$PACKAGES_DIR/aur-packages.txt") || true
    else
        echo "[WARNING]  No AUR helper found. Please install yay or paru to install AUR packages."
    fi
fi

# Install Flatpak packages
if [ -f "$PACKAGES_DIR/flatpak.txt" ] && [ -s "$PACKAGES_DIR/flatpak.txt" ] && command -v flatpak &> /dev/null; then
    echo "[BACKUP] Installing Flatpak applications..."
    while IFS= read -r app; do
        [ -z "$app" ] && continue
        flatpak install -y flathub "$app" 2>/dev/null || true
    done < "$PACKAGES_DIR/flatpak.txt"
fi

# Install Snap packages
if [ -f "$PACKAGES_DIR/snap.txt" ] && [ -s "$PACKAGES_DIR/snap.txt" ] && command -v snap &> /dev/null; then
    echo "[BACKUP] Installing Snap packages..."
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        sudo snap install "$pkg" 2>/dev/null || true
    done < "$PACKAGES_DIR/snap.txt"
fi

# Install pip packages
if [ -f "$PACKAGES_DIR/pip3.txt" ] && [ -s "$PACKAGES_DIR/pip3.txt" ] && command -v pip3 &> /dev/null; then
    echo "[PYTHON] Installing pip3 packages..."
    pip3 install --user -r "$PACKAGES_DIR/pip3.txt" || true
fi

# Install npm global packages
if [ -f "$PACKAGES_DIR/npm-global.txt" ] && [ -s "$PACKAGES_DIR/npm-global.txt" ] && command -v npm &> /dev/null; then
    echo "[BACKUP] Installing npm global packages..."
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        npm install -g "$pkg" 2>/dev/null || true
    done < "$PACKAGES_DIR/npm-global.txt"
fi

# Install cargo packages
if [ -f "$PACKAGES_DIR/cargo.txt" ] && [ -s "$PACKAGES_DIR/cargo.txt" ] && command -v cargo &> /dev/null; then
    echo "[RUST] Installing cargo packages..."
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        cargo install "$pkg" 2>/dev/null || true
    done < "$PACKAGES_DIR/cargo.txt"
fi

# Install Ruby gems
if [ -f "$PACKAGES_DIR/ruby-gems.txt" ] && [ -s "$PACKAGES_DIR/ruby-gems.txt" ] && command -v gem &> /dev/null; then
    echo "[RUBY] Installing Ruby gems..."
    while IFS= read -r gem; do
        [ -z "$gem" ] && continue
        gem install "$gem" 2>/dev/null || true
    done < "$PACKAGES_DIR/ruby-gems.txt"
fi

echo ""
echo "[OK] Package installation complete!"
echo "Note: Go binaries must be reinstalled manually from their sources."
INSTALL_SCRIPT

chmod +x "$BACKUP_DIR/packages/install-all.sh"

echo ""
echo "[DATABASE] Backing up databases..."

# Backup MySQL/MariaDB databases
if command -v mysqldump &> /dev/null && systemctl is-active --quiet mysqld mariadb mysql 2>/dev/null; then
    echo "   * Backing up MySQL/MariaDB databases..."
    DB_DIR="$BACKUP_DIR/databases/mysql"
    mkdir -p "$DB_DIR"
    
    # Get list of databases (excluding system databases)
    mysql -e "SHOW DATABASES;" 2>/dev/null | grep -Ev "^(Database|information_schema|performance_schema|mysql|sys)$" > "$DB_DIR/database-list.txt" 2>/dev/null || true
    
    # Dump each database
    if [ -f "$DB_DIR/database-list.txt" ] && [ -s "$DB_DIR/database-list.txt" ]; then
        while IFS= read -r db; do
            [ -z "$db" ] && continue
            echo "    • Dumping database: $db"
            mysqldump --single-transaction --routines --triggers "$db" > "$DB_DIR/${db}.sql" 2>/dev/null || true
        done < "$DB_DIR/database-list.txt"
    fi
    
    # Save MySQL users and grants (requires root)
    mysql -e "SELECT User, Host FROM mysql.user WHERE User != 'root' AND User != '';" 2>/dev/null > "$DB_DIR/users-list.txt" || touch "$DB_DIR/users-list.txt"
fi

# Backup PostgreSQL databases
if command -v pg_dump &> /dev/null && systemctl is-active --quiet postgresql 2>/dev/null; then
    echo "   * Backing up PostgreSQL databases..."
    DB_DIR="$BACKUP_DIR/databases/postgresql"
    mkdir -p "$DB_DIR"
    
    # Get list of databases (excluding templates)
    sudo -u postgres psql -t -c "SELECT datname FROM pg_database WHERE datistemplate = false AND datname != 'postgres';" 2>/dev/null | grep -v '^$' | sed 's/^[ \t]*//' > "$DB_DIR/database-list.txt" || touch "$DB_DIR/database-list.txt"
    
    # Dump each database
    if [ -f "$DB_DIR/database-list.txt" ] && [ -s "$DB_DIR/database-list.txt" ]; then
        while IFS= read -r db; do
            [ -z "$db" ] && continue
            echo "    • Dumping database: $db"
            sudo -u postgres pg_dump "$db" > "$DB_DIR/${db}.sql" 2>/dev/null || true
        done < "$DB_DIR/database-list.txt"
    fi
    
    # Backup global objects (roles, tablespaces)
    sudo -u postgres pg_dumpall --globals-only > "$DB_DIR/globals.sql" 2>/dev/null || true
fi

# Backup MongoDB databases
if command -v mongodump &> /dev/null && systemctl is-active --quiet mongod mongodb 2>/dev/null; then
    echo "   * Backing up MongoDB databases..."
    DB_DIR="$BACKUP_DIR/databases/mongodb"
    rm -rf "$DB_DIR"
    mkdir -p "$DB_DIR"
    
    mongodump --out="$DB_DIR" 2>/dev/null || true
    
    # List databases
    mongo --quiet --eval "db.adminCommand('listDatabases').databases.forEach(function(d){print(d.name)})" 2>/dev/null > "$DB_DIR/database-list.txt" || touch "$DB_DIR/database-list.txt"
fi

# Backup Redis data
if command -v redis-cli &> /dev/null && systemctl is-active --quiet redis 2>/dev/null; then
    echo "   * Backing up Redis data..."
    DB_DIR="$BACKUP_DIR/databases/redis"
    mkdir -p "$DB_DIR"
    
    # Trigger Redis save
    redis-cli SAVE 2>/dev/null || redis-cli BGSAVE 2>/dev/null || true
    
    # Copy dump file if it exists
    if [ -f /var/lib/redis/dump.rdb ]; then
        cp /var/lib/redis/dump.rdb "$DB_DIR/dump.rdb" 2>/dev/null || sudo cp /var/lib/redis/dump.rdb "$DB_DIR/dump.rdb" 2>/dev/null || true
    elif [ -f /var/lib/redis/appendonly.aof ]; then
        cp /var/lib/redis/appendonly.aof "$DB_DIR/appendonly.aof" 2>/dev/null || sudo cp /var/lib/redis/appendonly.aof "$DB_DIR/appendonly.aof" 2>/dev/null || true
    fi
    
    # Save Redis config
    redis-cli CONFIG GET '*' 2>/dev/null > "$DB_DIR/redis-config.txt" || true
fi

# Backup SQLite databases (find common locations)
if command -v sqlite3 &> /dev/null; then
    echo "   * Searching for SQLite databases..."
    DB_DIR="$BACKUP_DIR/databases/sqlite"
    mkdir -p "$DB_DIR"
    
    # Find SQLite databases in common locations (limit to home directory for safety)
    find "$HOME" -type f \( -name "*.db" -o -name "*.sqlite" -o -name "*.sqlite3" \) -size -100M 2>/dev/null | head -n 50 > "$DB_DIR/database-paths.txt" || touch "$DB_DIR/database-paths.txt"
    
    # Copy SQLite databases
    if [ -f "$DB_DIR/database-paths.txt" ] && [ -s "$DB_DIR/database-paths.txt" ]; then
        while IFS= read -r dbpath; do
            [ -z "$dbpath" ] && continue
            dbname=$(basename "$dbpath")
            echo "    • Copying: $dbname"
            cp "$dbpath" "$DB_DIR/$dbname" 2>/dev/null || true
        done < "$DB_DIR/database-paths.txt"
    fi
fi

# Create database restore script
cat > "$BACKUP_DIR/databases/restore-databases.sh" << 'RESTORE_DB_SCRIPT'
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
RESTORE_DB_SCRIPT

chmod +x "$BACKUP_DIR/databases/restore-databases.sh"

echo "[SUCCESS] Backup complete!"
echo ""
echo "Backed up packages from:"
echo "  - Pacman (native & AUR)"
echo "  - Flatpak"
echo "  - Snap"
echo "  - pip/pip3"
echo "  - npm (global)"
echo "  - cargo"
echo "  - Ruby gems"
echo "  - Go binaries (list only)"
echo ""
echo "Skipped (too slow to restore):"
echo "  - Python packages (pip/pip3)"
echo ""
echo "Backed up databases:"
echo "  - MySQL/MariaDB (if running)"
echo "  - PostgreSQL (if running)"
echo "  - MongoDB (if running)"
echo "  - Redis (if running)"
echo "  - SQLite (found in home directory)"
echo ""
echo "To restore packages, run: $BACKUP_DIR/packages/install-all.sh"
echo "To restore databases, run: $BACKUP_DIR/databases/restore-databases.sh"
echo ""
echo "Now commit & push with:  cd $BACKUP_DIR && git add . && git commit -m 'Updated backup' && git push"
