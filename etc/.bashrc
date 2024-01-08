export PATH=$PATH:$HOME/dotfiles/bin
export PATH=$PATH:$HOME/bin

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTCONTROL=ignoreboth

export PS1="\[\033[38;5;117m\]\u@\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;195m\]\w\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;223m\]λ \[$(tput sgr0)\]"

# Begone vi/vim
alias vi='vim'
if command -v nvim &> /dev/null; then
    alias vim='nvim'
fi

# https://github.com/scop/bash-completion/tree/master
if [ -f /usr/local/share/bash-completion/bash_completion ]; then
    source /usr/local/share/bash-completion/bash_completion
fi

alias k=kubectl
if command -v kubectl &> /dev/null; then
    source <(kubectl completion bash)
    complete -o default -F __start_kubectl k
fi
