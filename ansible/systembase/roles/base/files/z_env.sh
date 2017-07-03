# Color prompt
PS1='\[\033[01;32m\]\u\[\033[00m\]\[\033[01;32m\]@\[\033[00m\]\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

HISTSIZE=10000
HISTIGNORE="pwd:ls:ls -la:ll:ll -la:exit:ll -h"
HISTCONTROL=ignoredups

HISTTIMEFORMAT='[%F %T] '
TMOUT=43200

#export PROMPT_COMMAND='{ msg=$(history 1 | { read x y; echo $y; });user=$(whoami); echo $(date "+%Y-%m-%d %H:%M:%S"):$user:`pwd`/:$msg ---- $(who am i); } >> $HOME/.`hostname`.`whoami`.history-timestamp'

# echo -ne “\e]2;$(ifconfig | awk ‘/inet addr:/ && ! /inet addr:127\./ { sub (“addr:”, “”); print $2 }’ | sed -e :a -e ‘$!N;s/\n/\|/g;ta’):${PWD}\a”

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias la='ls -A'
alias ll='ls -lh'
alias lh='ls -lh'
alias df='df -h'
alias du='du -h'