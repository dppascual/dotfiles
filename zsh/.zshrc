###############
###
### ZSH Plugins
###
###############
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

############
###
### ENV VARS
###
############
export ZSH_CACHE_DIR="${HOME}/.local/share/oh-my-zsh"
export CLICOLOR=1
# export TERM=xterm-256color
export LESS="-R"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export GOROOT="/usr/local/go"
export GOPATH="${HOME}/go"
export GOBIN="${GOPATH}/bin"
export GOPRIVATE="*.bbva.com,*.igrupobbva"
export GOPROXY="https://proxy.golang.org,direct"
export GO111MODULE=on
export GOMODCACHE="$GOPATH/pkg/mod"
export PATH="${GOROOT}/bin:${GOPATH}/bin:${HOME}/.cargo/bin:${PATH}"

##################
###
### Zoxide Options
###
##################
eval "$(zoxide init zsh)"

###############
###
### FZF Options
###
###############
FD_OPTIONS="--follow --exclude .git"
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"
export FZF_DEFAULT_OPTS="--no-mouse --height 40% --reverse --multi --inline-info --no-separator --border
        --preview '[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || bat --style=numbers --color=always {} 2> /dev/null | head -300'
        --preview-window 'right:hidden:wrap'
        --bind 'f1:execute(bat --style=numbers --color=always {})'
        --bind 'ctrl-p:toggle-preview'
        --bind 'alt-k:preview-up'
        --bind 'alt-j:preview-down'
        --bind 'ctrl-u:preview-half-page-up'
        --bind 'ctrl-d:preview-half-page-down'
        --bind 'ctrl-a:select-all+accept'
        --bind 'ctrl-y:execute-silent(echo {+} | pbcopy)+abort'"
export FZF_CTRL_R_OPTS="--preview 'bat --color=always {}'
            --preview-window down:40%:hidden:wrap
            --bind 'ctrl-/:toggle-preview'"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
# export FZF_CTRL_T_COMMAND='command cat <(fre --sorted) <(fd $FD_OPTIONS)'
export FZF_CTRL_T_OPTS='--tiebreak=index'
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"

###############
###
### BAT Options
###
###############
export BAT_PAGER="less -R"
# export BAT_THEME="ansi"

####################
###
### STARSHIP Options
###
####################
function set_win_title() {
    local cmd=" ($@)"
    if [[ "$cmd" == " (starship_precmd)" || "$cmd" == " ()" ]]
    then
        cmd=""
    fi
    if [[ $PWD == $HOME ]]
    then
        if [[ $SSH_TTY ]]
        then
            echo -ne "\033]0; 🏛️ @ $HOSTNAME ~$cmd\a" < /dev/null
        else
            echo -ne "\033]0; 🏠 ~$cmd\a" < /dev/null
        fi
    else
        BASEPWD=$(basename "$PWD")
        if [[ $SSH_TTY ]]
        then
            echo -ne "\033]0; 🌩️ $BASEPWD @ $HOSTNAME $cmd\a" < /dev/null
        else
            echo -ne "\033]0; 📁 $BASEPWD $cmd\a" < /dev/null
        fi
    fi

}

precmd_functions+=(set_win_title)

eval "$(starship init zsh)"

###########
###
### Aliases
###
###########
alias vim=/usr/local/bin/nvim
alias vi=/usr/local/bin/nvim
alias cat=/usr/local/bin/bat
alias ofv='sudo openfortivpn -c /opt/vpnaas/config'
alias pf='fzf --preview='\''/usr/local/bin/bat --color=always --style=numbers {}'\'' --bind shift-up:preview-page-up,shift-down:preview-page-down'
alias ls=/usr/local/bin/exa


#####
#
# SHELL COMPLETION
#
#####

### Load local completions
fpath=(~/.zsh $fpath)

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/dppascual/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
autoload -U +X bashcompinit && bashcompinit
### MinIO autocomplete
#complete -o nospace -C /usr/local/bin/mc mc

### ZSH Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
