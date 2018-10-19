#!/bin/bash

# Create aliases for btc and lncli.
echo 'alias btc="btcctl --testnet"' >> /root/.bashrc
echo 'alias lncli="lncli --n testnet"' >> /root/.bashrc

# Source bash profile.
. ~/.bashrc

# Run btcd.
## Source the script and run it in the same process.
. /root/scripts/run-btcd.sh &

# Run LND in testnet.
lnd start &

# Keep container open.
sleep infinity;
