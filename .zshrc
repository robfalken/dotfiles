export PATH="/opt/homebrew/bin:${PATH}"
export XDG_CONFIG_HOME="$HOME/.config"
export BREW_PREFIX="$(brew --prefix)"

source $XDG_CONFIG_HOME/zsh/alias.sh
source $XDG_CONFIG_HOME/zsh/eval.sh
source $XDG_CONFIG_HOME/zsh/source.sh

autoload -Uz compinit && compinit
