#!/bin/bash

# Build the current Dockerfile as tagged image.
function build() {
    docker-compose build
}

# Run the container.
function run() {
    build
    docker-compose up -d
}

# Attach into the LND container.
function attach() {
    docker exec -ti lnd /bin/sh
}

# Update will attach in the container, update the master branch and rebuild lnd.
function update() {
    docker exec -ti lnd-node /bin/sh -c "
        cd gocode/src/github.com/lightningnetwork/lnd \
        && git pull \
        && make \
        && make install
    "
}

# Restart the node.
function restart() {
   docker stop lnd && docker rm lnd
   run
}

# Evaluate the first arg as function call.
cmd="$1"
shift
eval "$cmd $@"
