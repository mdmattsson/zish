#!/usr/bin/env zsh
#
# ZISH 
# Powerful ZSH shell preconfigured to work out of the box.
#
# michael mattsson (mattsson@ymail.com)
# https://github.com/mdmattsson
#
# to install, simply copy the commandline below. run this installer
# zsh <(curl -s https://raw.githubusercontent.com/mdmattsson/zish/main/zish.sh)


REPO_INSTALLER=https://raw.githubusercontent.com/mdmattsson/zish/main/zish.sh
REPO_SOURCE=https://github.com/mdmattsson/zish.git
ZISH_LOG=$PWD/zish.log # &> /dev/null
[[ -f $ZISH_LOG ]] && rm $ZISH_LOG
ZDOTDIR=$HOME/.config/zish
ZISH_PLUGIN_DIR=$ZDOTDIR/plugins
FORCE_ZSH_INSTALL=false

PATH=$PATH:ZDOTDIR
USER_PATH=$ZDOTDIR

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
        doprint "$fg_bold[cyan] ____ _  ___  _ _ $fg[default]\n"
        doprint "$fg_bold[cyan]|_  /| |/ __>| | |$fg[default]\n"
        doprint "$fg_bold[cyan] / / | |\__ \|   |$fg[default]\n"
        doprint "$fg_bold[cyan]/___||_|<___/|_|_|$fg[default]\n" 
        doprint "$fg[magenta]ZSH Environment Setup Script.$fg[default]\n"
        doprint "This script will setup the zsh environment in the user's \$HOME/.config/zish\n"
        doprint "folder to keep things clean.\n"
        doprint "\n"
        doprint "running under $fg[yellow]${OPSYS} ${OPSYS_SILICON}$fg[default]\n"
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
        doprint  "$fg[cyan]ZISH:$fg[default] removing old shell files..."
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
        doprint  "$fg[cyan]ZISH:$fg[default] getting zish files..."
        pushd $HOME/.config
        git clone --recurse-submodules --single-branch -b main $REPO_SOURCE &> /dev/null
        sleep 2
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
        doprint  "$fg_bold[cyan]ZISH:$fg[default] removing old zprofile..."
        [[ -L $HOME/.zshenv ]] && rm $HOME/.zshenv &> /dev/null
        [[ -f $HOME/.zshenv ]] && mv $HOME/.zshenv $HOME/.zshenv_old &> /dev/null

        [[ -L $HOME/.zprofile ]] && rm $HOME/.zprofile &> /dev/null
        [[ -f $HOME/.zprofile ]] && mv $HOME/.zprofile $HOME/.zprofile_old &> /dev/null
        doprint "$fg[green]Done.$fg[default]\n"

        doprint  "$fg_bold[cyan]ZISH:$fg[default] creating new zprofile link..."
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
        if [[ $OPSYS == "MACOS" ]]; then
                doprint  "$fg_bold[cyan]ZISH:$fg[default] installing homebrew..."
                which -s brew &> /dev/null
                if [[ $? != 0 ]] ; then
                        # Install Homebrew
                        doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] updating homebrew..."
                        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &> /dev/null
                fi

                USER_PATH="/opt/homebrew/bin:$USER_PATH"
                defaults write NSGlobalDomain KeyRepeat -int 0
                #thebrew="arch -x86_64 /usr/local/bin/brew"
                #[[ $OPSYS_SILICON == "ARM" ]] && thebrew="arch -arm64e /opt/homebrew/bin/brew"
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] updating homebrew..."
                brew update &> /dev/null
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] installing homebrew cask..."
                brew install cask &> /dev/null
                if [ ! -d '/Applications/iTerm.app' -a ! -d "$HOME/Applications/iTerm.app" ]; then
                        doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] installing iTerm2..."
                        brew cask install iterm2 &> /dev/null
                fi
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] installing wget..."
                brew install wget &> /dev/null
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] installing tree..."
                brew install tree &> /dev/null
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] installing broot..."
                brew install broot &> /dev/null
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] installing lf..."
                brew install lf &> /dev/null
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] installing htop..."
                brew install htop &> /dev/null
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] installing archey..."
                brew install archey &> /dev/null
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] installing wifi-password..."
                brew install wifi-password &> /dev/null
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] installing nvm..."
                brew install nvm &> /dev/null
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] cleaning up..."
                brew cleanup &> /dev/null
                doprint  "\r\033[K$fg_bold[cyan]ZISH:$fg[default] installing homebrew..."
                doprint "$fg[green]Done.$fg[default]\n"
        fi
}

