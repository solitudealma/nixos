##
## ┬┌─┌─┐┬ ┬┌┐ ┬┌┐┌┌┬┐┌─┐
## ├┴┐├┤ └┬┘├┴┐││││ ││└─┐
## ┴ ┴└─┘ ┴ └─┘┴┘└┘─┴┘└─┘
##

bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -s '^K' 'ls^M'
bindkey -s '^o' '_smooth_fzf^M'
bindkey -M emacs '' _sudo_command_line
