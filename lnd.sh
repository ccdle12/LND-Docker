#!/bin/bash

# Build the current Dockerfile as tagged image.
function build() {
    docker build -t "lnd" ./
}

# $1 = Path to host persistent storage.
# Run the container.
function run() {
    build
    docker run -d --env-file=.env -p 10009:10009 -p 8080:8080 -p 8334:8334 -p 8337:8337 -v $1:/mnt/btcd --name lnd-node lnd
}

# Attach into the LND container.
function attach() {
    docker exec -ti lnd-node /bin/bash
}

# Update will attach in the container, update the master the branch and rebuild lnd.
function update() {
    docker exec -ti lnd-node /bin/bash -c "
        cd gocode/src/github.com/lightningnetwork/lnd \
        && git pull \
        && make \
        && make install
    "
}

# Evaluate the first arg as function call
cmd="$1"
shift
eval "$cmd $@"
