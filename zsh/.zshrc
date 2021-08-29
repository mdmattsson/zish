# ZISH
# Powerful ZSH shell preconfigured to work out of the box.
#
# michael mattsson (mattsson@ymail.com)
# https://github.com/mdmattsson
#


# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/${USER_ZPROFILE_SUBDIR}/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable colors and change prompt:
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "


#zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export TERM="xterm-256color" CLICOLOR=1
export LESS_TERMCAP_mb=$(print -P "%F{cyan}") \
    LESS_TERMCAP_md=$(print -P "%B%F{red}") \
    LESS_TERMCAP_me=$(print -P "%f%b") \
    LESS_TERMCAP_so=$(print -P "%K{magenta}") \
    LESS_TERMCAP_se=$(print -P "%K{black}") \
    LESS_TERMCAP_us=$(print -P "%U%F{green}") \
    LESS_TERMCAP_ue=$(print -P "%f%u")

    
#
# History in cache directory:
export HISTFILESIZE=1000000000
export HISTSIZE=1000000000
export SAVEHIST=1000000000
export HISTTIMEFORMAT="[%F %T] "
export HISTFILE=~/.cache/.zsh_history
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
# following should be turned off, if sharing history via setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt appendhistory

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload $ZDOTDIR/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# LF
# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


# oh-my-zsh seems to enable this by default, not desired for 
# workflow of controlling terminal title.
#echo -n -e "\033]0;ZISH\007"
DISABLE_AUTO_TITLE="true"
function set_terminal_title() {
  echo -en "\e]2;$@\a"
}

set_terminal_title "ZISH"

function config_prompt() {
  p10k configure
}

# Load aliases and shortcuts if existent.
[[ ! -f $$ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
[[ -f $ZDOTDIRh/shortcutrc ]] && source $/shortcutrc
for f in $ZDOTDIR/aliases/*; do source $f; done


## this loads NVM
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh

# To customize prompt, run `p10k configure` or edit ~/.config/${USER_ZPROFILE_SUBDIR}/zsh/.p10k.zsh.
[[ ! -f $$ZDOTDIR/.p10k.zsh ]] || source $$ZDOTDIR/.p10k.zsh

