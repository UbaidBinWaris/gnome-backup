# Quick Start Guide

## 🚀 Getting Started

### First Time Setup

```bash
# Clone your backup repo
git clone https://github.com/YourUsername/gnome-backup.git ~/gnome-backup
cd ~/gnome-backup

# Make scripts executable (if not already)
chmod +x *.sh
```

## 📋 Available Scripts

### 1. `backup-gnome.sh` - Complete System Backup
**What it does:**
- Backs up all GNOME settings (dconf)
- Saves keyboard shortcuts
- Copies all extensions
- Backs up themes and icons
- **Creates complete package lists** from all sources
- Generates automated install script

**Usage:**
```bash
./backup-gnome.sh
```

**Output:**
- `dconf/` - Settings files
- `extensions/` - All extensions
- `themes/` - GTK themes
- `icons/` - Icon themes
- `packages/` - Package lists + install script

---

### 2. `restore-gnome.sh` - System Restore
**What it does:**
- Restores all GNOME settings
- Restores extensions, themes, icons
- Prompts to install packages
- Reloads GNOME Shell (on X11)

**Usage:**
```bash
./restore-gnome.sh
```

**Interactive:** Asks if you want to install packages immediately.

---

### 3. `packages/install-all.sh` - Package Installation
**What it does:**
- Installs ALL backed up packages
- Handles multiple package managers
- Continues on errors
- Fully automated

**Usage:**
```bash
./packages/install-all.sh
```

**Installs from:**
- Pacman (Arch packages)
- AUR (via yay/paru)
- Flatpak
- Snap
- pip3 (Python)
- npm (Node.js)
- cargo (Rust)
- gem (Ruby)

---

### 4. `show-packages.sh` - View Package & Database Statistics
**What it does:**
- Shows count of backed up packages
- Shows backed up databases and sizes
- Displays backup timestamp
- Provides helpful tips

**Usage:**
```bash
./show-packages.sh
```

**Output:**
```
╔═══════════════════════════════════════════╗
║   📦 Package Backup Statistics           ║
╚═══════════════════════════════════════════╝

📦 Pacman (native):              340 packages
🔧 AUR packages:                  27 packages
🐍 Python (pip3):                373 packages
...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TOTAL:                           821 total

╔═══════════════════════════════════════════╗
║   💾 Database Backup Statistics          ║
╚═══════════════════════════════════════════╝

🐘 PostgreSQL:                    2 databases (188K)
💿 SQLite:                       50 files (13M)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TOTAL DATABASES:                 52 total (13M)
```

---

### 5. `databases/restore-databases.sh` - Database Restoration
**What it does:**
- Restores ALL backed up databases
- Requires explicit confirmation
- Handles multiple database systems
- Safe error handling

**Usage:**
```bash
./databases/restore-databases.sh
```

**⚠️ WARNING:** May overwrite existing database data!

---

## 🔄 Typical Workflow

### On Your Current System (Regular Backup)
```bash
cd ~/gnome-backup
./backup-gnome.sh
git add .
git commit -m "Backup $(date +%Y-%m-%d)"
git push
```

### On a Fresh System (Restore)
```bash
# Install git if needed
sudo pacman -S git

# Clone backup
git clone https://github.com/YourUsername/gnome-backup.git ~/gnome-backup
cd ~/gnome-backup

# Install AUR helper (for AUR packages)
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ~/gnome-backup

# Restore everything
./restore-gnome.sh
# Press 'y' when asked about package installation

# Log out and log back in
```

---

## 📊 What Gets Backed Up

| Category | Items | Location |
|----------|-------|----------|
| **Settings** | dconf, keyboard shortcuts | `dconf/` |
| **Extensions** | All GNOME extensions | `extensions/` |
| **Themes** | GTK themes | `themes/` |
| **Icons** | Icon themes | `icons/` |
| **Packages** | All installed apps/tools | `packages/*.txt` |
| **Databases** | MySQL, PostgreSQL, MongoDB, Redis, SQLite | `databases/` |

---

## 🆘 Common Tasks

### View what's backed up
```bash
./show-packages.sh
```

### View specific package list
```bash
cat packages/pacman-native.txt
cat packages/aur-packages.txt
cat packages/flatpak.txt
```

### View database backups
```bash
ls -lh databases/
cat databases/postgresql/database-list.txt
cat databases/mysql/database-list.txt
```

### Restore only databases
```bash
./databases/restore-databases.sh
```

### Install only specific packages
```bash
# Only Pacman packages
sudo pacman -S --needed $(cat packages/pacman-native.txt)

# Only AUR packages
yay -S --needed $(cat packages/aur-packages.txt)

# Only Flatpak
cat packages/flatpak.txt | xargs -I {} flatpak install -y flathub {}
```

### Update backup
```bash
./backup-gnome.sh
git add . && git commit -m "Update" && git push
```

---

## ⚙️ Configuration

All scripts work out of the box with default paths:
- Backup location: `~/gnome-backup`
- Extensions: `~/.local/share/gnome-shell/extensions`
- Themes: `~/.themes`
- Icons: `~/.icons`

---

## 🛠️ Requirements

**Minimum:**
- Arch Linux (or Arch-based distro)
- GNOME Desktop Environment
- `dconf` (usually pre-installed)
- `git` for version control

**For Full Restore:**
- AUR helper (`yay` or `paru`) for AUR packages
- Internet connection (to download packages)

---

## 📝 Notes

- Backup script is **safe to run multiple times** - it overwrites previous backups
- Restore script **preserves existing files** that aren't in the backup
- Package installation is **non-destructive** - skips already installed packages
- **Always test restore on a VM first** if possible
- **Commit frequently** to track changes over time

---

## 🐛 Troubleshooting

### "command not found: dconf"
```bash
sudo pacman -S dconf
```

### "No AUR helper found"
```bash
# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Extensions not loading
Log out and log back in, or restart GNOME Shell (Alt+F2, type 'r', Enter)

### Package installation fails
Check `packages/README.md` for specific troubleshooting steps

---

**Last Updated:** December 10, 2025  
**Version:** 2.0 (with package backup)
