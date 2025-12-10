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
echo "💡 Tips:"
echo "   - View specific list: cat packages/<filename>.txt"
echo "   - Install all: ./packages/install-all.sh"
echo "   - Update backup: ./backup-gnome.sh"
