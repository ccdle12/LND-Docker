#!/bin/sh

# Create aliases for btc and lncli.
echo 'alias btc="btcctl"' >> /root/.bashrc

# Source bash profile.
. ~/.bashrc &

# Run btcd.
## Source the script and run it in the same process.
. /root/scripts/run-btcd.sh &

# Run LND in testnet.
lnd start &

# Keep container open.
tail -f /dev/null
