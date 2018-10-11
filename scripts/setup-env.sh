#!/bin/bash

# Adding alias variables to .bashrc.
echo 'alias btc="btcctl --testnet"' >> /root/.bashrc
echo 'alias lncli="lncli --macaroonpath /root/.lnd/data/chain/bitcoin/testnet/admin.macaroon"' >> /root/.bashrc

# Source bash profile.
. ~/.bashrc

# Run btcd.
## Source the script and run it in the same process.
. /root/scripts/run-btcd.sh &

# Run LND in testnet.
lnd start &

# Keep container open.
sleep infinity;
