if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
HOME=/data0/weibo_bigdata_pa/sida3

# https://stackoverflow.com/questions/15384025/bash-git-ps1-command-not-found
source /usr/share/git-core/contrib/completion/git-prompt.sh

bind -f $HOME/.inputrc
# source /data0/weibo_bigdata_pa/sida3/.bash_git

# adding git branch indication to prompt
# https://www.youtube.com/watch?v=_P5g2gpabfo&index=7&list=PLVBFw0Pn9e9L7SOKtL8x4Av39drO5Oi-Q
# https://superuser.com/questions/382456/why-does-this-bash-prompt-sometimes-keep-part-of-previous-commands-when-scrollin
BYELLOW='\[\033[01;33m\]'
IBLACK='\[\033[0;90m\]'
PS_CLEAR='\[\033[0m\]'

THEIP=$(hostname)

# export PS1="\n${BYELLOW}[\w]${PS_CLEAR}\n${IBLACK}\$ "
# export PS1='\[\[\033[0m\]\w\$ '
# export PS1='\[\033[0m\]\w\[$(__git_ps1 " (%s)")\$ '
export PS1='\[\033[0m\]$THEIP \w\[$(__git_ps1 " (%s)")\$ '
# export PS1='\[\[\033[0m\]$THEIP \w\$ '

export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# https://unix.stackexchange.com/questions/55203/bash-autocomplete-first-list-files-then-cycle-through-them
bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

alias ll='ls -alG'
alias hf="hadoop fs"
alias e='emacs'





