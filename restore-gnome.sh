#!/bin/bash

set -e

BACKUP_DIR="$HOME/gnome-backup"

echo "♻ Restoring GNOME settings from $BACKUP_DIR"

echo "🔹 Restoring dconf GNOME settings..."
dconf load / < "$BACKUP_DIR/dconf/gnome-settings.conf"

echo "🔹 Restoring keyboard shortcuts..."
dconf load /org/gnome/settings-daemon/plugins/media-keys/ \
  < "$BACKUP_DIR/dconf/keyboard-shortcuts.conf"

echo "🔹 Restoring GNOME extensions..."
EXT_SRC="$BACKUP_DIR/extensions"
EXT_DEST="$HOME/.local/share/gnome-shell/extensions"
mkdir -p "$EXT_DEST"
cp -r "$EXT_SRC"/* "$EXT_DEST"

echo "🔹 Restoring GTK themes..."
mkdir -p ~/.themes
cp -r "$BACKUP_DIR/themes/"* ~/.themes/ 2>/dev/null || true

echo "🔹 Restoring icon themes..."
mkdir -p ~/.icons
cp -r "$BACKUP_DIR/icons/"* ~/.icons/ 2>/dev/null || true

echo "🔄 Reloading GNOME Shell..."
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo "⛔ Cannot reload GNOME shell on Wayland. You must logout & login."
else
    echo "🔃 Reloading shell..."
    gnome-shell --replace &
fi

echo "🎉 Restore complete!"
echo "Log out & log back in to apply all settings."

