# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/.zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ZShell configuration

# Flex on Ubuntu users
#neofetch

# Setting $PATH variable
typeset -U PATH path
path=("$HOME/.local/bin" "$HOME/.emacs.d/bin" "$HOME/.bin"  "$path[@]")
export PATH

# ZShell completion
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES

# ZSH Histfile config
export HISTFILE=~/.config/.zsh/.zsh_history
export HISTFILESIZE=1000000
export HISTSIZE=1000000
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# Source local scripts
source ~/.config/.zsh/zplug/init.zsh

# Source MY local scripts
source ~/.config/.zsh/local_aliases.zsh
source ~/.config/.zsh/local_scripts.zsh
source ~/.config/.zsh/local_keys.zsh

# ZPlug 
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load

# To customize prompt, run `p10k configure` or edit ~/.config/.zsh/.p10k.zsh.
[[ ! -f ~/.config/.zsh/.p10k.zsh ]] || source ~/.config/.zsh/.p10k.zsh
