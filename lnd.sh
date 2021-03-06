#!/bin/bash

# Build the current Dockerfile as tagged image.
function build() {
    docker build -t "lnd" ./
}

# $1 = Path to host persistent storage.
# Run the container.
function run() {
    # Folders to persist graph and chain data.
    $graph = "/lnd/graph/"
    $chain = "/lnd/chain/"

    # Run the build function.
    build

    # Run the docker image.
    docker run -d --env-file=.env -p 10009:10009 -p 8080:8080 -p 8334:8334 -p 8337:8337 -p 9735:9735 -v $1:/mnt/blockstorage --name lnd-node lnd
}

# Attach into the LND container.
function attach() {
    docker exec -ti lnd-node /bin/bash
}

# Update will attach in the container, update the master branch and rebuild lnd.
function update() {
    docker exec -ti lnd-node /bin/bash -c "
        cd gocode/src/github.com/lightningnetwork/lnd \
        && git pull \
        && make \
        && make install
    "
}

# $1 = Path to host persistent storage.
# Restart the node.
function restart() {
   docker stop lnd-node && docker rm lnd-node
   run $1
}

# Evaluate the first arg as function call.
cmd="$1"
shift
eval "$cmd $@"
