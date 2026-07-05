# 💻 Personal Dotfiles

This repository contains configuration files for my personal dev environment on macOS.

These files are managed using [GNU Stow](https://www.gnu.org/software/stow/), a symlink farm manager that makes it easy to organize, deploy, and version control configuration files without cluttering the system.

---

## 📂 Structure

The repository root directly mirrors the home directory (`~/`). GNU Stow is used to safely symlink these files and folders into their correct locations.

A simplified view of the structure:

```text
~/.dotfiles/
├── .config/
│   └── nvim/        → Symlinked to ~/.config/nvim/
├── .zshrc           → Symlinked to ~/.zshrc
└── README.md
```

## 🚀 Setup & Installation

**1. Clone the repository**
Clone this repository into your home directory as a hidden folder (`~/.dotfiles`):
```bash
git clone https://git.braggnet.net/kbragg/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

**2. Install GNU Stow**
Ensure GNU Stow is installed on your system using your OS's package manager (e.g., `brew install stow` for macOS, `sudo apt install stow` for Debian/Ubuntu).

**3. Apply the Configurations**
GNU Stow creates symlinks based on your current working directory. Make sure you run these commands from inside your `~/.dotfiles` directory.

### Deploy All Configurations
To deploy everything inside your `~/.dotfiles` directory to your home folder (`~/`):
```bash
stow .
```

### Deploy a Specific Package
To deploy configurations for a specific tool (useful for testing isolated changes without affecting your entire environment):
```bash
stow .config/nvim
```

> **Note:** Stow treats each folder in your dotfiles directory as a "package." When you run `stow .config/nvim`, it maps the structure inside that folder directly to your home directory—essentially symlinking `~/.dotfiles/.config/nvim/` to `~/.config/nvim/`.

---

## 🛠️ Maintenance & Usage

### Removing (Unstowing) Configurations
If you ever need to remove the symlinks and revert a configuration, use the `-D` (delete) flag. 

To unstow everything:
```bash
stow -D .
```
To unstow a specific package:
```bash
stow -D .config/nvim
```

### Important Notes
* **Cross-Platform:** While primarily designed for macOS, most configs will support Unix-like operating systems.
* **Symlinks over Copies:** Because this uses symlinks, editing a configuration file in its home location (like `~/.config/nvim/`) directly edits the source file in `~/.dotfiles/.config/nvim/`. You can comfortably make edits and then commit them via Git straight from the dotfiles directory.
* **Idempotent:** It is completely safe to re-run `stow` commands when updating or adding new configs. Stow will simply skip existing, correct symlinks.
