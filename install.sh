#!/usr/bin/env bash
set -euo pipefail


make_dirs() {
    echo "Creating directories..."
    mkdir -vp ~/Main ~/Main/Devel ~/Main/Documents ~/Main/Downloads ~/Main/Git ~/Main/Docker ~/Main/Documents/org
    mkdir -vp ~/.config/.emacs.d
    mkdir -vp ~/.config/.zsh ~/.config/.xmonad ~/.config/rofi ~/.config/rofi/themes ~/.config/pacwall ~/.config/.wakatime
    mkdir -vp ~/.config/gtk-3.0
}

install_programs() {
    echo "(1/ ) Installing programs..."
    # Development packages
    sudo pacman -Sv --noconfirm git base-devel sddm qt5-graphicaleffects docker docker-compose npm yarn gulp electron python python-pip rustup
    # Applications
    sudo pacman -Sv --noconfirm flameshot firefox
    git clone https://aur.archlinux.org/nvm.git nvm
    git clone https://aur.archlinux.org/discord_arch_electron.git discord
    cd nvm && makepkg -sic && cd .. && rm -frvd nvm
    cd discord && makepkg -sic && cd .. rm -frvd discord
    # Wakatime
    sudo pip install wakatime
    cp -vir config/wakatime/* $WAKATIME_HOME
    systemctl enable sddm
    echo "Done"
}

install_visuals() {
    echo "(2/ ) Installing Fonts"
    git clone https://aur.archlinux.org/nerd-fonts-roboto-mono.git roboto
    git clone https://aur.archlinux.org/ttf-meslo.git meslo
    cd roboto && makepkg -sci && cd .. && rm -rdfv roboto
    cd meslo && makepkg -sci && cd .. && rm -rdfv meslo
    echo "Done"
    echo "(3/ ) Installing Cursor"
    curl https://dllb2.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE2MjIxMzIyOTQiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6IjcxYjQ1MjhhZmMzZjk3ODRjYzdkNTlhNmIyYjI0Yjc1Y2UyYmZiZDkwZTAwYWFhMzU4ZDU2YWExZGY0NGFlOWQyMmUxNjQwODZlMzg1OTY1YmIzOThjODU5ZTYwZDlmOTRkYmU5Y2I5MzhkZDJjYWQyMGFmMjM4MWY2NWY4NjNkIiwidCI6MTYyNTkzMjIzMywic3RmcCI6IjE5ZDFkNDEyNDc5YTc2ZmIzZjMwODYwMzY3ODI1NzFmIiwic3RpcCI6IjQ2LjEzLjE5OC41MyJ9.pQZej7oOe13iqiBCHiRHK0muZb456o4ztikX_HgLd7Y/LyraS-cursors.tar.gz -L -O
    tar xfv LyraS-cursors.tar.gz -C /usr/share/icons/
    echo /usr/share/icons/default/index.theme <<EOF
[Icon Theme]
Inherits=LyraS-cursors
EOF
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
    sudo pacman -Sv --noconfirm ripgrep emacs
    mv -v ~/.emacs.d ~/.config/.emacs.d
    git clone https://github.com/hlissner/doom-emacs ~/.config/.emacs.d
    doom install
    cp -vir config/doom/* ~/.config/.doom.d/
    echo "Done"
}

install_zshell() {
    echo "(1/ ) Installing ZShell..."
    sudo pacman -Sv --noconfirm zsh zsh-completions tmux ranger
    cp -vi config/termite/config ~/.config/termite/config
    touch ~/.config/.zsh/.histfile
    chmod 666 ~/.config/.zsh/.histfile
    cp -vi config/zsh/.zshrc ~/.config/.zsh/.zshrc
    cp -vi config/zsh/local_aliases.zsh ~/.config/.zsh/local_aliases.zsh
    cp -vi config/zsh/local_scripts.zsh ~/.config/.zsh/local_scripts.zsh
    cp -vi config/zsh/local_keys.zsh ~/.config/.zsh/local_keys.zsh
    echo /etc/zsh/zshenv <<EOF
# Setting environment variables
export ZDOTDIR=~/.config/.zsh
export ZPLUG_HOME=~/.config/.zsh/zplug
export DOOMDIR=~/.config/doom
export XMONAD_CONFIG_DIR=~/.config/.xmonad
export XMONAD_DATA_DIR=~/.config/.xmonad
export XMONAD_CACHE_DIR=~/.config/.xmonad
export WAKATIME_HOME=~/.config/.wakatime
export PASSWORD_STORE_TOMB_FILE=~/.pass/.password.tomb
export PASSWORD_STORE_TOMB_KEY=~/.pass/.password.key.tomb
export GNUPGHOME=~/.config/.gnupg
EOF
    #git clone https://github.com/zplug/zplug $ZPLUG_HOME
    cp -iv config/zsh/packages.zsh ~/.config/.zsh/zplug/packages.zsh
    #source ~/.config/.zsh/.zshrc
    source /etc/zsh/zshenv
    echo "Done"
}

install_xmonad() {
    echo "(  ) Installing Xmonad"
    sudo pacman -S --noconfirm xmonad xmonad-contrib rofi xmobar pacwall
    sudo pacman -Sv --noconfirm --needed hsetroot
    git clone https://aur.archlinux.org/picom-rounded-corners.git picom
    cd picom && makepkg -sic && cd .. && rm -frvd picom
    cp -vi config/rofi/main.rofi ~/.config/rofi/themes/main.rofi
    cp -vi config/xmonad/xmonad.hs ~/.config/.xmonad
    cp -vi config/xmonad/xmobarrc0 ~/.config/.xmonad
    cp -vir config/eww/* ~/.config/eww/
    cp -vi config/picom/picom.conf ~/.config/picom/picom.conf
    echo ~/.config/rofi/config.rasi <<EOF
configuration {
              theme: "~/.config/rofi/themes/main.rofi";
}
EOF
    echo "Done"
}

install_pass() {
    echo "(  ) Installing pass"
    sudo pacman -Sv --noconfirm xclip gnupg openssh pass pinentry
    git clone https://aur.archlinux.org/tomb.git tomb
    git clone https://aur.archlinux.org/pass-tomb.git pass-tomb
    curl https://keybase.io/jaromil/pgp_keys.asc | gpg --import
    curl https://pujol.io/keys/0xc5469996f0df68ec.asc | gpg --import
    cd tomb && makepkg -sci && cd .. && rm -frvd tomb
    cd pass-tomb && makepkg -sci && cd .. && rm -frvd pass-tomb
    gpg --delete-keys Denis Pujol
    echo "Done"
}

make_dirs
install_zshell
install_programs
install_visuals
install_emacs
install_xmonad
install_pass

cat <<EOF
Installation done
Append those files

/etc/default/grub
GRUB_THEME=/boot/grub/themes/Atomic/theme.txt

usr/lib/sddm/sddm.conf.d/default.conf
Current=sddm-slice
CursorTheme=LyraS-cursors

Install zranger
EOF
