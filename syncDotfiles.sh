#!/usr/bin/env bash
set -euo pipefail

echo "Synchronizing local dotfiles"

if [ ! -d "config" ]
then
    echo "Creating folders..."
    mkdir config
    if [ ! -d "config/zsh" ]
    then
        mkdir config/zsh
        if [ ! -d "config/rofi" ]
        then
            mkdir config/rofi
            if [ ! -d "config/xmonad" ]
            then
                mkdir config/xmonad
                if [ ! -d "config/picom" ]
                then
                    mkdir config/picom
                    if [ ! -d "config/pacwall" ]
                    then
                        mkdir config/pacwall
                        if [ ! -d "config/wakatime" ]
                        then
                            mkdir  config/wakatime
                            if [ ! -d "config/termite" ]
                            then
                                mkdir config/termite
                                if [ ! -d config/doom ]
                                then
                                    mkdir config/doom
                                    if [ ! -d config/eww ]
                                    then
                                        mkdir config/eww
                                    fi
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        fi
    fi
fi

# ZSH files
cp -ivf $HOME/.config/.zsh/.zshrc config/zsh
cp -iv $HOME/.config/.zsh/local_aliases.zsh config/zsh
cp -iv $HOME/.config/.zsh/local_scripts.zsh config/zsh
cp -iv $HOME/.config/.zsh/local_keys.zsh config/zsh
cp -iv $HOME/.config/.zsh/zplug/packages.zsh config/zsh

# Termite config
cp -iv ~/.config/termite/config config/termite/config

# Rofi files
cp -iv ~/.config/rofi/themes/main.rofi config/rofi/main.rofi

# Eww files
cp -ivr ~/.config/eww/* config/eww/

# Xmonad files
cp -iv ~/.config/.xmonad/xmonad.hs config/xmonad/xmonad.hs
cp -iv ~/.config/.xmonad/xmobarrc0 config/xmonad/xmobarrc0

# Picom files
cp -iv ~/.config/picom/picom.conf config/picom/picom.conf

# Doom Emacs config
cp -ivr ~/.config/.doom.d/* config/doom/

# Pacwall config
cp -iv ~/.config/pacwall/pacwall.conf config/pacwall/pacwall.conf

# Wakatime config
cp -ivr ~/.config/.wakatime/* config/wakatime/

echo "Done"
