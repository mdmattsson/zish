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

USER_PATH=$PATH
ZDOTDIR=$HOME/.config/zish/zsh
USER_SHELL_DIR=$HOME/.config/zish
USER_ZSH_DIR=$USER_SHELL_DIR/zsh
USER_PLUGIN_DIR=$USER_ZSH_DIR/plugins

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
#source (curl -s https://raw.githubusercontent.com/mdmattsson/zish/main/zsh/scripts/revolver)
function doprint()
{
   printf $1
}


function show_header()
{
        clear
        doprint "$fg_bold[red]ZISH $fg[default]\n"
        doprint "$fg[cyan]Michael's ZSH Environment Setup Script.$fg[default]\n"
        doprint "This script will setup the zsh environment in the user's \$HOME/.config/zish/zsh\n"
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
        [[ ! -d ${HOME}/.config ]] && mkdir .config &> /dev/null
        [[ -d ${USER_SHELL_DIR} ]] && rm -rf ${USER_SHELL_DIR} &> /dev/null
        [[ ! -d ${USER_SHELL_DIR} ]] && mkdir -p ${USER_SHELL_DIR}  &> /dev/null
        #rename/backup existing zshrc
        [[ -L ${HOME}/.zshrc ]] && rm ${HOME}/.zshrc &> /dev/null
        [[ -f ${HOME}/.zshrc && ! -L ${HOME}/.zshrc  ]] && mv ${HOME}/.zshrc ~/.zshrc_old && rm -f ${HOME}/.zshrc
        #if this is coming from a cloned repo, install from clone
        if [[ -d ${PWD}/zsh && ${PWD} != ${HOME}/.config ]]; then
                REPO_SOURCE="${PWD}/zsh"
                cp -R ${REPO_SOURCE}/* ${USER_SHELL_DIR} &> /dev/null
        else
                [[ -d ${USER_SHELL_DIR} ]] && mkdir -p ${USER_SHELL_DIR} &> /dev/null
                pushd $HOME/.config
                git clone --recurse-submodules ${REPO_SOURCE} &> /dev/null
                #source $ZDOTDIR/.zshrc
                popd
        fi
        doprint "$fg[green]Done.$fg[default]\n"
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
                cp -p $ZDOTDIR/.zprofile $HOME/.zprofile &> /dev/null
        else
                ln -s $ZDOTDIR/.zshenv $HOME/.zshenv &> /dev/null
                ln -s $ZDOTDIR/.zprofile $HOME/.zprofile &> /dev/null
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
        local PLUGIN_DIR=${USER_PLUGIN_DIR}/${PLUGIN_NAME}
        mkdir -p ${PLUGIN_DIR}
        pushd ${PLUGIN_DIR}
        git init &> /dev/null
        git config core.sparsecheckout true &> /dev/null
        echo $PLUGIN_URL >> .git/info/sparse-checkout
        git remote add -f origin $PLUGIN_REPO &> /dev/null
        git pull origin master &> /dev/null
        popd 
}

function install_plugins()
{
        [[ ! -d ${USER_PLUGIN_DIR} ]] && mkdir -p ${USER_PLUGIN_DIR} &> /dev/null

        echo "#" >> ${ZDOTDIR}/.zshrc
        echo "# ZSH PLUGINS" >> ${ZDOTDIR}/.zshrc
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
        git clone https://github.com/powerline/fonts.git ${ZDOTDIR}/fonts &> /dev/null
        pushd ${ZDOTDIR}/fonts
        ./install.sh &> /dev/null
        popd
        doprint "$fg[green]Done.$fg[default]\n"
}

# Import all color schemes
function clean_previnstall_color_schemes()
{
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing iterm color schemes..."
        git clone https://github.com/mbadolato/iTerm2-Color-Schemes.git ${ZDOTDIR}/color-schemes &> /dev/null
        #[[ ! -d ${ZDOTDIR}/color-schemes ]] && mkdir -p ${ZDOTDIR}/color-schemes
        #cp -R zsh/color-schemes/* ${ZDOTDIR}/color-schemes/
        ${ZDOTDIR}/color-schemes/tools/import-scheme.sh ${ZDOTDIR}/color-schemes/schemes/* &> /dev/null
        # Import all color schemes (verbose mode)
        #scripts/import-scheme.sh -v ${ZDOTDIR}/color-schemes/*
        # Import specific color schemes (quotations are needed for schemes with spaces in name)
        #scripts/import-scheme.sh '${ZDOTDIR}/color-schemes/SpaceGray Eighties.itermcolors' # by file path
        #scripts/import-scheme.sh 'SpaceGray Eighties'                     # by scheme name
        #scripts/import-scheme.sh Molokai 'SpaceGray Eighties'             # import multiple
        doprint "$fg[green]Done.$fg[default]\n"
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
        echo "#" >> ${ZDOTDIR}/.zshrc
        git clone --depth=1 https://github.com/wting/autojump.git ${USER_PLUGIN_DIR}/autojump &> /dev/null
        sed -i "" "s|~/.autojump/|"${USER_PLUGIN_DIR}"/autojump|" ${USER_PLUGIN_DIR}/autojump/bin/autojump.zsh
        sed -i "" "s|~/.autojump/|~/.cache/autojump/|" ${USER_PLUGIN_DIR}/autojump/bin/autojump.zsh
        echo "# Load autojump." >> ${ZDOTDIR}/.zshrc
        echo "source ${USER_PLUGIN_DIR}/autojump/bin/autojump.zsh" >> ${ZDOTDIR}/.zshrc
        USER_PATH=$USER_PATH:${USER_PLUGIN_DIR}/autojump/bin
        doprint "$fg[green]Done.$fg[default]\n"
}


function add_plugin_highlighting()
{
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing plugin zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${USER_PLUGIN_DIR}/zsh-syntax-highlighting &> /dev/null
        echo "# Load zsh-syntax-highlighting." >> ${ZDOTDIR}/.zshrc
        echo "source ${USER_PLUGIN_DIR}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR}/.zshrc
        USER_PATH=$USER_PATH:${USER_PLUGIN_DIR}/zsh-syntax-highlighting
        doprint "$fg[green]Done.$fg[default]\n"
}

function add_plugin_autosuggest()
{
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing plugin zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git ${USER_PLUGIN_DIR}/zsh-autosuggestions &> /dev/null
        echo "# Load zsh-autosuggestions." >> ${ZDOTDIR}/.zshrc
        echo "source ${USER_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${ZDOTDIR}/.zshrc
        USER_PATH=$USER_PATH:${USER_PLUGIN_DIR}/zsh-autosuggestions
        doprint "$fg[green]Done.$fg[default]\n"
}

function add_plugin_sudo()
{
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing plugin sudo.plugin..."
        local SUDO_URL=https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh
        mkdir ${USER_PLUGIN_DIR}/sudo && pushd ${USER_PLUGIN_DIR}/sudo && { curl -O $SUDO_URL &> /dev/null; popd; }
        echo "# Load sudo" >> ${ZDOTDIR}/.zshrc
        echo "source ${USER_PLUGIN_DIR}/sudo/sudo.plugin.zsh" >> ${ZDOTDIR}/.zshrc
        doprint "$fg[green]Done.$fg[default]\n"
}

function add_plugin_powerlevel10k()
{
        #git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${USER_PLUGIN_DIR}/powerlevel10k
        doprint  "$fg_bold[cyan]INSTALLER:$fg[default] installing plugin powerlevel10k..."
        echo "# Load powerlevel10k." >> ${ZDOTDIR}/.zshrc
        echo "source ${USER_PLUGIN_DIR}/powerlevel10k/powerlevel10k.zsh-theme" >> ${ZDOTDIR}/.zshrc
        echo "# To customize prompt, run `p10k configure` or edit ~/.config/${USER_ZPROFILE_SUBDIR}/zsh/.p10k.zsh." >> ${ZDOTDIR}/.zshrc
        echo "[[ ! -f $$ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh" >> ${ZDOTDIR}/.zshrc
        doprint "$fg[green]Done.$fg[default]\n"
}

function add_userpath_to_zshenv()
{
        PATH=/opt/homebrew/bin:/usr/local/bin:$PATH
        echo "export PATH=$USER_PATH:$PATH" >> ${ZDOTDIR}/.zshenv
}

show_header
#maintenance stuff
clean_zdotdir
setup_zdotdir_stuff
setup_cache
#apps & scripts 
install_plugins
install_macos_apps
install_fonts
clean_previnstall_color_schemes
#it2prof "Default"
add_plugin_autojump
add_plugin_powerlevel10k
add_plugin_highlighting
add_plugin_autosuggest
add_plugin_sudo
#final zsh settings...
add_userpath_to_zshenv

doprint  "\n$fg_bold[green]ZISH$fg[green] installation completed.$fg[default].\n"
doprint  "$fg[yellow]please quit and restart iterm$fg[default].\n"
 