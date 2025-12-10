#!/bin/bash

# GNOME Settings Restoration Script
# This script restores GNOME settings, extensions, themes, packages, and databases

BACKUP_DIR="$HOME/gnome-backup"

echo "========================================"
echo "GNOME Settings Restoration"
echo "========================================"
echo ""

# Check if backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "ERROR: Backup directory not found at $BACKUP_DIR"
    echo "Please ensure you have cloned or created the backup directory."
    exit 1
fi

# Restore GNOME settings
echo "Restoring GNOME settings..."
if [ -f "$BACKUP_DIR/dconf/gnome-settings.conf" ]; then
    dconf load / < "$BACKUP_DIR/dconf/gnome-settings.conf" && echo "  SUCCESS: GNOME settings restored" || echo "  WARNING: Failed to restore GNOME settings"
else
    echo "  WARNING: gnome-settings.conf not found, skipping"
fi

# Restore keyboard shortcuts
echo "Restoring keyboard shortcuts..."
if [ -f "$BACKUP_DIR/dconf/keyboard-shortcuts.conf" ]; then
    dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$BACKUP_DIR/dconf/keyboard-shortcuts.conf" && echo "  SUCCESS: Keyboard shortcuts restored" || echo "  WARNING: Failed to restore keyboard shortcuts"
else
    echo "  WARNING: keyboard-shortcuts.conf not found, skipping"
fi

# Restore GNOME extensions
echo "Restoring GNOME extensions..."
if [ -d "$BACKUP_DIR/extensions" ]; then
    EXT_DEST="$HOME/.local/share/gnome-shell/extensions"
    mkdir -p "$EXT_DEST"
    
    # Check if there are any extensions to copy
    if [ "$(ls -A $BACKUP_DIR/extensions 2>/dev/null)" ]; then
        cp -r "$BACKUP_DIR/extensions/"* "$EXT_DEST/" 2>/dev/null && echo "  SUCCESS: Extensions restored" || echo "  WARNING: Some extensions may have failed to copy"
    else
        echo "  WARNING: No extensions found in backup"
    fi
else
    echo "  WARNING: Extensions directory not found, skipping"
fi

# Restore GTK themes
echo "Restoring GTK themes..."
if [ -d "$BACKUP_DIR/themes" ]; then
    mkdir -p "$HOME/.themes"
    
    if [ "$(ls -A $BACKUP_DIR/themes 2>/dev/null)" ]; then
        cp -r "$BACKUP_DIR/themes/"* "$HOME/.themes/" 2>/dev/null && echo "  SUCCESS: Themes restored" || echo "  WARNING: Some themes may have failed to copy"
    else
        echo "  WARNING: No themes found in backup"
    fi
else
    echo "  WARNING: Themes directory not found, skipping"
fi

# Restore icon themes
echo "Restoring icon themes..."
if [ -d "$BACKUP_DIR/icons" ]; then
    mkdir -p "$HOME/.icons"
    
    if [ "$(ls -A $BACKUP_DIR/icons 2>/dev/null)" ]; then
        cp -r "$BACKUP_DIR/icons/"* "$HOME/.icons/" 2>/dev/null && echo "  SUCCESS: Icons restored" || echo "  WARNING: Some icons may have failed to copy"
    else
        echo "  WARNING: No icons found in backup"
    fi
else
    echo "  WARNING: Icons directory not found, skipping"
fi

# Reload GNOME Shell
echo ""
echo "Reloading GNOME Shell..."
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "  NOTE: Cannot reload GNOME Shell on Wayland session."
    echo "  Please log out and log back in to apply changes."
else
    echo "  Attempting to reload GNOME Shell (X11 session)..."
    gnome-shell --replace &
    echo "  Shell reload initiated"
fi

echo ""
echo "========================================"
echo "Package Installation"
echo "========================================"
echo ""

if [ -f "$BACKUP_DIR/packages/install-all.sh" ]; then
    echo "Package installation script found: $BACKUP_DIR/packages/install-all.sh"
    echo ""
    read -p "Do you want to install packages now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Starting package installation..."
        bash "$BACKUP_DIR/packages/install-all.sh"
    else
        echo "Skipping package installation."
        echo "You can install packages later by running:"
        echo "  $BACKUP_DIR/packages/install-all.sh"
    fi
else
    echo "WARNING: Package installation script not found"
    echo "Expected location: $BACKUP_DIR/packages/install-all.sh"
fi

echo ""
echo "========================================"
echo "Database Restoration"
echo "========================================"
echo ""

if [ -f "$BACKUP_DIR/databases/restore-databases.sh" ]; then
    echo "Database restoration script found: $BACKUP_DIR/databases/restore-databases.sh"
    echo ""
    echo "WARNING: Database restoration will overwrite existing data!"
    read -p "Do you want to restore databases now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "Starting database restoration..."
        bash "$BACKUP_DIR/databases/restore-databases.sh"
    else
        echo "Skipping database restoration."
        echo "You can restore databases later by running:"
        echo "  $BACKUP_DIR/databases/restore-databases.sh"
    fi
else
    echo "NOTE: No database backup found"
    echo "If you have database backups, they should be at:"
    echo "  $BACKUP_DIR/databases/restore-databases.sh"
fi

echo ""
echo "========================================"
echo "Restoration Complete"
echo "========================================"
echo ""
echo "Summary:"
echo "  - GNOME settings: Restored"
echo "  - Extensions: Restored"
echo "  - Themes and Icons: Restored"
echo "  - Packages: Check output above"
echo "  - Databases: Check output above"
echo ""
echo "IMPORTANT: Log out and log back in to apply all settings."
echo ""

