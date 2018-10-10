#!/bin/bash

# Build the current Dockerfile as tagged image.
docker build -t "lnd" ./

# $1 = Path to host persistent storage.

# Run the container.
docker run -d --env-file=.env -p 10009:10009 -p 8080:8080 -p 8334:8334 -p 8337:8337 -v $1:/mnt/btcd --name lnd-node lnd
