export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

COMPLETION_WAITING_DOTS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh


RPROMPT='%*'

# Useful aliases
alias c='clear'
alias cls='clear'
alias ..='cd ..'
alias ls='exa -l'
alias la='exa -la'
alias ld='exa -lD'
alias rm='rm -i'jkjkjkjkjkjkjkjkjkj
alias cp='cp -i'
alias mkdir='mkdir -pv'
alias free='free -mt'
alias ps='ps auxf'
alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e'
alias wget='wget -c'
alias histg='history | grep'
alias myip='curl ipv4.icanhazip.com'
alias grep='grep --color=auto'
alias distro='cat /etc/*-release'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'


for f in ~/.config/bash/*; do source $f; done

#misc functions
#kernel () {
#  OUTPUT=$(uname -srm)
#  echo "Current Kernel: ${OUTPUT}"
#}
