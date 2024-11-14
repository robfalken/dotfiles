git_email=$(git config --global user.email)
if [ "$git_email" = "" ]; then
    echo "No email address configured for git commits."
    echo "Type git commit email:"
    read email
fi

if which brew >/dev/null; then
	echo "Homebrew is already installed"
else
  export BREW_PATH="/opt/homebrew"
	echo "Installing Homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$($BREW_PATH/bin/brew shellenv)"
fi

if which brew >/dev/null; then
	echo "kitty is already installed"
else
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
fi

brew bundle

echo "Configuring git"
git config --global user.name "robfalken"
git config --global core.excludesfile ~/.gitignore
git config --global init.defaultBranch main
git config --global core.editor nvim
if [ "$email" != "" ]; then
    git config --global user.email $email
fi

defaults write "com.apple.dock" "persistent-apps" -array
defaults write -g ApplePressAndHoldEnabled -bool false
killall Dock
