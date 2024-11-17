alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias vi='nvim'
alias z='vi ~/.zshrc'
alias ls="eza -a"
alias ll="eza -al"
alias lg="lazygit"
alias lgc="lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME"
alias gs="git status -s"
alias gb="lazygit branch"
alias glg="git log --graph --pretty=tformat:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --decorate=full"
alias reload-zshrc="source ~/.zshrc"
