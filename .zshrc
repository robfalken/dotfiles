export PATH="/opt/homebrew/bin:${PATH}"
export XDG_CONFIG_HOME="$HOME/.config"
export BREW_PREFIX="$(brew --prefix)"

source $XDG_CONFIG_HOME/zsh/alias.sh
source $XDG_CONFIG_HOME/zsh/eval.sh
source $XDG_CONFIG_HOME/zsh/source.sh

[ -s "$XDG_CONFIG_HOME/nvm/nvm.sh" ] && \. "$XDG_CONFIG_HOME/nvm/nvm.sh"  # This loads nvm
[ -s "$XDG_CONFIG_HOME/nvm/bash_completion" ] && \. "$XDG_CONFIG_HOME/nvm/bash_completion"  # This loads nvm bash_completion
