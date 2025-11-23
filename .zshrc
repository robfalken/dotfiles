# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/rf/.zsh/completions:"* ]]; then export FPATH="/Users/rf/.zsh/completions:$FPATH"; fi
export PATH="/opt/homebrew/bin:${PATH}"
export XDG_CONFIG_HOME="$HOME/.config"
export BREW_PREFIX="$(brew --prefix)"

# source $XDG_CONFIG_HOME/zsh/alias.sh
# source $XDG_CONFIG_HOME/zsh/eval.sh
# source $XDG_CONFIG_HOME/zsh/functions/opstaging.sh
# source $XDG_CONFIG_HOME/zsh/functions/tmux_session.sh
# source $XDG_CONFIG_HOME/zsh/source.sh

# Source all files in ~/.config/zsh/
for file in ~/.config/zsh/**/*.sh(-.N); do
    source "$file"
done

autoload -Uz compinit && compinit
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
. "/Users/rf/.deno/env"

# pnpm
export PNPM_HOME="/Users/rf/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
