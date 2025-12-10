# GNOME Backup and Restore System

## Overview

This repository provides a comprehensive backup and restore solution for GNOME desktop environments on Arch Linux and Arch-based distributions. The system backs up GNOME settings, extensions, themes, installed applications, and databases, enabling complete system recovery or migration to new installations.

## Features

### GNOME Desktop Environment
- Complete dconf settings backup and restoration
- Keyboard shortcuts and custom keybindings
- All installed GNOME Shell extensions
- GTK themes and icon themes

### Application and Package Management
The system automatically detects and backs up packages from multiple sources:
- **Pacman**: Native Arch Linux packages (both explicitly installed and native packages)
- **AUR (Arch User Repository)**: Community-maintained packages
- **Flatpak**: Universal Linux applications
- **Snap**: Snap packages
- **npm**: Node.js global packages
- **cargo**: Rust packages and tools
- **Ruby gems**: Ruby libraries and tools
- **Go binaries**: Installed Go tools (list only, requires manual reinstallation)

**Note**: Python packages (pip/pip3) are excluded from backup and restoration as they take too long to install (often 2-3 hours). Install Python packages manually as needed.

### Database Backup and Restoration
Automatic detection and backup of databases from running services:
- **MySQL/MariaDB**: Complete database dumps including schemas, stored procedures, triggers, and user lists
- **PostgreSQL**: All user databases plus global objects (roles and tablespaces)
- **MongoDB**: BSON format dumps with collections, indexes, and metadata
- **Redis**: Data snapshots (RDB/AOF files) and configuration
- **SQLite**: Automatic discovery and backup of database files in home directory

## Directory Structure

```
gnome-backup/
├── backup-gnome.sh              # Main backup script
├── restore-gnome.sh             # Main restoration script
├── show-packages.sh             # Statistics and information viewer
├── README.md                    # Documentation
├── dconf/                       # GNOME settings dumps
│   ├── gnome-settings.conf
│   └── keyboard-shortcuts.conf
├── extensions/                  # GNOME Shell extensions
├── themes/                      # GTK themes
├── icons/                       # Icon themes
├── packages/                    # Package lists and installation script
│   ├── install-all.sh          # Automated package installation
│   ├── pacman-native.txt
│   ├── pacman-explicit.txt
│   ├── aur-packages.txt
│   ├── flatpak.txt
│   ├── snap.txt
│   ├── pip3.txt
│   ├── npm-global.txt
│   ├── cargo.txt
│   └── ruby-gems.txt
└── databases/                   # Database backups
    ├── restore-databases.sh    # Automated database restoration
    ├── mysql/                  # MySQL/MariaDB dumps
    ├── postgresql/             # PostgreSQL dumps
    ├── mongodb/                # MongoDB dumps
    ├── redis/                  # Redis snapshots
    └── sqlite/                 # SQLite database files
```

## Installation and Setup

### Initial Setup

1. Clone this repository:
```bash
git clone https://github.com/YourUsername/gnome-backup.git ~/gnome-backup
```

2. Make scripts executable:
```bash
cd ~/gnome-backup
chmod +x backup-gnome.sh restore-gnome.sh show-packages.sh
```

3. Create initial backup:
```bash
./backup-gnome.sh
```

4. Commit and push to preserve backup:
```bash
git add .
git commit -m "Initial backup $(date +%Y-%m-%d)"
git push
```

## Usage

### Creating a Backup

Execute the backup script to save all system configurations, packages, and databases:

```bash
./backup-gnome.sh
```

This operation will:
1. Export all GNOME settings via dconf
2. Copy GNOME Shell extensions, themes, and icons
3. Generate lists of installed packages from all supported sources
4. Create an automated installation script for packages
5. Detect and export all running databases
6. Create an automated restoration script for databases
7. Display a summary of backed up items

### Viewing Backup Statistics

To view information about backed up packages and databases:

```bash
./show-packages.sh
```

This displays:
- Count of packages from each source
- List of backed up databases with sizes
- Last backup timestamp
- Helpful command references

### Restoring from Backup

On a new or existing system, execute the restoration script:

```bash
./restore-gnome.sh
```

The restoration process:
1. Restores all GNOME settings and configurations
2. Restores extensions, themes, and icons
3. Prompts for package installation (optional)
4. Prompts for database restoration (optional)
5. Attempts to reload GNOME Shell (X11 only)

### Manual Package Installation

If package installation was skipped during restoration:

```bash
./packages/install-all.sh
```

### Manual Database Restoration

If database restoration was skipped during restoration:

```bash
./databases/restore-databases.sh
```

**Warning**: Database restoration may overwrite existing data. The script requires explicit confirmation before proceeding.

## System Requirements

