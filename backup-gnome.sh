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

# Create packages directory
mkdir -p "$BACKUP_DIR/packages"

echo "📦 Backing up installed applications and tools..."

# Backup native pacman packages (explicitly installed)
if command -v pacman &> /dev/null; then
    echo "  → Saving pacman packages..."
    pacman -Qqe > "$BACKUP_DIR/packages/pacman-explicit.txt"
    pacman -Qqm > "$BACKUP_DIR/packages/aur-packages.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/aur-packages.txt"
    pacman -Qqen > "$BACKUP_DIR/packages/pacman-native.txt"
fi

# Backup Flatpak packages
if command -v flatpak &> /dev/null; then
    echo "  → Saving Flatpak applications..."
    flatpak list --app --columns=application > "$BACKUP_DIR/packages/flatpak.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/flatpak.txt"
fi

# Backup Snap packages
if command -v snap &> /dev/null; then
    echo "  → Saving Snap packages..."
    snap list | awk 'NR>1 {print $1}' > "$BACKUP_DIR/packages/snap.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/snap.txt"
fi

# Backup pip packages (Python)
if command -v pip &> /dev/null; then
    echo "  → Saving pip packages..."
    pip list --format=freeze > "$BACKUP_DIR/packages/pip.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/pip.txt"
fi

if command -v pip3 &> /dev/null; then
    echo "  → Saving pip3 packages..."
    pip3 list --format=freeze > "$BACKUP_DIR/packages/pip3.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/pip3.txt"
fi

# Backup npm global packages (Node.js)
if command -v npm &> /dev/null; then
    echo "  → Saving npm global packages..."
    npm list -g --depth=0 --json | grep -oP '(?<=")[^"]*(?=":)' | tail -n +2 > "$BACKUP_DIR/packages/npm-global.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/npm-global.txt"
fi

# Backup cargo packages (Rust)
if command -v cargo &> /dev/null; then
    echo "  → Saving cargo packages..."
    cargo install --list | grep -E '^[a-z0-9_-]+ v[0-9]' | awk '{print $1}' > "$BACKUP_DIR/packages/cargo.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/cargo.txt"
fi

# Backup go packages
if command -v go &> /dev/null && [ -d "$HOME/go/bin" ]; then
    echo "  → Saving Go binaries..."
    ls "$HOME/go/bin" > "$BACKUP_DIR/packages/go-binaries.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/go-binaries.txt"
fi

# Backup gem packages (Ruby)
if command -v gem &> /dev/null; then
    echo "  → Saving Ruby gems..."
    gem list --local --no-versions > "$BACKUP_DIR/packages/ruby-gems.txt" 2>/dev/null || touch "$BACKUP_DIR/packages/ruby-gems.txt"
fi

# Create a comprehensive install script
echo "  → Creating install script..."
cat > "$BACKUP_DIR/packages/install-all.sh" << 'INSTALL_SCRIPT'
#!/bin/bash

# Auto-generated script to reinstall all backed up packages
# Run this script to restore all applications and tools

set -e

PACKAGES_DIR="$(dirname "$0")"

echo "🚀 Installing all backed up applications and tools..."
echo "This may take a while. Please be patient."
echo ""

# Install pacman packages
if [ -f "$PACKAGES_DIR/pacman-native.txt" ] && command -v pacman &> /dev/null; then
    echo "📦 Installing pacman packages..."
    sudo pacman -S --needed --noconfirm $(cat "$PACKAGES_DIR/pacman-native.txt") || true
fi

# Install AUR packages (requires yay or paru)
if [ -f "$PACKAGES_DIR/aur-packages.txt" ] && [ -s "$PACKAGES_DIR/aur-packages.txt" ]; then
    if command -v yay &> /dev/null; then
        echo "📦 Installing AUR packages with yay..."
        yay -S --needed --noconfirm $(cat "$PACKAGES_DIR/aur-packages.txt") || true
    elif command -v paru &> /dev/null; then
        echo "📦 Installing AUR packages with paru..."
        paru -S --needed --noconfirm $(cat "$PACKAGES_DIR/aur-packages.txt") || true
    else
        echo "⚠️  No AUR helper found. Please install yay or paru to install AUR packages."
    fi
fi

# Install Flatpak packages
if [ -f "$PACKAGES_DIR/flatpak.txt" ] && [ -s "$PACKAGES_DIR/flatpak.txt" ] && command -v flatpak &> /dev/null; then
    echo "📦 Installing Flatpak applications..."
    while IFS= read -r app; do
        [ -z "$app" ] && continue
        flatpak install -y flathub "$app" 2>/dev/null || true
    done < "$PACKAGES_DIR/flatpak.txt"
fi

# Install Snap packages
if [ -f "$PACKAGES_DIR/snap.txt" ] && [ -s "$PACKAGES_DIR/snap.txt" ] && command -v snap &> /dev/null; then
    echo "📦 Installing Snap packages..."
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        sudo snap install "$pkg" 2>/dev/null || true
    done < "$PACKAGES_DIR/snap.txt"
fi

# Install pip packages
if [ -f "$PACKAGES_DIR/pip3.txt" ] && [ -s "$PACKAGES_DIR/pip3.txt" ] && command -v pip3 &> /dev/null; then
    echo "🐍 Installing pip3 packages..."
    pip3 install --user -r "$PACKAGES_DIR/pip3.txt" || true
fi

# Install npm global packages
if [ -f "$PACKAGES_DIR/npm-global.txt" ] && [ -s "$PACKAGES_DIR/npm-global.txt" ] && command -v npm &> /dev/null; then
    echo "📦 Installing npm global packages..."
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        npm install -g "$pkg" 2>/dev/null || true
    done < "$PACKAGES_DIR/npm-global.txt"
fi

# Install cargo packages
if [ -f "$PACKAGES_DIR/cargo.txt" ] && [ -s "$PACKAGES_DIR/cargo.txt" ] && command -v cargo &> /dev/null; then
    echo "🦀 Installing cargo packages..."
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        cargo install "$pkg" 2>/dev/null || true
    done < "$PACKAGES_DIR/cargo.txt"
fi

# Install Ruby gems
if [ -f "$PACKAGES_DIR/ruby-gems.txt" ] && [ -s "$PACKAGES_DIR/ruby-gems.txt" ] && command -v gem &> /dev/null; then
    echo "💎 Installing Ruby gems..."
    while IFS= read -r gem; do
        [ -z "$gem" ] && continue
        gem install "$gem" 2>/dev/null || true
    done < "$PACKAGES_DIR/ruby-gems.txt"
fi

echo ""
echo "✅ Package installation complete!"
echo "Note: Go binaries must be reinstalled manually from their sources."
INSTALL_SCRIPT

chmod +x "$BACKUP_DIR/packages/install-all.sh"

echo "🎉 Backup complete!"
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
echo "To restore packages, run: $BACKUP_DIR/packages/install-all.sh"
echo "Now commit & push with:  cd $BACKUP_DIR && git add . && git commit -m 'Updated backup' && git push"
