# 🚀 Billy's Hyprland Configuration

Welcome to my personal **Hyprland** configuration! This setup features a highly customized, clean, and dynamic environment running on **Arch Linux**, powered by **Matugen** for automatic Material You-style color scheme generation.

> [!NOTE]
> This setup is built on top of the excellent ML4W dotfiles and includes custom bindings, workspace optimizations, and custom workflow scripts.

---

## 🎨 Key Features

* **Dynamic Theming (Matugen)**: Extract colors from your wallpaper automatically! Your window borders, shadows, Waybar, Kitty terminal, and Zsh prompt colors adapt dynamically when you change wallpapers.
* **Wallpaper Selector GUI**: A fast, integrated wallpaper switcher menu powered by Rofi.
* **VS Code-Style Project Opener**: Launch Antigravity IDE instantly inside a project folder from the terminal with `anti .`.
* **Clean Borders & Custom Shadows**: High-end visuals with drop-shadows that match your active color accent.

---

## 🛠️ Included Custom Scripts

These are located in the `scripts/` directory and installed to `~/.local/bin/`:

* `setwall`:
  * Runs `setwall <image_path>` to update your wallpaper.
  * Run `setwall` without arguments to open a visual interactive **Rofi menu** showing your available wallpapers.
* `anti`:
  * Runs `anti .` to open Antigravity IDE on the current folder immediately (runs detached in the background with configured systemd memory limits).

---

## ⌨️ Useful Keyboard Shortcuts

| Shortcut | Action |
| :--- | :--- |
| `SUPER + Q` | Open terminal (Kitty) |
| `SUPER + D` | Open App Launcher (Rofi) |
| `SUPER + C` | Close active window |
| `SUPER + SHIFT + W` | **Change wallpaper & theme (Rofi Selector)** |
| `SUPER + O` | Launch Antigravity IDE |
| `SUPER + SHIFT + C` | Open color picker (hyprpicker) |

---

## 📥 Installation

Simply clone this repository and run the automated interactive `install.sh` script:

```bash
# Clone the repository (usually to ~/.config/hypr)
git clone https://github.com/Billy-dev12/Config-hyprland-Billy.git ~/.config/hypr

# Navigate to the directory
cd ~/.config/hypr

# Run the installer
./install.sh
```

### What the installer does:
1. Validates your system dependencies (Hyprland, Waybar, Rofi, swaybg, Matugen, Kitty, etc.).
2. Backups any of your existing Hyprland configurations to a timestamped folder in your home directory.
3. Deploys the new configurations and custom scripts to `~/.config/hypr` and `~/.local/bin`.
4. Initializes the default wallpaper and generates the theme immediately.
