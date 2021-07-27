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
                            if [ ! -d "config/tilix" ]
                            then
                                mkdir config/tilix
                                if [ ! -d "config/doom" ]
                                then
                                    mkdir config/doom
                                    if [ ! -d "config/eww" ]
                                    then
                                        mkdir config/eww
                                        if [ ! -d "config/polybar"]
                                        then
                                        mkdir config/polybar
                                        if
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

# Tilix config
cp -ivr ~/.config/tilix/* config/tilix/

# Rofi files
cp -ivr ~/.config/rofi/* config/rofi/

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
cp -ivr ~/.config/pacwall/* config/pacwall/

# Wakatime config
cp -ivr ~/.config/.wakatime/* config/wakatime/

# Polybar config
cp -ivr ~/.config/polybar/* config/polybar/

echo "Done"
