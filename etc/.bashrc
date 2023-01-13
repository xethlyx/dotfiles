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
