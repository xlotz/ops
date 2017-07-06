# Color prompt
PS1='\[\033[01;32m\]\u\[\033[00m\]\[\033[01;32m\]@\[\033[00m\]\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

HISTSIZE=10000
HISTIGNORE="pwd:ls:ls -la:ll:ll -la:exit:ll -h"
HISTCONTROL=ignoredups

HISTTIMEFORMAT='[%F %T] '
TMOUT=43200

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias la='ls -A'
alias ll='ls -lh'
alias lh='ls -lh'
alias df='df -h'
alias du='du -h'