### For Backup Operations
- Arch Linux or Arch-based distribution
- GNOME Desktop Environment
- dconf utility (typically pre-installed)
- git for version control
- Active package managers for respective package types

### For Restoration Operations
- Same base requirements as backup
- AUR helper (yay or paru) for AUR package installation
- Running database services for database restoration
- Sufficient disk space for package downloads and database restoration

### Database-Specific Requirements

| Database System | Required Tools | Service Name |
|----------------|---------------|--------------|
| MySQL/MariaDB | mysqldump, mysql | mysqld, mariadb, or mysql |
| PostgreSQL | pg_dump, psql | postgresql |
| MongoDB | mongodump, mongorestore | mongod or mongodb |
| Redis | redis-cli | redis |
| SQLite | sqlite3 (optional) | Not applicable |

## Fresh System Installation Workflow

When setting up a new Arch Linux installation:

1. Install base system and GNOME:
```bash
sudo pacman -S gnome gnome-extra
```

2. Install git:
```bash
sudo pacman -S git
```

3. Clone backup repository:
```bash
git clone https://github.com/YourUsername/gnome-backup.git ~/gnome-backup
cd ~/gnome-backup
```

4. Install AUR helper (required for AUR packages):
```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~/gnome-backup
```

5. Execute restoration:
```bash
./restore-gnome.sh
```

6. Confirm package and database installation when prompted

7. Log out and log back in to apply all settings

## Database Backup Details

### MySQL/MariaDB
- Backs up all user databases (excludes system databases: information_schema, performance_schema, mysql, sys)
- Includes stored procedures, triggers, and routines
- Uses single-transaction for consistency
- Generates separate SQL dump file per database
- Creates list of non-root users for reference

### PostgreSQL
- Backs up all non-template databases
- Exports global objects (roles, tablespaces) separately
- Uses postgres system user for operations
- Generates separate SQL dump file per database
- Creates globals.sql for cluster-wide objects

### MongoDB
- Creates BSON dumps of all databases
- Preserves indexes and metadata
- Native MongoDB format ensures compatibility
- Generates separate directory per database

### Redis
- Triggers save operation before backup
- Copies RDB snapshot file
- Copies AOF file if persistence is enabled
- Saves current configuration

### SQLite
- Searches home directory for database files
- Limits search to files under 100MB
- Maximum of 50 databases backed up
- Direct file copy preserves all data
- Records original file paths for reference

## Performance Optimization

### Parallel Processing
The installation script automatically detects CPU cores and uses parallel processing:
- Systems with 16+ cores: Uses 8 parallel jobs
- Systems with 8-16 cores: Uses 4 parallel jobs  
- Systems with <8 cores: Uses 2 parallel jobs

This significantly reduces installation time on multi-core systems (64-core systems will install much faster).

### Python Packages Excluded
Python packages are excluded from backup/restore because:
- Installation takes 2-3 hours even on fast internet (50+ Mbps)
- Most Python packages are project-specific
- Better to use virtual environments per project

To install Python packages manually when needed:
```bash
pip3 install --user package-name
```

Or use a requirements.txt for your projects:
```bash
pip3 install --user -r requirements.txt
```

### Optimized for All Systems
- High-end servers (64 cores): Maximum parallel processing for speed
- Low-end laptops: Limited parallel jobs to prevent system overload
- Installation continues even if individual packages fail
- Can be interrupted with Ctrl+C and resumed later

## Security Considerations

### Sensitive Data

Database backups may contain sensitive information including:
- User credentials and passwords
- Personal data
- API keys and secrets
- Financial information

### Recommendations for Public Repositories

Add database backups to .gitignore:
```bash
echo "databases/" >> .gitignore
git add .gitignore
git commit -m "Exclude database backups from version control"
```

### Recommendations for Private Repositories

If storing database backups in version control:
- Ensure repository is set to private
- Limit collaborator access appropriately
- Use SSH keys for authentication
- Regularly audit repository access permissions

### Encryption Option

For sensitive database backups:
```bash
tar -czf databases.tar.gz databases/
gpg --symmetric --cipher-algo AES256 databases.tar.gz
rm databases.tar.gz
git add databases.tar.gz.gpg
```

To decrypt:
```bash
gpg -d databases.tar.gz.gpg | tar -xz
```

### External Storage Alternative

Store databases outside version control:
```bash
# Local external drive
rsync -av ~/gnome-backup/databases/ /mnt/external/db-backup/

# Network storage
rsync -av ~/gnome-backup/databases/ user@nas:/backup/databases/

# Cloud storage with rclone
rclone sync ~/gnome-backup/databases/ remote:backup/databases/
```

## Package Installation Details

The automated installation script (packages/install-all.sh) performs the following operations:

