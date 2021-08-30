#!/usr/bin/env zsh
#
# ZISH 
# Powerful ZSH shell preconfigured to work out of the box.
#
# michael mattsson (mattsson@ymail.com)
# https://github.com/mdmattsson
#
# to install, simply copy the commandline below. run this installer
# zsh <(curl -s https://raw.githubusercontent.com/mdmattsson/zish/main/install.sh)

REPO_INSTALLER=https://raw.githubusercontent.com/mdmattsson/zish/main/install.sh
REPO_SOURCE=https://github.com/mdmattsson/zish.git

export PATH="/bin:/usr/bin:/usr/local/bin:/opt/homebrew/bin:$PATH"
export ZDOTDIR=$HOME/.config/zish
ZISH_PLUGIN_DIR=$ZDOTDIR/plugins
FORCE_ZSH_INSTALL=false

windows() { [[ -n "$WINDIR" ]]; }
OPSYS="UNKNOWN"
OPSYS_SILICON=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OPSYS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
        OPSYS="MACOS"
        OPSYS_SILICON="INTEL"
        [[ `uname -p` == 'arm' ]] && OPSYS_SILICON="ARM"
elif [[ "$OSTYPE" == "cygwin" ]]; then
        OPSYS="WINDOWS-CYGWIN"
elif [[ "$OSTYPE" == "msys" ]]; then
        OPSYS="WINDOWS-MSYS"
elif [[ "$OSTYPE" == "win32" ]]; then
        OPSYS="WINDOWS"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        OPSYS="FREEBSD"
else
        OPSYS="UNKNOWN"
fi

autoload -U colors && colors
#source (curl -s https://raw.githubusercontent.com/mdmattsson/zish/main/scripts/revolver)
function doprint()
{
   printf $1
}


function show_header()
{
        clear
        doprint "$fg_bold[red]ZISH $fg[default]\n"
        doprint "$fg[cyan]Michael's ZSH Environment Setup Script.$fg[default]\n"
        doprint "This script will setup the zsh environment in the user's \$HOME/.config/zish\n"
        doprint "folder to keep things clean.\n"
        doprint "\n"
        doprint "running under $fg[yellow]${OPSYS}$fg[default]\n"
        doprint "\n"
}

#if zsh installed?
# if [[ $OPSYS=="WINDOWS-MSYS" ]]; then
#   pushd /c/Program\ Files/Git/usr/bin
#   if [[ ! -f zsh.exe ]]; then
#     [[ ! -d $(pwd)/tmp ]] && mkdir -p $(pwd)/tmp
#     pushd $(pwd)/tmp
#     curl -s -L https://github.com/facebook/zstd/releases/download/v1.4.4/zstd-v1.4.4-win64.zip --output zstd-v1.4.4-win64.zip
#     unzip -a zstd-v1.4.4-win64.zip
    
#     echo "downloading latest Zsh files..."
#     curl -s -L https://mirror.msys2.org/msys/x86_64/zsh-5.8-5-x86_64.pkg.tar.zst --output zsh-5.8-5-x86_64.pkg.tar.zst
#     #tar -I zstd -xvf zsh-5.8-5-x86_64.pkg.tar.zst
#     ./zstd.exe -d zsh-5.8-5-x86_64.pkg.tar.zst
#     [[ ! -d zsh ]] && mkdir -p zsh
#     tar -xvf zsh-5.8-5-x86_64.pkg.tar -C zsh
#     cp -p -R zsh/* /c/Program\ Files/Git/
#     popd
#     rm -rf $(pwd)/tmp
#     exit
#   fi
#   popd 
# fi



#clean previous
function clean_zdotdir()
{
        doprint  "$fg[cyan]INSTALLER:$fg[default] removing old shell files..."
        [[ ! -d $HOME/.config ]] && mkdir .config &> /dev/null
        [[ -d $ZDOTDIR ]] && rm -rf $ZDOTDIR &> /dev/null
        [[ ! -d $ZDOTDIR ]] && mkdir -p $ZDOTDIR  &> /dev/null
        #rename/backup existing zshrc
        [[ -L $HOME/.zshrc ]] && rm $HOME/.zshrc &> /dev/null
        [[ -f $HOME/.zshrc && ! -L $HOME/.zshrc  ]] && mv $HOME/.zshrc ~/.zshrc_old && rm -f $HOME/.zshrc
        #remove old history file
        [[ -L $HOME/.zsh_history ]] && rm $HOME/.zsh_history &> /dev/null
        [[ -f $HOME/.zsh_history && ! -L $HOME/.zsh_history  ]] && mv $HOME/.zsh_history ~/.zsh_history_old && rm -f $HOME/.zsh_history

        doprint "$fg[green]Done.$fg[default]\n"
}

