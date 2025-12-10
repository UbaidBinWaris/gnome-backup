#!/bin/bash

set -e

BACKUP_DIR="$HOME/gnome-backup"

echo "📦 Backing up GNOME settings to $BACKUP_DIR"

mkdir -p "$BACKUP_DIR/extensions"
mkdir -p "$BACKUP_DIR/dconf"

echo "🔹 Saving GNOME settings..."
dconf dump / > "$BACKUP_DIR/dconf/gnome-settings.conf"

echo "🔹 Backing up GNOME extensions..."
EXT_DIR="$BACKUP_DIR/extensions"
rm -rf "$EXT_DIR/*"
cp -r ~/.local/share/gnome-shell/extensions/* "$EXT_DIR/"

echo "🔹 Backing up GTK themes..."
mkdir -p "$BACKUP_DIR/themes"
cp -r ~/.themes/* "$BACKUP_DIR/themes/" 2>/dev/null || true

echo "🔹 Backing up Icons..."
mkdir -p "$BACKUP_DIR/icons"
cp -r ~/.icons/* "$BACKUP_DIR/icons/" 2>/dev/null || true

echo "🔹 Saving keyboard shortcuts..."
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ \
  > "$BACKUP_DIR/dconf/keyboard-shortcuts.conf"

echo "🎉 Backup complete!"
echo "Now commit & push with:  cd $BACKUP_DIR && git add . && git commit -m 'Updated backup' && git push"