1. Installs native Pacman packages using --needed flag to skip already installed packages
2. Installs AUR packages via yay or paru if available
3. Installs Flatpak applications from Flathub repository
4. Installs Snap packages if snapd is available
5. Installs Python packages with --user flag
6. Installs Node.js global packages
7. Installs Rust packages via cargo
8. Installs Ruby gems

The script continues execution even if individual package installations fail, ensuring maximum restoration coverage.

## Database Restoration Details

The automated restoration script (databases/restore-databases.sh) performs the following operations:

1. Requires explicit user confirmation before proceeding
2. Restores MySQL/MariaDB databases by creating databases and importing SQL dumps
3. Restores PostgreSQL global objects first, then individual databases
4. Restores MongoDB databases using mongorestore
5. Stops Redis service, copies data files, and restarts service
6. Provides SQLite database locations for manual restoration

Database services must be running before restoration. The script handles missing services gracefully.

## Automation

### Scheduled Backups

Create automated weekly backups using cron:

```bash
crontab -e
```

Add the following line:
```
0 0 * * 0 /home/yourusername/gnome-backup/backup-gnome.sh
```

This executes the backup script every Sunday at midnight.

### Automated Commit and Push

For automated version control:
```bash
0 2 * * 0 cd /home/yourusername/gnome-backup && ./backup-gnome.sh && git add . && git commit -m "Automated backup $(date +%Y-%m-%d)" && git push
```

This runs Sunday at 2 AM, backing up and pushing to remote repository.

## Troubleshooting

### Package Installation Issues

**AUR packages fail to install**
- Ensure yay or paru is installed
- Install manually: `yay -S package-name`

**Package not found errors**
- Some packages may have been renamed or removed from repositories
- Installation script continues despite individual failures

**Permission errors for pip packages**
- Script uses --user flag by default
- Avoid using sudo with pip installations

### Database Restoration Issues

**MySQL/MariaDB access denied**
- Configure credentials: `mysql_config_editor set --login-path=backup --user=root --password`

**PostgreSQL permission denied**
- Grant privileges: `sudo -u postgres createuser -s $USER`

**MongoDB connection refused**
- Start service: `sudo systemctl start mongod`

**Redis connection failed**
- Start service: `sudo systemctl start redis`

**SQLite database locked**
- Close all applications using the database before backup

### GNOME Shell Issues

**Extensions not loading after restore**
- Log out and log back in
- Restart GNOME Shell on X11: Alt+F2, type 'r', press Enter

**Wayland session cannot reload shell**
- Log out and log back in to apply changes
- This is a Wayland limitation, not a script issue

## Important Notes

- Backup script safely overwrites previous backups in the same directory
- Restoration preserves existing files not present in backup
- Package installation is non-destructive and skips already installed packages
- Database restoration may overwrite existing data - always confirm before proceeding
- Go binaries are listed but must be manually reinstalled from their original sources
- Large databases should be excluded from version control
- Always test restoration on a virtual machine before production use
- Package installation time varies based on number of packages and network speed
- Some package repositories may have changed since backup creation

## Best Practices

1. Create backups before major system changes
2. Test restoration process on a virtual machine periodically
3. Maintain multiple backup versions using git branches or tags
4. Keep backup repository synchronized across devices
5. Review database backups for sensitive information before committing
6. Use private repositories for backups containing databases
7. Document any manual post-restoration steps required for your specific setup
8. Regularly verify backup integrity
9. Keep AUR helper updated for reliable AUR package installation
10. Monitor backup sizes and adjust SQLite file size limits if needed

## Customization

All scripts are written in bash and can be customized:

### Excluding Specific Databases

Edit backup-gnome.sh and modify the exclusion patterns:
```bash
# MySQL - add database names to exclusion list
grep -Ev "^(Database|information_schema|performance_schema|mysql|sys|excluded_db_name)$"
```

### Changing Backup Location

Modify the BACKUP_DIR variable in backup-gnome.sh:
```bash
BACKUP_DIR="/path/to/custom/backup/location"
```

### Adding Package Sources

Add new detection and export blocks in backup-gnome.sh following existing patterns.

### Compression for Large Databases

Modify dump commands to include compression:
```bash
mysqldump database_name | gzip > database_name.sql.gz
pg_dump database_name | gzip > database_name.sql.gz
```

## Support and Contributions

This is a personal backup solution that can be adapted for various use cases. Modifications and improvements are encouraged based on individual requirements.

## License

This project is provided as-is for personal and educational use. Modify and distribute freely as needed.

## Version Information

Current Version: 2.1
Last Updated: December 10, 2025

Features:
- GNOME settings backup and restoration
- Extension, theme, and icon backup
- Multi-source package backup (9 sources)
- Multi-database backup (5 database systems)
- Automated installation scripts
- Interactive restoration process
- Statistics and information display
