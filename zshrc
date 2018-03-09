#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# User configuration
#export TERM=xterm
export LESS="-F -g -X -i -M -R -S -w -z-4"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export GOROOT="/usr/local/go"
export GOPATH="/Users/dppascual/Repositories/golang"
export GOBIN="$GOPATH/bin"
export PATH="/usr/local/opt/python@2/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$GOROOT/bin:$GOPATH/bin"

# Vi mode bash
bindkey -v
bindkey '\C-a' beginning-of-line
bindkey '\C-e' end-of-line
bindkey '\C-k' kill-line
bindkey '\C-u' kill-whole-line
bindkey '\C-l' clear-screen
bindkey '\C-r' history-incremental-search-backward
bindkey '\C-p' history-search-backward
bindkey '\C-n' history-search-forward

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#alias vi="TERM=screen-256color vim"
alias vi=/usr/local/bin/nvim
alias vim=/usr/local/bin/nvim

# By default gruvbox will act as usual 256-color theme, but colors wouldn't 
# be that vivid due to limitations of 256-palette. Running a script to overload 
# system default 256-color palette with precise gruvbox colors.
/Users/dppascual/.vim/plugged/gruvbox/gruvbox_256palette_osx.sh
