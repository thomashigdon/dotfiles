#if ! [ "$SSH_TTY" ] ; then
#    return
#fi

BASH_BIN="$HOME/.linuxbrew/bin/bash"

# The replacement is only done in non-bash login interactive shell in
# SSH connection and bash executable exists.
if [                                                            \
     "$SHELL" != "$BASH_BIN" -a -n "$SSH_TTY" -a -x "$BASH_BIN" \
] ; then
    # we first check whether bash can be executed, otherwise the
    # replacement will cause immediate crash at login (not fun)
    if "$BASH_BIN" -c 'echo "Test bash running" >/dev/null' ; then
        export SHELL="$BASH_BIN"
        #echo "One can launch the bash shell by 'exec -l \$SHELL -l'"
        exec -l $SHELL -l   # launch the bash login shell
    else
        echo "Failed to launch bash shell. Go check its installation!"
        echo "Fall back to default shell $SHELL ..."
    fi
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

export PATH=$PATH:$HOME/bin

shopt -s checkwinsize

unset USERNAME

if [ -f ~/.bashrc-custom ]; then
	source ~/.bashrc-custom
fi
if [ -f ~/.bashrc-fb ]; then
	source ~/.bashrc-fb
fi

set -o vi

if [[ $OSTYPE =~ ^darwin ]]; then
  # autojump
  [[ -s "$(brew --prefix)/etc/autojump.sh" ]] && . "$(brew --prefix)/etc/autojump.sh"
fi

if [[ $OSTYPE =~ ^darwin ]]; then
  alias airport='sudo /System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport'
  alias ls='gls --color=auto -N'
  alias dircolors='gdircolors'
fi

# Aliases
alias vi=nvim
alias xpra="/Applications/Xpra.app/Contents/MacOS/Xpra"

###

## Convenience functions
function ns {
  cur_dir="$HOME/tmp/scratch/current"
  new_dir="$HOME/tmp/scratch/$(date +'%s')"

  mv "$cur_dir" "$new_dir"
  mkdir -p "$cur_dir"
  rm ~/scratch
  ln -s "$cur_dir" ~/scratch 
  cd ~/scratch || exit
  echo "New scratch dir ready"
}

grep1() { awk -v pattern="${1:?pattern is empty}" 'NR==1 || $0~pattern' "${2:?filename is empty}"; }


# Startup stuff
keychain -q "$(for x in github; do
               echo $HOME/.keys/*$x | awk '{print $NF}';
             done)"
source $HOME/.keychain/$(hostname)-sh

if command -v dircolors >/dev/null 2>&1; then
    eval $(dircolors ~/.dircolors)
fi

if [ -f $HOME/.bashrc-fb ]; then
    source $HOME/.bashrc-fb
fi

set -o vi
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

export PROMPT_COMMAND=""
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
stty -ixon

# Enable programmable completion features.
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

function my_prompt {
# here are a bunch of colors in case
# you want to get colorful
local        BLUE="\[\033[0;34m\]"
local         RED="\[\033[0;31m\]"
local   LIGHT_RED="\[\033[1;31m\]"
local       GREEN="\[\033[0;32m\]"
local LIGHT_GREEN="\[\033[1;32m\]"
local       WHITE="\[\033[1;37m\]"
local  LIGHT_GRAY="\[\033[0;37m\]"
local RESET_COLOR="\[\033[0m\]"
}

export PS1="${debian_chroot:+($debian_chroot)}\u@\h:\d at \t:\w ${GREEN}""${RESET_COLOR}\n\$ "

my_prompt

function goto_dir()
{
  WHERETO="$1"
  shift
 
  # If we're already there, duh
  if echo "$PWD" | grep "$WHERETO$" &>/dev/null; then
    return 0
  fi
 
  # Locate base directory
  ROOTDIR="$PWD"
  while [ 1 ]; do
    if [ -d "$ROOTDIR/$WHERETO" ]; then
      break
    fi
    if [ "$ROOTDIR" = "/" ]; then
      break
    fi
    ROOTDIR="$(dirname $ROOTDIR)"
  done
 
  if [ ! -d "$ROOTDIR/$WHERETO" ]; then
    echo "Cannot find $WHERETO directory." >&2
    return 1
  fi
 
  # Go to the directory
  pushd "$ROOTDIR/$WHERETO"
}

# Update tmux window titles when command is executed
case ${TERM} in

    screen*)

        # user command to change default pane title on demand
        function title { TMUX_PANE_TITLE="$*"; }

        # function that performs the title update (invoked as PROMPT_COMMAND)
        function update_title { printf "\033]2;%s\033\\" "${1:-$TMUX_PANE_TITLE}"; }

        # default pane title is the name of the current process (i.e. 'bash')
        TMUX_PANE_TITLE=$(ps -o comm $$ | tail -1)

        # Reset title to the default before displaying the command prompt
        PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND }'update_title'   

        # Update title before executing a command: set it to the command
        trap 'update_title "$BASH_COMMAND"' DEBUG

        ;;

esac

export WILDFLY_HOME=/usr/local/wildfly/current
export JBOSS_HOME=${WILDFLY_HOME}

export LOCATE_PATH=$HOME/var/lib/mlocate/mlocate.db:$LOCATE_PATH
export DBPATH=$HOME/var/lib/mlocate/mlocate.db
alias tmux="tmux -2"

export HISTCONTROL=erasedups
shopt -s histappend

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

powerline-daemon -q

alias top=htop

NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
nv_num=0
function rv {
  NVIM_LISTEN_ADDRESS=/tmp/nvimsocket
  cur_num=$(tmux display-message -p '#I')
  if nvr --serverlist | grep $NVIM_LISTEN_ADDRESS > /dev/null; then
    nvr --remote "$@"
    if [ "$RV_STAY" != "1" ]; then
      tmux select-window -t $nv_num
    fi 
  else
    if tmux select-window -t $nv_num ; then
      tmux respawn-window -t $nv_num -k "bash -c 'export NVIM_LISTEN_ADDRESS=$NVIM_LISTEN_ADDRESS ; nvim $(realpath $*)'"
    else
      tmux new-window -t $nv_num "bash -c 'export NVIM_LISTEN_ADDRESS=$NVIM_LISTEN_ADDRESS ; nvim $(realpath $*)'"
    fi
    if [ "$RV_STAY" == "1" ]; then
      tmux select-window -t "$cur_num"
    fi
  fi
}
function rvs {
  local RV_STAY=1
  nvr --remote "$@"
}
unset NVIM_LISTEN_ADDRESS

function h2d {
  echo $((16#$1))
}

[[ -s "$HOME/.local/share/marker/marker.sh" ]] && source "$HOME/.local/share/marker/marker.sh"
