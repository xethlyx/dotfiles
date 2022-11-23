# export PS1="\[\033[38;5;44m\]\u@\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;39m\]\w\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;224m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
export PS1="\[\033[38;5;117m\]\u@\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;195m\]\w\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;223m\]λ \[$(tput sgr0)\]"
export PATH=$PATH:$HOME/dotfiles/bin
# Doesn't work for some reason
# PS1='$(printf "%$((`tput cols`-1))s\r")'$PS1
