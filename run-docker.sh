#!/bin/bash

# Build the current Dockerfile as tagged image
docker build -t "lnd" ./

# Runt the container
docker run -d --env-file=.env -p 10009:10009 -p 8080:8080 -p 8334:8334 -p 8337:8337 --name lnd-node lnd
