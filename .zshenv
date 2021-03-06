# Defines environment variables.

export ZDOTDIR=$HOME/.config/zish
export PATH="/usr/bin:/usr/local/bin:/bin:$ZDOTDIR"

export REPO_INSTALLER=https://raw.githubusercontent.com/mdmattsson/zish/main/zish.sh
export REPO_SOURCE=https://github.com/mdmattsson/zish.git

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# Editors
export EDITOR='nano'
export VISUAL='nano'
export PAGER='less'

export PASSWORD_STORE_DIR="$HOME"

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi
