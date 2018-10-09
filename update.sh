#!/bin/bash

docker exec -ti lnd-node /bin/bash -c "
    cd gocode/src/github.com/lightningnetwork/lnd \
    && git pull \
    && make \
    && make install
"