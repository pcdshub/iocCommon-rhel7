# Set the common directory env variables
if   [ -f  /usr/local/lcls/epics/config/common_dirs.sh ]; then
	source /usr/local/lcls/epics/config/common_dirs.sh 
elif [ -f  /reg/g/pcds/pyps/config/common_dirs.sh ]; then
	source /reg/g/pcds/pyps/config/common_dirs.sh
elif [ -f  /afs/slac/g/lcls/epics/config/common_dirs.sh ]; then
	source /afs/slac/g/lcls/epics/config/common_dirs.sh
fi

export TZ=PST8PDT

IOC_HOST=`hostname -s`
cfg=`echo $IOC_HOST | awk '{print substr($0,5,3);}' -`
IOC_USER=${cfg}ioc
IOC=$IOC_HOST
if [ -f "$IOC_COMMON/All/common_env.sh" ]; then
	# Select EPICS environment
	source $IOC_COMMON/All/common_env.sh
fi

# Set umask default to allow group write access
umask 0002

export FIGNORE=".o:.obj"
export PAGER="less"

#shopt -s cdspell expand_aliases cdable_vars checkwinsize

alias ei='egrep -i'
alias ev='egrep -v'
alias h='history 10'
alias ls='ls --color=tty -F'
alias la='ls --color=tty -FA'
alias ll='ls --color=tty -Flh'
alias lt='ls --color=tty -Flth'
alias m='$PAGER'
alias ssh='ssh -Y'

# Create variable for setting Title Bar on xterm
case $TERM in
	xterm*)
		TITLEBAR='\[\e]0;\h:\w\a\]'
		;;
	*)
		TITLEBAR=''
		;;
esac

# Define convenience variables for colors
      BLACK='\e[0;30m'
        RED='\e[0;31m'
      GREEN='\e[0;32m'
     YELLOW='\e[0;33m'
       BLUE='\e[0;34m'
     PURPLE='\e[0;35m'
       CYAN='\e[0;36m'
  BOLD_GRAY='\e[1;30m'
   BOLD_RED='\e[1;31m'
 BOLD_GREEN='\e[1;32m'
BOLD_YELLOW='\e[1;33m'
  BOLD_BLUE='\e[1;34m'
BOLD_PURPLE='\e[1;35m'
  BOLD_CYAN='\e[1;36m'
       GRAY='\e[37m\e[44m'
      WHITE='\e[40m\e[1;37m'
 BKGD_BLACK='\e[40m'
 BKGD_WHITE='\e[47m'
   NO_COLOR='\e[0m'

# Prompt special chars
# \[ 	begins non-printing chars
# \] 	ends   non-printing chars
# \a    ASCII bell (also \007)
# \e    ASCII escape character (033)
# \h    hostname up to the first '.'
# \H    hostname
# \j    number of jobs currently managed by the shell
# \l    basename of the shell's terminal device name
# \n    newline
# \r    carriage return
# \u	username
# \w	Current directory ($HOME with ~)
# \W	Basename of current dir ($HOME with ~)
# \T	Time in 24hr HH:MM:SS
# \@	Time in 12hr am/pm 
# \!	history number
# \#	command number
# \$	# for root, $ for user
# \nnn	character for octal nnn
# \\	backslash

if [ `id -u` -eq 0 ]; then
	export PTAIL="#"
else
	export PTAIL="%"
fi

#alias long='export PS1="(\#)\h:\w $PTAIL "'
alias long_prompt='export PS1="${TITLEBAR}$GREEN(\!) \@ $BLUE\u@\h:\w$NO_COLOR
$PTAIL "'
alias short_prompt='export PS1="[\u@\h \W]$PTAIL "'

# Default to long version of prompt
long_prompt
#if [ -n "$PS1" ]; then
#	export PS1="${TITLEBAR}$GREEN(\!) \@ $BLUE\u@\h:\w$NO_COLOR
#$PTAIL "
#fi
#export PS1="> "

