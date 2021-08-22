#!/usr/bin/env bash
set -euo pipefail

WDIR='pwd'
CDIR="$HOME/.config"

make_dirs() {
    echo "Creating directories..."
    mkdir -vp ~/Main ~/Main/Devel ~/Main/Documents ~/Main/Downloads ~/Main/Git ~/Main/Docker ~/Main/Documents/org
    mkdir -vp ~/.config/.doom
    mkdir -vp ~/.config/.zsh ~/.config/picom ~/.config/.xmonad ~/.config/rofi ~/.config/rofi/themes ~/.config/tilix ~/.config/pacwall ~/.config/.wakatime ~/.config/eww ~/.config/polybar ~/.config/ranger
    mkdir -vp ~/.config/gtk-3.0 ~/.config/dunst
}

copy_dirs() {
    cp -vir config/rofi/* $ROFIDIR/
    cp -vir config/xmonad/* $XMONAD_CONFIG_DIR/
    cp -vir config/eww/* $EWWDIR/
    cp -vir config/polybar/* $POLYBARDDIR/
    cp -vir config/ranger/* $RANGERDIR/
    cp -vi config/wakatime/.wakatime.cfg $WAKATIME_HOME/.wakatime.cfg
    cp -vir config/doom/* $DOOMDIR/
    cp -vir config/pacwall/* ~/.config/pacwall/
    cp -vir config/dunst/* ~/.config/dunst/
    cp -vi config/picom/picom.conf ~/.config/picom/picom.conf
    cp -vir config/tilix/* ~/.config/tilix/

    # ZShell config
    cp -vi config/zsh/.zshrc ~/.config/.zsh/.zshrc
    cp -vi config/zsh/local_aliases.zsh ~/.config/.zsh/local_aliases.zsh
    cp -vi config/zsh/local_scripts.zsh ~/.config/.zsh/local_scripts.zsh
    cp -vi config/zsh/local_keys.zsh ~/.config/.zsh/local_keys.zsh
    cp -iv config/zsh/packages.zsh ~/.config/.zsh/zplug/packages.zsh
    cp -iv config/zsh/.p10k.zsh ~/.config/.zsh/.p10k.zsh
}

install_programs() {
    echo "(1/ ) Installing programs..."
    # Development packages
    sudo pacman -Sv git base-devel sddm brightnessctl pulseaudio{,-alsa,-equalizer,-jack} alsa-utils qt5-graphicaleffects docker{,-compose} gulp electron python{,-pip} nemo{,-terminal} rustup ttf-ionicons
    sudo rustup self upgrade-data
    # Applications
    pip install -U platformio
    sudo pacman -Sv flameshot firefox gimp
    pacaur -S discord_arch_electron vscodium-git
    cp -vi config/vscode/product.json ~/.config/VSCodium/product.json
    cp -vi config/vscode/settings.json ~/.config/VSCodium/User/settings.json
    # Wakatime
    sudo pip install wakatime
    systemctl enable sddm
    echo "Done installing programs"
}

install_visuals() {
    echo "(2/ ) Installing Fonts..."
    pacaur -S ttf-meslo nerd-fonts-roboto-mono
    echo "Done"
    echo "(3/ ) Installing Cursor..."
    pacaut -S Lyra-Cursors
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
    git clone https://github.com/hlissner/doom-emacs ~/.emacs.d
    ~/.emacs.d/bin/doom install
    ~/.emacs.d/bin/doom sync
    echo "Done"
}

install_aurhelper() {
    git clone https://aur.archlinux.org/auracle-git.git aur
    git clone https://aur.archlinux.org/pacaur.git pacaur
    cd aur && makepkg -sic && cd .. && rm -frvd aur
    cd pacaur && makepkg -sic && cd .. && rm -frvd pacaur
}

install_zshell() {
    echo "(1/ ) Installing ZShell..."
    sudo pacman -Sv zsh{,-completions} tmux ranger npm yarn tilix
    pacaur -S nvm
    touch ~/.config/.zsh/.histfile
    chmod 666 ~/.config/.zsh/.histfile
    sudo tee -a /etc/zsh/zshenv <<EOF
# Path to config environment variables
export ROFIDIR=~/.config/rofi
export RANGERDIR=~/.config/ranger
export EWWDIR=~/.config/
export POLYBARDDIR=~/.config/polybar
export ZDOTDIR=~/.config/.zsh
export ZPLUG_HOME=~/.config/.zsh/zplug
export EMACSDIR=~/.emacs.d
export DOOMLOCALDIR=~/.emacs.d
export DOOMDIR=~/.config/.doom
export XMONAD_CONFIG_DIR=~/.config/.xmonad
export XMONAD_DATA_DIR=~/.config/.xmonad
export XMONAD_CACHE_DIR=~/.config/.xmonad
export WAKATIME_HOME=~/.config/.wakatime
export GNUPGHOME=~/.config/.gnupg

# Setting environment variables
export PASSWORD_STORE_TOMB_FILE=~/.pass/.password.tomb
export PASSWORD_STORE_TOMB_KEY=~/.pass/.password.key.tomb

# Settings for Xsecurelock
export XSECURELOCK_AUTH_TIMEOUT=10
export XSECURELOCK_BLANK_TIMEOUT=40
export XSECURELOCK_BURNIN_MITIGATION=10
export XSECURELOCK_DIM_ALPHA=70
export XSECURELOCK_DIM_FPS=60
export XSECURELOCK_SAVER_RESET_ON_AUTH_CLOSE=1
export XSECURELOCK_SHOW_DATETIME=1
export XSECURELOCK_SINGLE_AUTH_WINDOW=1
export XSECURELOCK_SHOW_USERNAME=1

# X11 keysum for spawning shell commands from Xsecurelock
# export XSECURELOCK_KEY_%s_COMMAND=""
EOF
    source /etc/zsh/zshenv
    git clone https://github.com/zplug/zplug $ZPLUG_HOME
    echo "Done"
}

install_xmonad() {
    echo "(  ) Installing Xmonad"
    sudo pacman -Sv xmonad{,-contrib} rofi net-tools pacman-contrib
    sudo pacman -Sv --needed hsetroot
    pacaur -S polybar eww-git dunst-git pacwall-git picom-jonaburg-git
    echo "Done"
}

install_pass() {
    echo "(  ) Installing pass"
    sudo pacman -Sv xclip gnupg openssh pass pinentry gnome-keyring
    curl https://keybase.io/jaromil/pgp_keys.asc | gpg --import
    curl https://pujol.io/keys/0xc5469996f0df68ec.asc | gpg --import
    pacaur -S tomb pass-tomb
    gpg --delete-keys Denis Pujol
    mkdir -vp ~/.pass
    echo "Done"
}

append_files() {
    echo "Appending files..."
    sudo sed -i 's/Adwaita/LyraR-cursors/g' /usr/share/icons/default/index.theme
    sudo sed -i 's/Current=/Current=sddm-slice/g' /usr/lib/sddm/sddm.conf.d/default.conf
    sudo sed -i 's/CursorTheme=/CursorTheme=LyraR-cursors/g' /usr/lib/sddm/sddm.conf.d/default.conf
}

make_dirs
install_aurhelper
install_zshell
copy_dirs
install_programs
install_visuals
install_emacs
install_xmonad
install_pass
append_files

tee -a ~/install.txt <<EOF
Installation done
run afterwards
zsh
Append those files

Install zranger
EOF
