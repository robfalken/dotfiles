export PATH="/opt/homebrew/bin:${PATH}"
export XDG_CONFIG_HOME="~/.config"

eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

source /Users/rf/.config/zsh/aliases.sh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
