# docker aliases
alias dockercleanup='docker ps --filter "status=exited" -q | xargs docker rm {} && docker images --filter "dangling=true" -q | xargs docker rmi {}'

alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'"