function install_fonts()
{
        doprint  "$fg_bold[cyan]ZISH:$fg[default] installing iterm fonts..."
        git clone --depth=1 https://github.com/powerline/fonts.git $ZDOTDIR/fonts &> /dev/null
        sleep 3
        if [[ -f $ZDOTDIR/fonts/install.sh ]]; then
                pushd $ZDOTDIR/fonts
                ./install.sh &> /dev/null
                popd
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

# Import all color schemes
function install_color_schemes()
{
        doprint  "$fg_bold[cyan]ZISH:$fg[default] installing iterm color schemes..."
        git clone --depth=1 https://github.com/mbadolato/iTerm2-Color-Schemes.git $ZDOTDIR/color-schemes &> /dev/null
        sleep 3
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

function add_plugin_antigen()
{
        doprint  "$fg_bold[cyan]ZISH:$fg[default] installing plugin antigen..."
        local ANTIGEN_URL=git.io/antigen-nightly
        mkdir -p $ZISH_PLUGIN_DIR/antigen && pushd $ZISH_PLUGIN_DIR/antigen && curl -O $ANTIGEN_URL > antigen.zsh &> /dev/null && popd
        sleep 2
        if [[ -f $ZISH_PLUGIN_DIR/antigen/antigen.zsh ]]; then
                echo "# Load antigen." >> $ZDOTDIR/.zshrc
                echo "source $ZISH_PLUGIN_DIR/antigen/antigen.zsh" >> $ZDOTDIR/.zshrc
                USER_PATH=$USER_PATH:$ZISH_PLUGIN_DIR/antigen
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

function add_plugin_autojump()
        {
        #get_plugin "autojump" "https://github.com/ohmyzsh/ohmyzsh.git" "master/plugins/autojump"
        doprint  "$fg_bold[cyan]ZISH:$fg[default] installing plugin autojump..."
        git clone --depth=1 https://github.com/wting/autojump.git $ZISH_PLUGIN_DIR/autojump &> /dev/null
        sleep 3
        if [[ -f $ZISH_PLUGIN_DIR/autojump/bin/autojump.zsh ]]; then
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
        doprint  "$fg_bold[cyan]ZISH:$fg[default] installing plugin zsh-syntax-highlighting..."
        git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git $ZISH_PLUGIN_DIR/zsh-syntax-highlighting &> /dev/null
        sleep 2
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
        doprint  "$fg_bold[cyan]ZISH:$fg[default] installing plugin zsh-autosuggestions..."
        git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git $ZISH_PLUGIN_DIR/zsh-autosuggestions &> /dev/null
        sleep 2
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
        doprint  "$fg_bold[cyan]ZISH:$fg[default] installing plugin sudo.plugin..."
        local SUDO_URL=https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
        mkdir -p $ZISH_PLUGIN_DIR/sudo && pushd $ZISH_PLUGIN_DIR/sudo && curl -O $SUDO_URL &> /dev/null && popd
        sleep 2
        if [[ -f $ZISH_PLUGIN_DIR/sudo/sudo.plugin.zsh ]]; then
                echo "# Load sudo" >> $ZDOTDIR/.zshrc
                echo "source $ZISH_PLUGIN_DIR/sudo/sudo.plugin.zsh" >> $ZDOTDIR/.zshrc
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

function add_plugin_powerlevel10k()
{
        doprint  "$fg_bold[cyan]ZISH:$fg[default] installing plugin powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZISH_PLUGIN_DIR/powerlevel10k &> /dev/null
        sleep 2
        if [[ -f $ZISH_PLUGIN_DIR/powerlevel10k/powerlevel10k.zsh-theme ]]; then
                echo "# Load powerlevel10k." >> $ZDOTDIR/.zshrc
                echo "source $ZISH_PLUGIN_DIR/powerlevel10k/powerlevel10k.zsh-theme" >> $ZDOTDIR/.zshrc
                echo "# To customize prompt, run 'p10k configure' or edit $ZDOTDIR/.p10k.zsh." >> $ZDOTDIR/.zshrc
                echo "[[ ! -f "$ZDOTDIR"/.p10k.zsh ]] || source "$ZDOTDIR"/.p10k.zsh" >> $ZDOTDIR/.zshrc
                echo "" >> $ZDOTDIR/.zshrc
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

function add_userpath_to_zshenv()
{
        echo "export PATH="$PATH":"$USER_PATH >> $ZDOTDIR/.zshenv
}

function it2prof()
{
        # Change iterm2 profile. Usage it2prof ProfileName (case sensitive)
        echo "\033]50;SetProfile=$1\a"
}

DISABLE_AUTO_TITLE="true"
function set_terminal_title() {
  echo -en "\e]2;$@\a"
}


function zish_install() {
        set_terminal_title "ZISH Installer"
        show_header
        # maintenance stuff
        clean_zdotdir
        install_zish
        setup_zdotdir_stuff
        setup_cache
        # apps & scripts 
        install_macos_apps
        install_fonts
        install_color_schemes
        install_plugins
        # it2prof "Default"
        add_plugin_antigen
        add_plugin_autojump
        add_plugin_highlighting
        add_plugin_autosuggest
        add_plugin_sudo
        add_plugin_powerlevel10k
        # final zsh settings...
        add_userpath_to_zshenv
        echo ""
        doprint "$fg[green]ZISH installation complete.$fg[default]\n"
        doprint "$fg[default]run '$fg[green]zish install$fg[default]' to install zish.$fg[default]\n"
        doprint "$fg[default]run '$fg[green]zish update$fg[default]' to update zish.$fg[default]\n"
        doprint "$fg[default]run '$fg[green]zish uninstall'$fg[default] to uninstall zish.$fg[default]\n"
        echo ""
}

function zish_uninstall() {
        doprint  "$fg_bold[red]ZISH:$fg[default] uninstalling zish..."
        rm -rf $HOME/.config/zish &> /dev/null
        [[ -L $HOME/.zshrc ]] && rm $HOME/.zshrc &> /dev/null
        if [[ ! -d $HOME/.config/zish && ! -f $HOME/.zshrc ]]; then
                doprint "$fg[green]Done.$fg[default]\n"
        else
                doprint "$fg[red]Error.$fg[default]\n"
        fi
}

function zish_update() {
        doprint  "$fg_bold[red]ZISH:$fg[default] updating zish..."
        if [[ ! -d $HOME/.config/zish ]]; then
                pushd $ZDOTDIR
                git pull &> /dev/null
                popd
                zish_reload
                echo ""
                doprint "$fg[green]ZISH update complete.$fg[default]\n"
                echo ""
        else
                doprint "$fg[yellow]Not installed.$fg[default]\n"
                doprint "$fg[yellow]ZISH is not currently installed.$fg[default]\n"
        fi

}

function zish_configure() {
        p10k configure
}
function zish_reload() {
        if test -n "$ZSH_VERSION"; then       
                if [[ $OPSYS == "MACOS" ]]; then
                        exec zsh -l
                else
                        exec zsh
                fi
        fi
}

function zish_main() {
        ZISH_COMMAND=$1
        ZISH_ARGS=$2
        if [[ $ZISH_COMMAND == "" || $ZISH_COMMAND == "install" ]]; then
                zish_install "$ZISH_ARGS"
                zish_reload
        fi
        if [[ $ZISH_COMMAND == "uninstall" ]]; then
                zish_uninstall "$ZISH_ARGS"
                zish_reload
        fi
        if [[ $ZISH_COMMAND == "update" ]]; then
                zish_update "$ZISH_ARGS"
                zish_reload
        fi
        if [[ $ZISH_COMMAND == "reload" ]]; then
                zish_reload "$ZISH_ARGS"
        fi
        if [[ $ZISH_COMMAND == "configure" ]]; then
                zish_configure "$ZISH_ARGS"
                zish_reload
        fi
}

zish_main "$@"
