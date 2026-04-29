# export GBM_BACKEND=nvidia-drm
# export LIBVA_DRIVER_NAME=nvidia
# export VDPAU_DRIVER=nvidia
# export __GLX_VENDOR_LIBRARY_NAME=nvidia
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/scripts:$PATH"

autoload -Uz compinit && compinit

# set up prompt
NEWLINE=$'\n'
PROMPT="${NEWLINE}%K{#88C0D0}%F{#2E3440} λ %K{#2E3440}%F{#E5E9F0} $(date +%_I:%M%P) %K{#3b3252}%F{#ECEFF4} %n %K{#4c566a}%F{#ECEFF4} %~ %f%k ❯ "
# PROMPT="${NEWLINE}%K{#3c3836}%F{#d5c4a1} %n %K{#504945} %~ %f%k ❯ " # warmer theme

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit cdreplay -q

HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_ignore_dups hist_find_no_dups globdots correct

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete💿*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

function command_not_found_handler {
    local purple='e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]] ; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%sn' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

aurhelper="$(command -v yay || command -v paru)"

function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null ; then
            arch+=("${pkg}")
        else 
            aur+=("${pkg}")
        fi
    done

    if [[ ${#arch[@]} -gt 0 ]]; then
        sudo pacman -S "${arch[@]}"
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        ${aurhelper} -S "${aur[@]}"
    fi
}

# alias man="batman"
alias grep="grep --color=auto"
alias cat='bat'
alias shell="exec $SHELL -l"
alias mv="mv -i"
alias rm="rm -Iv"
alias tldr="tldr --list | fzf --preview 'tldr {} --color always' | xargs tldr"
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias tree='eza --icons=auto --tree'
alias ff='fastfetch --config hypr'
alias fetch='fastfetch --config groups'
alias fzf='fzf -m --preview="bat --color=always --style=numbers --line-range=:500 {}"'
alias ..='cd ..'
alias ...='cd ../..'
alias ~='cd ~'
alias h='cd ~'
alias vscode='code-insiders && exit'
alias man='batman'

bindkey -s '^F' 'fzf\n'

# pnpm
export PNPM_HOME="/home/triceratops/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

HISTFILE=~/.zsh_history
# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
# fastfetch

export PATH=$PATH:/home/triceratops/.spicetify

# Added by blaxel installer - completions directory
fpath=(/home/triceratops/.zsh/completions $fpath)
autoload -Uz compinit && compinit