function install_zish()
{
        doprint  "$fg[cyan]INSTALLER:$fg[default] getting zish files..."
        pushd $HOME/.config
        git clone --recurse-submodules $REPO_SOURCE &> /dev/null
        popd
        if [[ -d $ZDOTDIR ]]; then
                doprint "$fg[green]Done.$fg[default]\n"
                #source $ZDOTDIR/.zshrc
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

function setup_zdotdir_stuff()
{
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] removing old zprofile..."
        [[ -L $HOME/.zshenv ]] && rm $HOME/.zshenv &> /dev/null
        [[ -f $HOME/.zshenv ]] && mv $HOME/.zshenv $HOME/.zshenv_old &> /dev/null

        [[ -L $HOME/.zprofile ]] && rm $HOME/.zprofile &> /dev/null
        [[ -f $HOME/.zprofile ]] && mv $HOME/.zprofile $HOME/.zprofile_old &> /dev/null
        doprint "$fg[green]Done.$fg[default]\n"

        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] creating new zprofile link..."
        if windows; then
                cp -p $ZDOTDIR/.zshenv $HOME/.zshenv &> /dev/null
                #cp -p $ZDOTDIR/.zprofile $HOME/.zprofile &> /dev/null
        else
                ln -s $ZDOTDIR/.zshenv $HOME/.zshenv &> /dev/null
                #ln -s $ZDOTDIR/.zprofile $HOME/.zprofile &> /dev/null
        fi
        doprint "$fg[green]Done.$fg[default]\n"
}

function setup_cache()
{
        [[ ! -d $HOME/.cache ]] && mkdir -p $HOME/.cache &> /dev/null
        [[ ! -f $HOME/.cache/.zsh_history ]] && touch $HOME/.cache/.zsh_history &> /dev/null
}

#
# PLUGINS
#

function get_plugin()
{
        local PLUGIN_NAME=$1
        local PLUGIN_REPO=$2
        local PLUGIN_URL=$3
        local PLUGIN_DIR=$ZISH_PLUGIN_DIR/$PLUGIN_NAME
        mkdir -p $PLUGIN_DIR
        pushd $PLUGIN_DIR
        git init &> /dev/null
        git config core.sparsecheckout true &> /dev/null
        echo $PLUGIN_URL >> .git/info/sparse-checkout
        git remote add -f origin $PLUGIN_REPO &> /dev/null
        git pull origin master &> /dev/null
        popd 
}

function install_plugins()
{
        [[ ! -d $ZISH_PLUGIN_DIR ]] && mkdir -p $ZISH_PLUGIN_DIR &> /dev/null

        echo "#" >> $ZDOTDIR/.zshrc
        echo "# ZSH PLUGINS" >> $ZDOTDIR/.zshrc
}


#MACOS Specific
function install_macos_apps()
{
if [[ $OPSYS=="MACOS" ]]; then
  #/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  defaults write NSGlobalDomain KeyRepeat -int 0
  alias thebrew='arch -x86_64 /usr/local/bin/brew'
  [[ $OPSYS_SILICON=="ARM" ]] && alias thebrew='arch -arm64e /opt/homebrew/bin/brew'  
  thebrew install cask &> /dev/null
  thebrew install --cask wget &> /dev/null
  thebrew install --cask tree &> /dev/null
  thebrew install --cask broot &> /dev/null
  thebrew install --cask lf &> /dev/null
  thebrew install --cask htop &> /dev/null
  thebrew install --cask archey &> /dev/null
  thebrew install --cask wifi-password &> /dev/null
  thebrew install --cask nvm &> /dev/null
fi
}

#install fonts
function install_fonts()
{
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing iterm fonts..."
        git clone https://github.com/powerline/fonts.git $ZDOTDIR/fonts &> /dev/null
        if [[ -f $ZDOTDIR}fonts/install.sh ]]; then
                pushd $ZDOTDIR/fonts
                ./install.sh &> /dev/null
                popd
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

