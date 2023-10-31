############
###
### ENV VARS
###
############
set -gx GOROOT /usr/local/go
set -gx GOPATH "$HOME/go"
set -gx GOBIN "$GOPATH/bin"
set -gx GOPRIVATE "*.bbva.com,*.igrupobbva"
set -gx GOPROXY "https://proxy.golang.org,direct"
set -gx GO111MODULE on
set -gx GOMODCACHE "$GOPATH/pkg/mod"
set -gxp PATH /opt/homebrew/bin "$HOME/.local/share/nvim/mason/bin" "$GOROOT/bin" "$GOPATH/bin" "$HOME/.cargo/bin"
set -gx CLICOLOR 1
set -gx EDITOR nvim
set -gx TERM xterm-256color
set -gx LESS -R
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

##################
###
### Zk notes
###
##################
set -gx ZK_NOTEBOOK_DIR "$HOME/projects/personal/notes"

##################
###
### Zoxide Options
###
##################
zoxide init fish | source

###############
###
### FZF Options
###
###############
set FD_OPTIONS "--follow --exclude .git"
set -gx FZF_DEFAULT_COMMAND "git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"
set -gx FZF_DEFAULT_OPTS "--no-mouse --height 40% --reverse --multi --inline-info --no-separator --border
        --preview '[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || bat --style=numbers --color=always {} 2> /dev/null | head -300'
        --preview-window 'right:hidden:wrap'
        --bind 'f1:execute(bat --style=numbers --color=always {})'
        --bind 'ctrl-p:toggle-preview'
        --bind 'alt-k:preview-up'
        --bind 'alt-j:preview-down'
        --bind 'ctrl-u:preview-half-page-up'
        --bind 'ctrl-d:preview-half-page-down'
        --bind 'alt-a:select-all+accept'
        --bind 'ctrl-y:execute-silent(echo {+} | pbcopy)+abort'
        --color=gutter:-1"
set -gx FZF_CTRL_R_OPTS "--preview 'bat --color=always {}'
            --preview-window down:40%:hidden:wrap
            --bind 'ctrl-p:toggle-preview'"
set -gx FZF_CTRL_T_COMMAND "fd $FD_OPTIONS"
# export FZF_CTRL_T_COMMAND='command cat <(fre --sorted) <(fd $FD_OPTIONS)'
set -gx FZF_CTRL_T_OPTS "--tiebreak=index"
set -gx FZF_ALT_C_COMMAND "fd --type d $FD_OPTIONS"

###############
###
### BAT Options
###
###############
set -gx BAT_PAGER "less -R"
# export BAT_THEME="ansi"

####################
###
### STARSHIP Options
###
####################
starship init fish | source

###########
###
### Aliases
###
###########
alias nv=nvim
alias vim=nvim
alias cat=bat
alias ofv='sudo openfortivpn -c /opt/vpnaas/config'
alias pf='fzf --preview='\''/usr/local/bin/bat --color=always --style=numbers {}'\'' --bind shift-up:preview-page-up,shift-down:preview-page-down'

abbr -a --position command ls exa --header --long --group
abbr -a --position command tree exa --tree --level=2


function gd
    nvim -c "DiffviewOpen $argv"
end
