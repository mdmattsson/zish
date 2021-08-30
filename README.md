# ZISH
Michael Mattsson  

Powerful ZSH shell preconfigured to work out of the box.

- [iTerm2 Color Schemes](https://github.com/mbadolato/iTerm2-Color-Schemes.git) 
- [Powerline fonts](https://github.com/powerline/fonts.git)
- [Visual Command Prompt](https://github.com/romkatv/powerlevel10k.git)
- [Fast Filesystem Navigator](https://github.com/wting/autojump.git) A fast way to navigate your filesystem. It works by maintaining a database of the directories you use the most from the command line.
- [Syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) Provides syntax highlighting for the shell zsh.
- [Auto Suggestions](https://github.com/zsh-users/zsh-autosuggestions) It suggests commands as you type based on history and completions.
- [Sudo](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/sudo/sudo.plugin.zsh) Easily prefix your current or previous commands with sudo by pressing esc twice.
  
  
### Notes: 
- Files will reside in the users ```$HOME/.config/zish``` folder.  This will help keep the $HOME directory from becomming cluttered.   
- Aliases are split into multiple files in the zsh/aliases folder.  Filenames are only used to try and organize things.   Any files added to this folder will be read and aliases found within will be added automatically added.
- Plugins can be found in the ```zsh/plugins``` sub-folder.  I currently keep a copy of powerlevel10k in here with a custom configuration for convenience.  To update the prompt, type ```p10k configure``` at the command line and answer the questions 
- I make use of .zshenv.  A sumbolic link is created in the user's $HOME directory and points to $HOME/.config/zish/zsh/.zshenv

  
## Install:
clone repo and run install.sh   
or   
```zsh <(curl -s https://raw.githubusercontent.com/mdmattsson/zish/main/install.sh)```    


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



## .zshenv
[Read every time]

This file is always sourced, so it should set environment variables which need to be updated frequently. PATH (or its associated counterpart path) is a good example because you probably don't want to restart your whole session to make it update. By setting it in that file, reopening a terminal emulator will start a new Zsh instance with the PATH value updated.

But be aware that this file is read even when Zsh is launched to run a single command (with the -c option), even by another tool like make. You should be very careful to not modify the default behavior of standard commands because it may break some tools (by setting aliases for example).

## .zprofile
[Read at login]

I personally treat that file like .zshenv but for commands and variables which should be set once or which don't need to be updated frequently:

environment variables to configure tools (flags for compilation, data folder location, etc.)
configuration which execute commands ```(like SCONSFLAGS="--jobs=$(( $(nproc) - 1 ))")``` as it may take some time to execute.
If you modify this file, you can apply the configuration updates by running a login shell:

```exec zsh --login```

## .zshrc
[Read when interactive]

I put here everything needed only for interactive usage:

prompt,  
command completion,  
command correction,  
command suggestion,  
command highlighting,  
output coloring,  
aliases,  
key bindings,  
commands history management,  
other miscellaneous interactive tools (auto_cd, manydots-magic)...  

## .zlogin
[Read at login]

This file is like ```.zprofile```, but is read after ```.zshrc```. You can consider the shell to be fully set up at ```.zlogin``` execution time

So, I use it to launch external commands which do not modify shell behaviors (e.g. a login manager).  

## .zlogout
[Read at logout][Within login shell]  

Here, you can clear your terminal or any other resource which was setup at login.  
  

For an excellent, in-depth explanation of what these files do, see What should/shouldn't go in ```.zshenv```, ```.zshrc```, ```.zlogin```, ```.zprofile```, on Unix/Linux.


## Some Caveats
Apple does things a little differently so it's best to be aware of it. Specifically, Terminal initially opens both a login and interactive shell even though you don't authenticate (enter login credentials). However, any subsequent shells that are opened are only interactive.

You can test this out by putting an alias or setting a variable in .zprofile, then opening Terminal and seeing if that variable/alias exists. Then open another shell (type zsh); that variable won't be accessible anymore.

SSH sessions are login and interactive so they'll behave just like your initial Terminal session and read both .zprofile and .zshrc

Order of Operations
This is the order in which these files get read. Keep in mind that it reads first from the system-wide file (i.e. /etc/zshenv) then from the file in your home directory (`~/.zshenv) as it goes through the order.

```.zshenv``` → .```zprofile``` → ```.zshrc``` → ```.zlogin``` → ```.zlogout```


## Best Practices
if it is needed by a command run non-interactively: ```.zshenv```  
if it should be updated on each new shell: ```.zshenv```  
if it runs a command which may take some time to complete: ```.zprofile```  
if it is related to interactive usage: ```.zshrc```  
if it is a command to be run when the shell is fully setup: ```.zlogin```  
if it releases a resource acquired at login: ```.zlogout```  

