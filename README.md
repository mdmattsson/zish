# ZISH

Powerful ZSH shell preconfigured to work out of the box.

- [iTerm2 Color Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes.git) 
- [Powerline fonts](https://github.com/powerline/fonts.git)
- [Visual Command Prompt](https://github.com/romkatv/powerlevel10k.git)
- [Fast Filesystem Navigator](https://github.com/wting/autojump.git) A fast way to navigate your filesystem. It works by maintaining a database of the directories you use the most from the command line.
- [Syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) Provides syntax highlighting for the shell zsh.
- [Auto Suggestions](https://github.com/zsh-users/zsh-autosuggestions) It suggests commands as you type based on history and completions.
- [Sudo](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/sudo/sudo.plugin.zsh) Easily prefix your current or previous commands with sudo by pressing esc twice.
  
  
### Notes: 
- Files will reside in the users $HOME/.config/zish folder.  This will help keep the $HOME directory from becomming cluttered.   
- Aliases are split into multiple files in the zsh/aliases folder.  Filenames are only used to try and organize things.   Any files added to this folder will be read and aliases found within will be added automatically added.
- Plugins can be found in the zsh/plugins folder.  I currently keep a copy of powerlevel10k in here with a custom configuration for convenience.  To update the prompt, type ```p10k configure``` at the command line and answer the questions 
- I make use of .zshenv.  A sumbolic link is created in the user's $HOME directory and points to $HOME/.config/zish/zsh/.zshenv

  
## Install:
clone repo and run install.sh   
or   
zsh <(curl -s https://raw.githubusercontent.com/mdmattsson/zish/main/install.sh)    


## Usage:

If you've used Zsh, Bash or Fish, Zsh for Humans should feel familiar. For the most part everything
works as you would expect.

### Accepting autosuggestions

All key bindings that move the cursor can accept *command autosuggestions*. For example, moving the
cursor one word to the right will accept that word from the autosuggestion. The whole autosuggestion
can be accepted without moving the cursor with <kbd>Alt+M</kbd>/<kbd>Option+M</kbd>.

Autosuggestions in Zsh for Humans are provided by [zsh-autosuggestions](
  https://github.com/zsh-users/zsh-autosuggestions). See its homepage for more information.

### Completing commands

When completing with <kbd>Tab</kbd>, suggestions come from *completion functions*. For most
commands completion functions are provided by Zsh proper. Additional completion functions are
contributed by [zsh-completions](https://github.com/zsh-users/zsh-completions). See its homepage
for the list of commands it supports.

Ambiguous completions automatically start [fzf](https://github.com/junegunn/fzf). Accept the desired
completion with <kbd>Enter</kbd>. You can also select more than one completion with
<kbd>Ctrl+Space</kbd> or all of them with <kbd>Ctrl+A</kbd>.


