#!/bin/bash

# ==============================================================================
#  _   _                  _                 _    ___           _        _ _ 
# | | | |_   _ _ __  _ __| | __ _ _ __   __| |  |_ _|_ __  ___| |_ __ _| | |
# | |_| | | | | '_ \| '__| |/ _` | '_ \ / _` |   | || '_ \/ __| __/ _` | | |
# |  _  | |_| | |_) | |  | | (_| | | | | (_| |   | || | | \__ \ || (_| | | |
# |_| |_|\__, | .__/|_|  |_|\__,_|_| |_|\__,_|  |___|_| |_|___/\__\__,_|_|_|
#        |___/|_|                                                           
# ==============================================================================
# Install Script for Personal Hyprland Dotfiles
# ==============================================================================

set -e

# Styling helpers
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}==================================================${NC}"
echo -e "${MAGENTA}   🚀 Welcome to Billy's Hyprland Setup Installer!  ${NC}"
echo -e "${CYAN}==================================================${NC}"
echo ""

# 1. Check/List required Arch Linux packages
PACKAGES=(
    "hyprland"
    "waybar"
    "swaybg"
    "rofi"
    "dunst"
    "kitty"
    "grim"
    "slurp"
    "swappy"
)

echo -e "${BLUE}[1/5] Checking essential dependencies...${NC}"
MISSING_PACKAGES=()
for pkg in "${PACKAGES[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
        echo -e "  [${GREEN}✓${NC}] $pkg is installed"
    else
        echo -e "  [${RED}✗${NC}] $pkg is missing"
        MISSING_PACKAGES+=("$pkg")
    fi
done

# Check matugen
if [ -f "$HOME/.local/bin/matugen" ] || command -v matugen &>/dev/null; then
    echo -e "  [${GREEN}✓${NC}] matugen is installed"
else
    echo -e "  [${YELLOW}!${NC}] matugen is missing (needed for dynamic wallpaper colors)"
fi

if [ ${#MISSING_PACKAGES[@]} -ne 0 ]; then
    echo ""
    echo -e "${YELLOW}⚠️  Some dependencies are missing: ${MISSING_PACKAGES[*]}${NC}"
    echo -e "You should install them using your package manager (e.g., 'sudo pacman -S package_name')."
fi
echo ""

# 2. Define source and destination directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/hypr_backup_$(date +%Y%m%d_%H%M%S)"

echo -e "${BLUE}[2/5] Creating backups of existing configuration...${NC}"
# Backup existing files if they exist
mkdir -p "$BACKUP_DIR"
BACKED_UP=false

if [ -d "$HOME/.config/hypr" ]; then
    echo -e "  Backing up ~/.config/hypr to $BACKUP_DIR/hypr..."
    cp -r "$HOME/.config/hypr" "$BACKUP_DIR/"
    BACKED_UP=true
fi

if [ -f "$HOME/.local/bin/anti" ] || [ -f "$HOME/.local/bin/setwall" ]; then
    echo -e "  Backing up custom scripts to $BACKUP_DIR/bin..."
    mkdir -p "$BACKUP_DIR/bin"
    [ -f "$HOME/.local/bin/anti" ] && cp "$HOME/.local/bin/anti" "$BACKUP_DIR/bin/"
    [ -f "$HOME/.local/bin/setwall" ] && cp "$HOME/.local/bin/setwall" "$BACKUP_DIR/bin/"
    BACKED_UP=true
fi

if [ "$BACKED_UP" = true ]; then
    echo -e "  ${GREEN}✓ Backups saved in $BACKUP_DIR${NC}"
else
    echo -e "  No existing configs found, skipping backup."
fi
echo ""

# 3. Copy files to destination
echo -e "${BLUE}[3/5] Deploying Hyprland configuration files...${NC}"
mkdir -p "$HOME/.config/hypr"
mkdir -p "$HOME/.local/bin"

# Copy all files from repository config/hypr to ~/.config/hypr
# Excluding install.sh itself to keep target clean
find "$SCRIPT_DIR" -maxdepth 1 ! -name "install.sh" ! -name "." ! -name ".." -exec cp -r {} "$HOME/.config/hypr/" \;
echo -e "  [${GREEN}✓${NC}] Config files copied to ~/.config/hypr"

# Copy executable scripts
cp "$SCRIPT_DIR/scripts/anti" "$HOME/.local/bin/anti" 2>/dev/null || cp "$HOME/.config/hypr/scripts/anti" "$HOME/.local/bin/anti" 2>/dev/null || true
cp "$SCRIPT_DIR/scripts/setwall" "$HOME/.local/bin/setwall" 2>/dev/null || cp "$HOME/.config/hypr/scripts/setwall" "$HOME/.local/bin/setwall" 2>/dev/null || true

# Make sure all scripts in ~/.config/hypr/scripts/ are executable
if [ -d "$HOME/.config/hypr/scripts" ]; then
    chmod +x "$HOME/.config/hypr/scripts/"* 2>/dev/null || true
fi
chmod +x "$HOME/.local/bin/anti" 2>/dev/null || true
chmod +x "$HOME/.local/bin/setwall" 2>/dev/null || true
echo -e "  [${GREEN}✓${NC}] Custom scripts installed and made executable"
echo ""

# 4. Set up default wallpaper symbolic link
echo -e "${BLUE}[4/5] Setting up wallpapers...${NC}"
mkdir -p "$HOME/.config/hypr/wallpapers"
if [ -f "$HOME/.config/hypr/wallpapers/night.jpg" ]; then
    ln -sf "$HOME/.config/hypr/wallpapers/night.jpg" "$HOME/.config/hypr/wallpapers/current.jpg"
    echo -e "  [${GREEN}✓${NC}] Default wallpaper symlink created"
else
    echo -e "  [${YELLOW}!${NC}] No wallpapers found to symlink"
fi
echo ""

# 5. Initialize the system theme
echo -e "${BLUE}[5/5] Initializing themes...${NC}"
if [ -f "$HOME/.local/bin/setwall" ] && [ -f "$HOME/.config/hypr/wallpapers/current.jpg" ]; then
    echo -e "  Running setwall to initialize themes..."
    "$HOME/.local/bin/setwall" "$HOME/.config/hypr/wallpapers/current.jpg" &>/dev/null || true
    echo -e "  [${GREEN}✓${NC}] Themes initialized successfully"
else
    echo -e "  [${YELLOW}!${NC}] Skipping initialization (setwall or current.jpg missing)"
fi

echo ""
echo -e "${CYAN}==================================================${NC}"
echo -e "${GREEN}      🎉 Installation Completed Successfully!       ${NC}"
echo -e "${CYAN}==================================================${NC}"
echo -e "Log out and log back in (or press SUPER+SHIFT+R/SUPER+SHIFT+Q) to reload Hyprland."
echo -e "Use ${YELLOW}SUPER + SHIFT + W${NC} to open the wallpaper selector!"
echo -e "${CYAN}==================================================${NC}"
