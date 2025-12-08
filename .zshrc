eval "$(brew shellenv)"
autoload -Uz compinit && compinit

export PATH="/opt/homebrew/bin:${PATH}"
export XDG_CONFIG_HOME="$HOME/.config"
export BREW_PREFIX="$(brew --prefix)"

# Source all files in ~/.config/zsh/
for file in ~/.config/zsh/**/*.zsh(-.N); do
    source "$file"
done
