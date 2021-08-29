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
    

# history
source $ZDOTDIR/scripts/history.zsh; 


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


# bindings
source $ZDOTDIR/scripts/bindings.zsh; 

# completion
source $ZDOTDIR/scripts/completion.zsh; 

# Basic auto/tab complete:
#autoload -U compinit
#zstyle ':completion:*' menu select
#zmodload zsh/complist
#compinit
#_comp_options+=(globdots)		# Include hidden files.

# Load aliases and shortcuts if existent.
[[ ! -f $$ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh
[[ -f $ZDOTDIR/shortcutrc ]] && source $/shortcutrc
for f in $ZDOTDIR/aliases/*; do source $f; done


## this loads NVM
[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh

# To customize prompt, run `p10k configure` or edit ~/.config/${USER_ZPROFILE_SUBDIR}/zsh/.p10k.zsh.
[[ ! -f $$ZDOTDIR/.p10k.zsh ]] || source $$ZDOTDIR/.p10k.zsh

