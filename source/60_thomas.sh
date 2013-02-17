set -o vi

# Give me core files!
ulimit -c unlimited

export HISTIGNORE="&:ls:[bg]g:exit"
export HISTSIZE=5000

# define the cscope database file
export CSCOPE_DIR=\$HOME/.cscope

shopt -s histappend
export PROMPT_COMMAND='history -a'

shopt -s cdspell

bind Space:magic-space

user=`whoami`

# use vim as the man pager
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""

# Don't let Ctrl-S freeze the terminal.
stty -ixon

