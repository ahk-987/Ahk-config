# 🖼️ Swifty

A lightweight, high-performance **wallpaper selection menu** for **Hyprland** and other Wayland compositors. Swifty provides a smooth interface to preview and apply wallpapers instantly.

> ⚙️ Built with **C++** and **Qt**. Inspired by the original logic found in [RyuZinOh's dotfiles](https://github.com/RyuZinOh/.dotfiles).

---

## ✨ Features

- 🖼️ **Visual Previews:** Smooth, scrollable row of wallpaper thumbnails.
- ⚡ **Instant Apply:** Apply wallpapers with a single click.
- 🛠️ **Customizable Backend:** Fully configurable arguments for tools like `swww`.
- ⚙️ **Dynamic Configuration:** Dedicated config file for paths and commands.
- 🧩 **Wayland Native:** Lightweight and fast, designed specifically for modern compositors.

---

## 🧭 Preview

https://github.com/user-attachments/assets/528bc0b8-c3fb-4ad6-a5a9-67bd622e12d1

---

## ⚙️ Configuration

Swifty automatically creates a configuration file at:  
`~/.config/swifty/swifty.conf`

### Syntax
The config uses a simple `key = "value"` format. 


| Key | Description | Default |
|-----|-------------|---------|
| `backend` | The wallpaper daemon command | `"swww"` |
| `dir` | Path to your wallpaper folder | `"~/Pictures/Wallpapers/"` |
| `arguments` | Custom flags for the backend | See example below |

### Example Config
```bash
backend = "swww"
dir = "~/Pictures/Wallpapers/"

# Use WALLPATH as a placeholder for the selected file
arguments = "img" << "WALLPATH" << "--transition-type" << "wipe" << "--transition-duration" << "1.5"
```
## ⚠️ Important Note

> **Swifty** expects all wallpapers to be stored in here by default:  
> ```
> ~/Pictures/Wallpapers
> ```
> You can later change the directory path in swifty.conf file.  

---
## 🔧 Installation

```bash
git clone https://github.com/saber-88/swifty.git
cd swifty
make
./swifty
```
You can also directly download binary if you don't want to clone the repository.
---
## 🧩 Hyprland Keybind Setup
> Add this to your hyprland.conf
```bash
bind = $mainMod+Shift, S, exec, pkill -x swifty || <path/to/swifty-binary>
```
> Make sure you add `pkill -x swifty` otherwise the swifty will always run as background process.
> You will also need to set windowrules as per your prefrence.
## Window Rules 
> Add this to your hyprland.conf
```bash
windowrule = pin on, match:class swifty
windowrule = float on, match:class swifty
windowrule = move (monitor_w*0.055) (monitor_h-220),  match:class swifty
```
---
## 🙌 Credits
> Original work by [RyuZinOh](https://github.com/RyuZinOh)

>Additional Tweaks by [Karmveer](https://github.com/saber-88)
