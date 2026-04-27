## Overview

This repository contains configuration files for my personal dev environment on macOS.

## Management

These dotfiles are managed using [GNU Stow](https://www.gnu.org/software/stow/), a symlink farm manager that makes it easy to organize and deploy configuration files.

## Structure

The repository root mirrors the home directory (`~/`).

Files and folders are symlinked directly into `~/` using GNU Stow.

Examples:

- `.zshrc` → `~/.zshrc`
- `.config/` → `~/.config/`

## Setup

1. Clone the repository:

   ```bash
   git clone https://git.braggnet.net/kbragg/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Install GNU Stow (if you don't already have it):

   ```bash
   brew install stow
   ```

3. Apply configurations:

   ```bash
   stow .
   ```

## Notes

- Designed for macOS
- Uses symlinks instead of copying files
- Safe to re-run `stow` when updating configs
