#!/usr/bin/env bash
set -euo pipefail


make_dirs() {
    echo "Creating directories..."
    mkdir -vp ~/Main ~/Main/Devel ~/Main/Documents ~/Main/Downloads ~/Main/Git ~/Main/Docker ~/Main/Documents/org
    mkdir -vp ~/.config/.emacs ~/.config/.doom
    mkdir -vp ~/.config/.zsh ~/.config/picom ~/.config/.xmonad ~/.config/rofi ~/.config/rofi/themes ~/.config/tilix ~/.config/pacwall ~/.config/.wakatime ~/.config/eww ~/.config/polybar
    mkdir -vp ~/.config/gtk-3.0
}

copy_dirs() {
    cp -vir config/pacwall/* ~/.config/pacwall/
    cp -vir config/rofi/* ~/.config/rofi/
    cp -vir config/xmonad/* $XMONAD_CONFIG_DIR/
    cp -vir config/eww/* ~/.config/eww/
    cp -vi config/picom/picom.conf ~/.config/picom/picom.conf
    cp -vi config/wakatime/.wakatime.cfg $WAKATIME_HOME/.wakatime.cfg
    cp -vir config/doom/* $DOOMDIR/
    cp -vir config/tilix/* ~/.config/tilix/
    cp -vir config/polybar/* ~/.config/polybar/
    
    # ZShell config
    cp -vi config/zsh/.zshrc ~/.config/.zsh/.zshrc
    cp -vi config/zsh/local_aliases.zsh ~/.config/.zsh/local_aliases.zsh
    cp -vi config/zsh/local_scripts.zsh ~/.config/.zsh/local_scripts.zsh
    cp -vi config/zsh/local_keys.zsh ~/.config/.zsh/local_keys.zsh
    cp -iv config/zsh/packages.zsh ~/.config/.zsh/zplug/packages.zsh
}

install_programs() {
    echo "(1/ ) Installing programs..."
    # Development packages
    sudo pacman -Sv git base-devel sddm brightnessctl pulseaudio alsa-utils pulseaudio-alsa pulseaudio-equalizer pulseaudio-jack qt5-graphicaleffects docker docker-compose gulp electron python python-pip nemo nemo-terminal rustup
    sudo rustup self upgrade-data
    # Applications
    sudo pacman -Sv flameshot firefox
    git clone https://aur.archlinux.org/discord_arch_electron.git discord
    cd discord && makepkg -sic && cd .. && rm -frvd discord
    # Wakatime
    sudo pip install wakatime
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
    git clone https://github.com/yeyushengfan258/Lyra-Cursors.git Lyra
    cd Lyra && sudo ./install.sh && cd .. && rm -fdrv Lyra
    sudo tee -a /etc/gtk-3.0/settings.ini <<EOF
[Settings]
gtk-cursor-theme-name=LyraR-cursors
gtk-font-name = Meslo LG M 11
gtk-application-prefer-dark-theme = true
EOF
    echo "Done installing cursors"
    echo "(4/ ) Installing Visuals..."
    sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/lfelipe1501/Atomic-GRUB2-Theme/master/install.sh)"
    git clone https://github.com/RadRussianRus/sddm-slice.git
    sudo cp -r sddm-slice /usr/share/sddm/themes/sddm-slice && rm -rfvd sddm-slice Atomic-GRUB-Theme.tar.gz
    echo "Done installing visuals"
}

install_emacs() {
    echo "(6/ ) Installing Emacs..."
    sudo pacman -Sv ripgrep emacs
    git clone https://github.com/hlissner/doom-emacs ~/.config/.emacs
    echo "Done"
}

install_zshell() {
    echo "(1/ ) Installing ZShell..."
    sudo pacman -Sv zsh zsh-completions tmux ranger npm yarn tilix
    git clone https://aur.archlinux.org/nvm.git nvm
    cd nvm && makepkg -sic && cd .. && rm -frdv nvm
    touch ~/.config/.zsh/.histfile
    chmod 666 ~/.config/.zsh/.histfile
    sudo tee -a /etc/zsh/zshenv <<EOF
# Setting environment variables
export ZDOTDIR=~/.config/.zsh
export ZPLUG_HOME=~/.config/.zsh/zplug
export EMACSDIR=~/.config/.emacs
export DOOMLOCALDIR=~/.config/.emacs
export DOOMDIR=~/.config/.doom
export XMONAD_CONFIG_DIR=~/.config/.xmonad
export XMONAD_DATA_DIR=~/.config/.xmonad
export XMONAD_CACHE_DIR=~/.config/.xmonad
export WAKATIME_HOME=~/.config/.wakatime
export PASSWORD_STORE_TOMB_FILE=~/.pass/.password.tomb
export PASSWORD_STORE_TOMB_KEY=~/.pass/.password.key.tomb
export GNUPGHOME=~/.config/.gnupg
EOF
    source /etc/zsh/zshenv
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    echo "Done"
}

install_xmonad() {
    echo "(  ) Installing Xmonad"
    sudo pacman -Sv xmonad xmonad-contrib rofi xmobar
    sudo pacman -Sv --needed hsetroot
    git clone https://aur.archlinux.org/polybar.git polybar
    git clone https://aur.archlinux.org/pacwall-git.git pacwall
    git clone https://aur.archlinux.org/picom-rounded-corners.git picom
    cd picom && makepkg -sic && cd .. && rm -frvd picom
    cd pacwall && makepkg -sic && cd .. && rm -frvd pacwall
    cd polybar && makepkg -sic && cd .. && rm -frvd polybar
    echo "Done"
}

install_pass() {
    echo "(  ) Installing pass"
    sudo pacman -Sv xclip gnupg openssh pass pinentry
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
copy_dirs
install_programs
install_visuals
install_emacs
install_xmonad
install_pass

cat <<EOF
Installation done
run afterwards
zsh
doom install && doom sync && doom doctor
Append those files

/usr/share/icons/default/index.theme
[Icon Theme]
Inherits=LyraR-cursors

usr/lib/sddm/sddm.conf.d/default.conf
Current=sddm-slice
CursorTheme=LyraS-cursors

Install zranger
EOF
