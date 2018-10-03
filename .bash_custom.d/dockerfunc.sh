# Bash wrappers for docker run commands

#
# Helper Functions
#
dcleanup(){
	local containers
	mapfile -t containers < <(docker container ls -aq 2>/dev/null)
	docker container rm "${containers[@]}" 2>/dev/null
	local volumes
	mapfile -t volumes < <(docker container ls --filter status=exited -q 2>/dev/null)
	docker container rm -v "${volumes[@]}" 2>/dev/null
	local images
	mapfile -t images < <(docker image ls --filter dangling=true -q 2>/dev/null)
	docker image rm "${images[@]}" 2>/dev/null
}
relies_on(){
	for container in "$@"; do
		local state
		state=$(docker container inspect --format "{{.State.Running}}" "$container" 2>/dev/null)

		if [[ "$state" == "false" ]] || [[ "$state" == "" ]]; then
			echo "$container is not running, starting it for you."
			$container
		fi
	done
}

#
# Apps
#
devgo() {
	docker container run -ti --rm \
		--mount type=bind,src=${PWD},dst=/go/src/github.com/$(echo $PWD | awk 'BEGIN { FS="/"; OFS="/" } { print $(NF-1), $NF }') \
		juliengk/dev:go
}
dig() {
	docker container run -it --rm \
		--log-driver none \
		juliengk/dig "$@"
}
#dockerlint() {
#}
doctl() {
        docker container run -ti --rm \
		-u $(id -u) \
                juliengk/doctl "$@"
}
htop() {
	docker container run -it --rm \
		--pid host \
		--net none \
		--name htop \
		jess/htop
}
netcat(){
	docker container run -it --rm \
		--net host \
		jess/netcat "$@"
}
nmap(){
	docker container run -it --rm \
		--net host \
		jess/nmap "$@"
}
telnet(){
	docker container run -it --rm \
		--log-driver none \
		jess/telnet "$@"
}
traceroute(){
	docker container run -it --rm \
		--net host \
		jess/traceroute "$@"
}
travis() {
	docker container run -ti --rm \
		-v ${PWD}:/srv/project \
		-v ${HOME}/Data/travis/home:/root/.travis \
		juliengk/travis "$@"
}
wireshark(){
	docker run -d --rm\
		-v /etc/localtime:/etc/localtime:ro \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		-e "DISPLAY=unix${DISPLAY}" \
		--cap-add NET_RAW \
		--cap-add NET_ADMIN \
		--net host \
		--name wireshark \
		jess/wireshark
}
