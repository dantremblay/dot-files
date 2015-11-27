# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

#-----------------------------------------------------------------------------
# Environment Variables
#-----------------------------------------------------------------------------

# User specific aliases and functions
export EDITOR='vim'
export VISUAL='vim'

# Use less as our pager
export PAGER=/usr/bin/less
export LESS=-R

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

HISTIGNORE="history*:ls:pwd:date:* --help"

# Needed for our custom version of 'less'
export MYVIMDIR="$HOME/.vim/"

#-----------------------------------------------------------------------------
# Aliases
#-----------------------------------------------------------------------------

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias xargs='xargs -I {}'

# copy working directory
alias cwd='pwd | tr -d "\r\n" | xclip -selection clipboard'

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | xclip -selection clipboard | echo '=> Public key copied to pasteboard.'"

# Pipe my private key to my clipboard.
alias prikey="more ~/.ssh/id_rsa | xclip -selection clipboard | echo '=> Private key copied to pasteboard.'"

#-----------------------------------------------------------------------------
# Global Settings
#-----------------------------------------------------------------------------

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

#-----------------------------------------------------------------------------
# Git Prompt
#-----------------------------------------------------------------------------

bold='';
reset="\e[0m";

black="\e[1;30m";
red="\e[1;31m";
green="\e[1;32m";
yellow="\e[1;33m";
blue="\e[1;34m";
purple="\e[1;35m";
cyan="\e[1;36m";
white="\e[1;37m";

# change prompt when using git
function git_branch {
        git symbolic-ref --short -q HEAD 2> /dev/null
}

function parse_git_branch {
        _result=`git_branch`

        if [ -z $_result ]; then
                _result=""
        else
                _result="(${_result})"
        fi

        echo ${_result}
}

function git_is_uptodate {
	git_dir=`git rev-parse --git-dir 2> /dev/null | wc -l`
	code=33

	if [ "${git_dir}" -eq "1" ]; then
		remote="origin"
		code=31

		if [ ! -f /tmp/git-prompt-disabled ]; then
			remote_head=`git ls-remote -h ${remote} 2> /dev/null | grep "refs/heads/$(git_branch)" | awk '{ print $1 }'`

			if [ ! -z ${remote_head} ]; then
				result=`git log --format="%H" 2> /dev/null | grep ${remote_head} | wc -l`

				if [ "${result}" -eq "1" ]; then
					code=32
				else
					code=31
				fi
			else
				code=33
			fi
		fi
	fi

	echo ${code}
}

# Highlight the user name when logged in as root.
if [[ "${USER}" == "root" ]]; then
	userStyle="${red}";
else
	userStyle="${cyan}";
fi;

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}";
else
	hostStyle="${yellow}";
fi;

# Set the terminal title to the current working directory.
PS1="\[\033]0;\u@\h\007\]";
PS1+="\[${bold}\]\n"; # newline
PS1+="\[${userStyle}\]\u"; # username
PS1+="\[${white}\] at ";
PS1+="\[${hostStyle}\]\h"; # host
if [ -f /.dockerenv ]; then
	PS1+="\[${white}\] [c]"
fi
PS1+="\[${white}\] in ";
PS1+="\[${green}\]\w\[${reset}\]"; # working directory
PS1+=" \[\e[\$(git_is_uptodate)m\]\$(parse_git_branch)\[\e[m\]"; # Git repository details
PS1+="\n";
PS1+="\[${white}\]\$ \[${reset}\]"; # `$` (and reset color)
export PS1;

PS2="\[${yellow}\]→ \[${reset}\]";
export PS2;

#-----------------------------------------------------------------------------
# Misc. Custom Functions
#-----------------------------------------------------------------------------

# display cert info
function certinfo () { openssl x509 -in $1 -noout -text; }

# display CSR info
function csrinfo () { openssl asn1parse -in $1; }

# puppet template syntax checking
function pt() {
	if [ -z $1 ]; then
		echo "usage: pt <puppet_template_file.erb>"
		return;
	fi

	/usr/bin/erb -P -x -T '-' $1 | /usr/bin/ruby -c
}

# puppet manifest syntax checking
function pc() {
	if [ -z $1 ]; then
		puppet parser validate init.pp
	else
		puppet parser validate $1
	fi
}

# Custom less function, uses vim so we get syntax highlighting
function cless() {
	if [ $# -eq 0 ]; then
		vim -c 'so $MYVIMDIR/tools/less.vim' -
	else
		vim -c 'so $MYVIMDIR/tools/less.vim' "$@"
	fi
}

#-----------------------------------------------------------------------------
# Git Functions
#-----------------------------------------------------------------------------

# rewrite git log author info
function git_log_rewrite_author() {
	if [ -z $1 -a -z $2 -a -z $3 ]; then
		echo "usage: git_log_rewrite_author <name|email> <old_value> <new_value>"
		return;
	fi

	if [ "$1" != "name" -o "$1" != "email" ]; then
		echo "error: first parameter must be \'name\' or \'email\'"
		return;
	fi

	git filter-branch --commit-filter '
		if [ "$1" == "name" -a "$GIT_AUTHOR_NAME" == $2 ]; then
			GIT_AUTHOR_NAME="$3";
		elif [ "$1" == "email" -a "$GIT_AUTHOR_EMAIL" == $2 ]; then
			GIT_AUTHOR_EMAIL=$3;

			git commit-tree "$@";
		else
			git commit-tree "$@";
		fi' HEAD
}

#-----------------------------------------------------------------------------
# Customs
#-----------------------------------------------------------------------------

# You may want to put all your additions into a separate file like
# ~/.bash_custom, instead of adding them here directly.

if [ -d ~/.bash_custom.d ]; then
	for i in ~/.bash_custom.d/*.sh; do
		if [ -r $i ]; then
			. $i
		fi
	done

	unset i
fi
