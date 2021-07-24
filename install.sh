#!/usr/bin/env bash
set -euo pipefail


make_dirs() {
    echo "Creating directories..."
    mkdir -vp ~/Main ~/Main/Devel ~/Main/Documents ~/Main/Downloads ~/Main/Git ~/Main/Docker ~/Main/Documents/org
    mkdir -vp ~/.config/.emacs.d ~/.config/.doom.d
    mkdir -vp ~/.config/.zsh ~/.config/.xmonad ~/.config/rofi ~/.config/rofi/themes ~/.config/tilix ~/.config/pacwall ~/.config/.wakatime
    mkdir -vp ~/.config/gtk-3.0
}

install_programs() {
    echo "(1/ ) Installing programs..."
    # Development packages
    sudo pacman -Sv --noconfirm git base-devel sddm brightnessctl pulseaudio alsa-utils pulseaudio-alsa pulseaudio-equalizer pulseaudio-jack qt5-graphicaleffects docker docker-compose gulp electron python python-pip nemo nemo-terminal rustup
    sudo rustup self upgrade-data
    # Applications
    sudo pacman -Sv --noconfirm flameshot firefox
    git clone https://aur.archlinux.org/discord_arch_electron.git discord
    cd discord && makepkg -sic && cd .. && rm -frvd discord
    # Wakatime
    sudo pip install wakatime
    cp -vi config/wakatime/.wakatime.cfg $WAKATIME_HOME/.wakatime.cfg
    systemctl enable sddm
    echo "Done installing programs"
}

install_visuals() {
    echo "(2/ ) Installing Fonts..."
    git clone https://aur.archlinux.org/nerd-fonts-roboto-mono.git roboto
    git clone https://aur.archlinux.org/ttf-meslo.git meslo
    cd roboto && makepkg -sci && cd .. && rm -rdfv roboto
    cd meslo && makepkg -sci && cd .. && rm -rdfv meslo
    echo "Done"
    echo "(3/ ) Installing Cursor..."
    curl https://dllb.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE2MjIxMzIyOTQiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6IjE5NzE1MjU3NjUzNGY0Zjc0MDg5ZjYyZDg4N2YwMWQyYmUzNzc3MDFkMTcxNGRhNmY2MjFlMTRhZGJlYzA4NjgxNGQyZTE3MGE5ZmM2ZTEwOTE2YzMzZWVlNGU5ZmM5NTFhODFjZjFlZTkyZWFiZDU0ZjRkOWVmNDZhZTM1ZjQ1IiwidCI6MTYyNzEzMzE5Nywic3RmcCI6IjFhN2E4ZWIwMTY0NGIxZGQ0MTgwMDQwNzk0NTkzYTlmIiwic3RpcCI6IjE4NS4xNTYuMzguMTIwIn0.I6lh6MtLhrqM5UClNLk2HQvA8vEXzcL78ETYYA__Yeo/LyraS-cursors.tar.gz -L -O
    tar xfv LyraS-cursors.tar.gz -C /usr/share/icons/
    sudo tee -a /usr/share/icons/default/index.theme <<EOF
[Icon Theme]
Inherits=LyraS-cursors
EOF
    sudo tee -a ~/.config/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-cursor-theme-name=LyraS-cursors
EOF
    echo "Done installing cursors"
    echo "(4/ ) Installing Visuals..."
    curl https://dllb.pling.com/api/files/download/j/eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6IjE1MTU0MjYzNDEiLCJ1IjpudWxsLCJsdCI6ImRvd25sb2FkIiwicyI6ImU2MDhhYzYxNWFiYzY3MTE2ZjMyZDRjYzVkZDBlYWUyNDUwMTEzYmI5NGZhOTFmMWZjOTMyNTFlMDNhMGYyMzAwNGU4ZDg3OTMwNTQxZGU4ZTUzY2NmY2RjMzM4MDRjMjRjMmY1YzQwNjUxNGUxODBlZWNhOGI0MmY4ZGE4MTM5IiwidCI6MTYyNzEzMjk3Nywic3RmcCI6IjFhN2E4ZWIwMTY0NGIxZGQ0MTgwMDQwNzk0NTkzYTlmIiwic3RpcCI6IjE4NS4xNTYuMzguMTIwIn0.SYMyscWqVDj82zOR8Gr-c3Jdz0ZOtn-VqMi1WSh9EFI/Atomic-GRUB-Theme.tar.gz -L -O
    tar xfv Atomic-GRUB-Theme.tar.gz -C /boot/grub/themes
    git clone https://github.com/RadRussianRus/sddm-slice.git
    cp -r sddm-slice /usr/share/sddm/themes/sddm-slice && rm -rfvd sddm-slice Atomic-GRUB-Theme.tar.gz
    echo "Done installing visuals"
}