# Import all color schemes
function clean_previnstall_color_schemes()
{
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing iterm color schemes..."
        git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git $ZDOTDIR/color-schemes &> /dev/null

        if [[ -f $ZDOTDIR/color-schemes/tools/import-scheme.sh ]]; then
                #[[ ! -d $ZDOTDIR/color-schemes ]] && mkdir -p $ZDOTDIR/color-schemes
                #cp -R zsh/color-schemes/* $ZDOTDIR/color-schemes/
                $ZDOTDIR/color-schemes/tools/import-scheme.sh $ZDOTDIR/color-schemes/schemes/* &> /dev/null
                # Import all color schemes (verbose mode)
                #scripts/import-scheme.sh -v $ZDOTDIR/color-schemes/*
                # Import specific color schemes (quotations are needed for schemes with spaces in name)
                #scripts/import-scheme.sh '$ZDOTDIR/color-schemes/SpaceGray Eighties.itermcolors' # by file path
                #scripts/import-scheme.sh 'SpaceGray Eighties'                     # by scheme name
                #scripts/import-scheme.sh Molokai 'SpaceGray Eighties'             # import multiple
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

function it2prof()
{
        # Change iterm2 profile. Usage it2prof ProfileName (case sensitive)
        echo "\033]50;SetProfile=$1\a"
}


function add_plugin_autojump()
        {
        #get_plugin "autojump" "https://github.com/ohmyzsh/ohmyzsh.git" "master/plugins/autojump"
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing plugin autojump..."
        git clone --depth=1 https://github.com/wting/autojump.git $ZISH_PLUGIN_DIR}/autojump &> /dev/null
        if [[ -f $ZISH_PLUGIN_DIR}/autojump/bin/autojump.zsh ]]; then
                sed -i "" "s|~/.autojump/|"$ZISH_PLUGIN_DIR"/autojump|" $ZISH_PLUGIN_DIR/autojump/bin/autojump.zsh
                sed -i "" "s|~/.autojump/|~/.cache/autojump/|" $ZISH_PLUGIN_DIR/autojump/bin/autojump.zsh
                echo "# Load autojump." >> $ZDOTDIR/.zshrc
                echo "source $ZISH_PLUGIN_DIR/autojump/bin/autojump.zsh" >> $ZDOTDIR/.zshrc
                USER_PATH=$USER_PATH:$ZISH_PLUGIN_DIR/autojump/bin
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi

}


function add_plugin_highlighting()
{
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing plugin zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZISH_PLUGIN_DIR/zsh-syntax-highlighting &> /dev/null
        if [[ -f $ZISH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
                echo "# Load zsh-syntax-highlighting." >> $ZDOTDIR/.zshrc
                echo "source $ZISH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $ZDOTDIR/.zshrc
                USER_PATH=$USER_PATH:$ZISH_PLUGIN_DIR/zsh-syntax-highlighting
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

function add_plugin_autosuggest()
{
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing plugin zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZISH_PLUGIN_DIR/zsh-autosuggestions &> /dev/null
        if [[ -f $ZISH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
                echo "# Load zsh-autosuggestions." >> $ZDOTDIR/.zshrc
                echo "source $ZISH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $ZDOTDIR/.zshrc
                USER_PATH=$USER_PATH:$ZISH_PLUGIN_DIR/zsh-autosuggestions
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

function add_plugin_sudo()
{
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing plugin sudo.plugin..."
        local SUDO_URL=https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
        mkdir -p $ZISH_PLUGIN_DIR/sudo && pushd $ZISH_PLUGIN_DIR/sudo && curl -O $SUDO_URL &> /dev/null && popd
        if [[ -f $ZISH_PLUGIN_DIR/sudo/sudo.plugin.zsh ]]; then
                echo "# Load sudo" >> $ZDOTDIR/.zshrc
                echo "source $ZISH_PLUGIN_DIR}/sudo/sudo.plugin.zsh" >> $ZDOTDIR/.zshrc
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

function add_plugin_powerlevel10k()
{
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing plugin powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZISH_PLUGIN_DIR/powerlevel10k &> /dev/null
        if [[ -f $ZISH_PLUGIN_DIR/powerlevel10k/powerlevel10k.zsh-theme ]]; then
                echo "# Load powerlevel10k." >> $ZDOTDIR/.zshrc
                #echo "source $ZISH_PLUGIN_DIR/powerlevel10k/powerlevel10k.zsh-theme" >> $ZDOTDIR/.zshrc
                echo "# To customize prompt, run 'p10k configure' or edit ~/.config/zish/.p10k.zsh." >> $ZDOTDIR/.zshrc
                #echo "[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh" >> $ZDOTDIR/.zshrc
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

function add_userpath_to_zshenv()
{
        echo "export PATH=$PATH:$USER_PATH" >> $ZDOTDIR/.zshenv
}

DISABLE_AUTO_TITLE="true"
function set_terminal_title() {
  echo -en "\e]2;$@\a"
}

set_terminal_title "ZISH Installer"
show_header
#maintenance stuff
clean_zdotdir
install_zish
setup_zdotdir_stuff
setup_cache
#apps & scripts 
install_plugins
install_macos_apps
install_fonts
clean_previnstall_color_schemes
#it2prof "Default"
add_plugin_autojump
add_plugin_highlighting
add_plugin_autosuggest
add_plugin_sudo
add_plugin_powerlevel10k
#final zsh settings...
add_userpath_to_zshenv

doprint  "\n$fg_bold[green]ZISH$fg[green] installation completed.$fg[default].\n"
doprint  "$fg[yellow]please quit and restart iterm$fg[default].\n"
 