# GNOME Backup & Restore

Complete backup and restore solution for GNOME desktop environment, including settings, extensions, themes, icons, and **all installed applications and tools**.

## Features

### 🎨 GNOME Settings
- Complete dconf settings backup
- Keyboard shortcuts
- Custom keybindings

### 🧩 Extensions & Themes
- All GNOME Shell extensions
- GTK themes
- Icon themes

### 📦 Applications & Tools
Automatically backs up and restores packages from:
- **Pacman** (native Arch packages)
- **AUR** (Arch User Repository packages)
- **Flatpak** applications
- **Snap** packages
- **pip/pip3** (Python packages)
- **npm** (Node.js global packages)
- **cargo** (Rust packages)
- **Ruby gems**
- **Go binaries** (list only - manual reinstall required)

### 💾 Databases & Data
Automatically backs up and restores databases from:
- **MySQL/MariaDB** (all user databases + schemas)
- **PostgreSQL** (all databases + global objects)
- **MongoDB** (all databases + collections)
- **Redis** (data snapshots + config)
- **SQLite** (all .db files in home directory)

## Usage

### Backup Everything

```bash
./backup-gnome.sh
```

This will create:
- `dconf/` - All GNOME settings
- `extensions/` - All installed extensions
- `themes/` - GTK themes
- `icons/` - Icon themes
- `packages/` - **Complete list of installed packages**
- `packages/install-all.sh` - **Automated package restoration script**
- `databases/` - **Complete database backups**
- `databases/restore-databases.sh` - **Automated database restoration script**

### Restore Everything

```bash
./restore-gnome.sh
```

This will:
1. Restore all GNOME settings
2. Restore extensions, themes, and icons
3. Prompt to install all backed up packages
4. Prompt to restore all backed up databases

### Manual Package Installation

If you skip package installation during restore, you can run it later:

```bash
./packages/install-all.sh
```

### Manual Database Restoration

If you skip database restoration during restore, you can run it later:

```bash
./databases/restore-databases.sh
```

**⚠️ Important:** Database restoration requires the database services to be running and may overwrite existing data.

## Package Files

The backup creates the following package lists in `packages/`:

- `pacman-native.txt` - Native Arch packages
- `pacman-explicit.txt` - All explicitly installed packages
- `aur-packages.txt` - AUR packages (requires yay/paru)
- `flatpak.txt` - Flatpak applications
- `snap.txt` - Snap packages
- `pip3.txt` - Python packages
- `npm-global.txt` - Global npm packages
- `cargo.txt` - Rust packages
- `ruby-gems.txt` - Ruby gems
- `go-binaries.txt` - Go binaries list

## Database Backups

The backup creates database dumps in `databases/`:

- `mysql/*.sql` - MySQL/MariaDB database dumps
- `postgresql/*.sql` - PostgreSQL database dumps
- `mongodb/` - MongoDB BSON dumps
- `redis/dump.rdb` - Redis data snapshot
- `sqlite/*.db` - SQLite database files

**📖 See [DATABASE_GUIDE.md](DATABASE_GUIDE.md) for complete database documentation.**

## Requirements

### For Backup
- `dconf` (GNOME settings)
- Package managers installed on your system

### For Restore
- `dconf` (GNOME settings)
- **AUR Helper**: `yay` or `paru` (for AUR packages)
- Package managers for respective package types

## Installation

1. Clone this repository:
```bash
git clone https://github.com/YourUsername/gnome-backup.git ~/gnome-backup
```

2. Make scripts executable:
```bash
chmod +x ~/gnome-backup/*.sh
```

3. Run backup:
```bash
cd ~/gnome-backup
./backup-gnome.sh
```

4. Commit and push to keep your backup safe:
```bash
git add .
git commit -m "Updated backup $(date +%Y-%m-%d)"
git push
```

## Fresh System Setup

On a fresh Arch Linux installation:

1. Install git and clone your backup:
```bash
sudo pacman -S git
git clone https://github.com/YourUsername/gnome-backup.git ~/gnome-backup
```

2. Install an AUR helper (for AUR packages):
```bash
# Install yay
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

3. Run restore script:
```bash
cd ~/gnome-backup
./restore-gnome.sh
```

4. Log out and log back in!

## Notes

- **AUR packages** require `yay` or `paru` to be installed first
- **Go binaries** are listed but must be manually reinstalled from their sources
- **Database restoration may overwrite existing data** - always confirm before restoring
- **Large databases:** Consider adding `databases/` to `.gitignore` for repos with huge databases
- Package installation can take significant time depending on the number of packages
- Some packages may fail to install if repositories have changed - this is normal
- Wayland users must log out/in to apply GNOME Shell changes
- Backup script is **safe to run multiple times** - it overwrites previous backups

## Automation

Add to your backup routine (optional):

```bash
# Add to crontab for weekly automatic backup
crontab -e
# Add: 0 0 * * 0 /home/yourusername/gnome-backup/backup-gnome.sh
```

## License

Feel free to use and modify as needed.
