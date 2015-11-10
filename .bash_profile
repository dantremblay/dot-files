SSH_ENV="${HOME}/.ssh/environment"
SSH_AGENT_ENABLED="${HOME}/.ssh/agent_enabled"

function start_agent {
	echo "Initialising SSH agent ..."
	/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
	echo "succeeded"

	chmod 600 "${SSH_ENV}"
	source "${SSH_ENV}" > /dev/null

	/usr/bin/ssh-add
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

SSHKEY_ENCRYPTED=0
for f in `ls -1 ${HOME}/.ssh/`; do
	if [ `head -n 1 ${HOME}/.ssh/$f | grep -E "^\-\-\-\-\-BEGIN [DR]SA PRIVATE KEY\-\-\-\-\-$" | wc -l` -eq 1 ]; then
		if [ `head -n 2 ${HOME}/.ssh/$f | tail -n 1 | grep ENCRYPTED | wc -l` -eq 1 ]; then
			SSHKEY_ENCRYPTED=1
			break
		fi
	fi
done

# Source SSH settings, if applicable
if [ -f "${SSH_AGENT_ENABLED}" -o ${SSHKEY_ENCRYPTED} -eq 1 ]; then
	if [ -f "${SSH_ENV}" ]; then
		source "${SSH_ENV}" > /dev/null

		if [ `ps ux | grep ${SSH_AGENT_PID} | grep [s]sh-agent | wc -l` -eq 0 ]; then
			start_agent
		fi
	else
		start_agent
	fi
fi
