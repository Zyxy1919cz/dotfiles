#!/usr/bin/env bash
set -euo pipefail

echo "Synchronizing local dotfiles"
mv -iv ~/.config/.zsh/.zshrc .zshrc
mv -iv ~/.config/.zsh/local_aliases.zsh local_aliases.zsh
mv -iv ~/.config/.zsh/local_scripts.zsh local_scripts.zsh
mv -iv ~/.config/.zsh/local_keys.zsh local_keys.zsh
mv -iv ~/.config/rofi/themes/main.rofi main.rofi
mv -iv ~/.config/.xmonad/xmonad.hs xmodad.hs
mv -iv ~/.config/eww eww
echo "Done"
