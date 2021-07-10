#!/usr/bin/env bash
set -euo pipefail

install_programs
install_visuals
install_zshell
install_emacs
install_xmonad
install_pass

install_programs(){
    mkdir ~/Main ~/Main/Devel ~/Main/Documents ~/Main/Downloads ~/Main/Git
    echo "(1/ ) Installing programs..."
    pacman -Sv --noconfirm git base-devel sddm qt5-graphicaleffects
    systemctl enable sddm
    echo "Done"
}

install_visuals() {
    echo "(2/ ) Installing Fonts"
    git clone https://aur.archlinux.org/nerd-fonts-roboto-mono.git roboto
    cd roboto && makepkg -sci && cd .. && rm -rdfv roboto
    echo "Done"
    echo "(3/ ) Installing Cursor"
    curl https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE2MjIxMzIyOTQiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6IjcxYjQ1MjhhZmMzZjk3ODRjYzdkNTlhNmIyYjI0Yjc1Y2UyYmZiZDkwZTAwYWFhMzU4ZDU2YWExZGY0NGFlOWQyMmUxNjQwODZlMzg1OTY1YmIzOThjODU5ZTYwZDlmOTRkYmU5Y2I5MzhkZDJjYWQyMGFmMjM4MWY2NWY4NjNkIiwidCI6MTYyNTkzMjIzMywic3RmcCI6IjE5ZDFkNDEyNDc5YTc2ZmIzZjMwODYwMzY3ODI1NzFmIiwic3RpcCI6IjQ2LjEzLjE5OC41MyJ9.pQZej7oOe13iqiBCHiRHK0muZb456o4ztikX_HgLd7Y/LyraS-cursors.tar.gz -L -O
    tar xfv LyraS-cursors.tar.gz -C /usr/share/icons/
    echo /usr/share/icons/default/index.theme <<EOF
[Icon Theme]
Inherits=LyraS-cursors
EOF
    mkdir ~/.config/gtk-3.0
    echo ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-cursor-theme-name=LyraS-cursors
EOF
    echo "Done"
    echo "(4/ ) Installing Visuals"
    curl https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE1MTU0MjYzNDEiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6ImNmNTRmZmZlZmI3ZWMwZWE0ODNkMTAzNDY1YWMxZDZjNWEzY2ZjZDQ4ZmRiZWI3ZGZiZjRjMWYwYTJmNWM2NTE4ZmNmNDUzY2NkY2MyODRlYzI3YzAzNTMzMzRhNWI5NGU3ZTA4ZjkxZjE5ZjdkZTA4NzU0NTAwMzE3ODQxZjFmIiwidCI6MTYyNTkzMjk4NSwic3RmcCI6IjE5ZDFkNDEyNDc5YTc2ZmIzZjMwODYwMzY3ODI1NzFmIiwic3RpcCI6IjQ2LjEzLjE5OC41MyJ9.D9LhESWxdNynd37HqWWb9MEuHLMkiUDcTA-pg8hsesU/Atomic-GRUB-Theme.tar.gz -L -O
    tar xfv Atomic-GRUB-Theme.tar.gz -C /boot/grub/themes
    git clone https://github.com/RadRussianRus/sddm-slice.git
    cp -r sddm-slice /usr/share/sddm/themes/sddm-slice && rm -rfvd sddm-slice
    echo "Done"
}

install_emacs() {
    echo "(6/ ) Installing Emacs..."
    pacman -Sv --noconfirm ripgrep emacs
    mv ~/.emacs.d ~/.config/.emacs.d
    git clone https://github.com/hlissner/doom-emacs ~/.config/.emacs.d
    doom install
    echo "Done"
}

install_zshell() {
    echo "(5/ ) Installing ZShell..."
    pacman -Sv --noconfirm zsh zsh-completions tmux ranger
    mkdir ~/.config/.zsh
    cp /etc/xdg/termite/config ~/.config/termite/config
    touch ~/.config/.zsh/.histfile
    chmod 666 ~/.config/.zsh/.histfile
    mv .zshrc ~/.config/.zsh/.zshrc
    mv local_aliases.zsh ~/.config/.zsh/local_aliases.zsh
    mv local_scripts.zsh ~/.config/.zsh/local_scripts.zsh
    mv local_keys.zsh ~/.config/.zsh/local_keys.zsh
    echo -a /etc/zsh/zshenv <<EOF
# Setting environment variables
export ZDOTDIR=~/.config/.zsh
export ZPLUG_HOME=~/.config/.zsh/zplug
export DOOMDIR=~/.config/.doom.d
export XMONAD_CONFIG_DIR=~/.config/.xmonad
export XMONAD_DATA_DIR=~/.config/.xmonad
export XMONAD_CACHE_DIR=~/.config/.xmonad
export PASSWORD_STORE_TOMB_FILE=~/.pass/.password.tomb
export PASSWORD_STORE_TOMB_KEY=~/.pass/.password.key.tomb
EOF
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    gpg --delete-keys Denis Pujol
    echo ~/.config/.zsh/zplug/plugins.zsh <<EOF
# Zplug packages

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug romkatv/powerlevel10k, as:theme, depth:1
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
EOF
    echo "Done"
}

install_xmodan() {
    echo "(  ) Installing Xmonad"
    pacman -S --noconfirm xmonad xmonad-contrib feh rofi picom
    mkdir ~/.config/.xmonad ~/.config/rofi ~/.config/rofi/themes
    mv main.rofi ~/.config/rofi/themes/main.rofi
    mv xmonad.hs ~/.config/.xmonad
    mv eww ~/.config/eww
    echo ~/.config/rofi/config.rasi <<EOF
configuration {
              theme: "~/.config/rofi/themes/main.rofi";
}
EOF
    echo "Done"
}

install_pass() {
    echo "(  ) Installing pass"
    pacman -Sv --noconfirm xclip gnupg openssh pass pinentry
    git clone https://aur.archlinux.org/tomb.git tomb
    curl https://keybase.io/jaromil/pgp_keys.asc | gpg --import
    curl https://pujol.io/keys/0xc5469996f0df68ec.asc | gpg --import
    cd tomb && makepkg -sci && cd .. && rm -frvd tomb
    git clone https://aur.archlinux.org/pass-tomb.git pass-tomb
    cd pass-tomb && makepkg -sci && cd .. && rm -frvd pass-tomb
    gpg --delete-keys Denis Pujol
    echo "Done"
}

cat <<EOF
Installation done
Append those files

/etc/default/grub
GRUB_THEME=/boot/grub/themes/Atomic/theme.txt

usr/lib/sddm/sddm.conf.d/default.conf
Current=sddm-slice
CursorTheme=LyraS-cursors
EOF
