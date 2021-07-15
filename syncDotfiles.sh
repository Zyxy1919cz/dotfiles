#!/usr/bin/env bash
set -euo pipefail

echo "Synchronizing local dotfiles"
# ZSH files
cp -iv ~/.config/.zsh/.zshrc config/zsh/.zshrc
cp -iv ~/.config/.zsh/local_aliases.zsh config/zsh/local_aliases.zsh
cp -iv ~/.config/.zsh/local_scripts.zsh config/zsh/local_scripts.zsh
cp -iv ~/.config/.zsh/local_keys.zsh config/zsh/local_keys.zsh
cp -iv ~/.config/.zsh/zplug/packages.zsh config/zsh/packages.zsh

# Rofi files
cp -iv ~/.config/rofi/themes/main.rofi config/rofi/main.rofi

# Eww files
cp -ivr ~/.config/eww config/eww

# Xmonad files
cp -iv ~/.config/.xmonad/xmonad.hs config/xmonad/xmonad.hs
cp -iv ~/.config/.xmonad/xmobarrc0 config/xmonad/xmobarrc0

# Picom files
cp -iv ~/.config/picom/picom.conf config/picom/picom.conf

# Doom Emacs config
cp -iv ~/.config/doom config/doom
echo "Done"
