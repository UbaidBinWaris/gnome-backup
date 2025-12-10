# Package Backup Reference

This directory contains complete lists of all installed applications and tools from your system.

## Files Overview

| File | Description | Install Command |
|------|-------------|-----------------|
| `pacman-native.txt` | Native Arch Linux packages | `sudo pacman -S --needed $(cat pacman-native.txt)` |
| `aur-packages.txt` | AUR packages | `yay -S --needed $(cat aur-packages.txt)` |
| `flatpak.txt` | Flatpak applications | `flatpak install -y flathub $(cat flatpak.txt)` |
| `snap.txt` | Snap packages | `while read pkg; do sudo snap install "$pkg"; done < snap.txt` |
| `pip3.txt` | Python packages | `pip3 install --user -r pip3.txt` |
| `npm-global.txt` | Node.js global packages | `while read pkg; do npm install -g "$pkg"; done < npm-global.txt` |
| `cargo.txt` | Rust packages | `while read pkg; do cargo install "$pkg"; done < cargo.txt` |
| `ruby-gems.txt` | Ruby gems | `while read gem; do gem install "$gem"; done < ruby-gems.txt` |
| `go-binaries.txt` | Go binaries (reference only) | Manual installation required |

## Quick Installation

### Install Everything at Once
```bash
./install-all.sh
```

### Selective Installation

#### Only Pacman Packages
```bash
sudo pacman -S --needed $(cat pacman-native.txt)
```

#### Only AUR Packages (requires yay)
```bash
yay -S --needed $(cat aur-packages.txt)
```

#### Only Flatpak Apps
```bash
cat flatpak.txt | xargs -I {} flatpak install -y flathub {}
```

#### Only Python Packages
```bash
pip3 install --user -r pip3.txt
```

## Notes

- Package lists are generated automatically by `backup-gnome.sh`
- Empty files mean no packages of that type were installed
- Some packages may no longer be available in repositories
- The `install-all.sh` script handles errors gracefully and continues
- AUR packages require `yay` or `paru` to be installed first

## Troubleshooting

### "Package not found" errors
Some packages may have been renamed or removed from repositories. This is normal.

### AUR helper not found
Install `yay` first:
```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### Permission denied for pip packages
Use `--user` flag:
```bash
pip3 install --user -r pip3.txt
```

### Flatpak remote not configured
Add Flathub repository:
```bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```