install_emacs() {
    echo "(6/ ) Installing Emacs..."
    sudo pacman -Sv --noconfirm ripgrep emacs
    git clone https://github.com/hlissner/doom-emacs ~/.config/.emacs.d
    cp -vir config/doom/* ~/.config/.doom.d/
    echo "Done"
}

install_zshell() {
    echo "(1/ ) Installing ZShell..."
    sudo pacman -Sv --noconfirm zsh zsh-completions tmux ranger npm yarn tilix
    git clone https://aur.archlinux.org/nvm.git nvm
    cd nvm && makepkg -sic && cd .. && rm -frdv nvm
    cp -vir config/tilix/* ~/.config/tilix/
    touch ~/.config/.zsh/.histfile
    chmod 666 ~/.config/.zsh/.histfile
    cp -vi config/zsh/.zshrc ~/.config/.zsh/.zshrc
    cp -vi config/zsh/local_aliases.zsh ~/.config/.zsh/local_aliases.zsh
    cp -vi config/zsh/local_scripts.zsh ~/.config/.zsh/local_scripts.zsh
    cp -vi config/zsh/local_keys.zsh ~/.config/.zsh/local_keys.zsh
    tee -a /etc/zsh/zshenv <<EOF
# Setting environment variables
export ZDOTDIR=~/.config/.zsh
export ZPLUG_HOME=~/.config/.zsh/zplug
export DOOMDIR=~/.config/.doom.d
export XMONAD_CONFIG_DIR=~/.config/.xmonad
export XMONAD_DATA_DIR=~/.config/.xmonad
export XMONAD_CACHE_DIR=~/.config/.xmonad
export WAKATIME_HOME=~/.config/.wakatime
export PASSWORD_STORE_TOMB_FILE=~/.pass/.password.tomb
export PASSWORD_STORE_TOMB_KEY=~/.pass/.password.key.tomb
export GNUPGHOME=~/.config/.gnupg
EOF
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    cp -iv config/zsh/packages.zsh ~/.config/.zsh/zplug/packages.zsh
    source /etc/zsh/zshenv
    echo "Done"
}

install_xmonad() {
    echo "(  ) Installing Xmonad"
    sudo pacman -Sv --noconfirm xmonad xmonad-contrib rofi xmobar
    sudo pacman -Sv --noconfirm --needed hsetroot
    git clone https://aur.archlinux.org/pacwall-git.git pacwall
    git clone https://aur.archlinux.org/picom-rounded-corners.git picom
    cd picom && makepkg -sic && cd .. && rm -frvd picom
    cd pacwall && makepkg -sic && cd .. && rm -frvd pacwall
    cp -vir config/pacwall/* ~/.config/pacwall/
    cp -vi config/rofi/main.rofi ~/.config/rofi/themes/main.rofi
    cp -vir config/xmonad/* ~/.config/.xmonad/
    cp -vir config/eww/* ~/.config/eww/
    cp -vi config/picom/arch_img.png ~/.config/picom/img/arch_img.png
    cp -vi config/picom/picom.conf ~/.config/picom/picom.conf
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
    zsh && doom install && doom sync
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
