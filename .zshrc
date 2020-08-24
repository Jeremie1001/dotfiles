export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="agnoster"

COMPLETION_WAITING_DOTS="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

RPROMPT='%*'

#Ignore upper and lowercase when TAB completion
#bind "set completion-ignore-case on"

#Extraction alias
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#ALIASES

#UI alias'
alias c='clear'
alias cls='clear'
alias cs='cd && clear'

#Navigation alias'
alias ..='cd ..'                  #Go back 1 parent directorie
alias ...='cd ../..'              #Go back 2 parent directories
alias .3='cd ../../..'            #Go back 3 parent directories
alias .4='cd ../../../..'         #Go back 4 parent directories
alias .5='cd ../../../../..'      #Go back 5 parent directories

#Listing alias'
alias ls='exa -l'                 #List
alias la='exa -la'                #List all
alias ld='exa -lD'                #List directories
alias l.='exa -a | egrep "^\."'   #List only hidden directories and files

#Pacman and Yay
alias pacsyu='sudo pacman -Syyu'                 # update only standard pkgs
alias yaysua="yay -Sua --noconfirm"              # update only AUR pkgs
alias yaysyu="yay -Syu --noconfirm"              # update standard pkgs and AUR pkgs
alias unlock="sudo rm /var/lib/pacman/db.lck"    # remove pacman lock
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' # remove orphaned packages

#Get top process eating memory
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'

#Get top process eating cpu ##
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'

#Git
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias status='git status'
alias tag='git tag'
alias newtag='git tag -a'
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

#Get error messages
alias jctl="journalctl -p 3 -xb"
alias awesome-logs='vim ~/.local/share/sddm/xorg-session.log'

#Distro info
alias distro='cat /etc/*-release'
alias myip='curl ipv4.icanhazip.com'

#File manipulation
alias rm='rm -i'
alias cp='cp -i'
alias mkdir='mkdir -pv'
alias free='free -mt'

# switch between shells
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"

# the terminal rickroll
alias rr='curl -s -L https://raw.githubusercontent.com/keroserene/rickrollrc/master/roll.sh | bash'

alias ps='ps auxf'
alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e'
alias wget='wget -c'
alias histg='history | grep'
alias grep='grep --color=auto'


for f in ~/.config/bash/*; do source $f; done

#misc functions
#kernel () {
#  OUTPUT=$(uname -srm)
#  echo "Current Kernel: ${OUTPUT}"
#}
