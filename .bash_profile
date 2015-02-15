SSH_ENV="${HOME}/.ssh/environment"
SSH_AGENT_ENABLED="${HOME}/.ssh/agent_enabled"

function start_agent {
	if [ -f "${SSH_AGENT_ENABLED}" ]; then
		echo "Initialising SSH agent ..."
		/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
		echo succeeded

		chmod 600 "${SSH_ENV}"
		source "${SSH_ENV}" > /dev/null

		/usr/bin/ssh-add
	fi
}

# if running bash
if [ -n "$BASH_VERSION" ]; then
	# include .bashrc if it exists
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

# Source SSH settings, if applicable
if [ -f "${SSH_AGENT_ENABLED}" ]; then
	if [ -f "${SSH_ENV}" ]; then
		source "${SSH_ENV}" > /dev/null

		ps -ux | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
			start_agent
		}
	else
		start_agent
	fi
fi

export SSH_AGENT_ENABLED
