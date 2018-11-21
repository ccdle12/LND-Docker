#!/bin/sh

POST_INIT_SYNC_DELAY=60
POLL_DELAY=60
STALL_THRESHOLD=5

if [ -z `pidof btcd` ]; then
        echo "Starting btcd"
        btcd &
        sleep $POST_INIT_SYNC_DELAY
fi

stalls=0
while true; do
        start=`btc --notls getinfo | jq -r .blocks`
        sleep $POLL_DELAY
        end=`btc --notls getinfo | jq -r .blocks`
        echo "Processed $((end - start)) blocks in the last $POLL_DELAY seconds"
        if [[ "$start" == "$end" ]]; then
                if (( stalls > STALL_THRESHOLD )); then
                        echo "Too many stalls detected. Restarting btcd..."
                        kill `pidof btcd`
                        sleep 10
                        btcd &
                        stalls=0
                else
                        syncnode=`btc --notls getpeerinfo | jq -r '.[] | select(.syncnode == true) | .addr' | cut -f1 -d:`
                        if [ -z "$syncnode" ]; then
                                echo "Stall detected, but no syncnode found. Restarting btcd..."
                                kill `pidof btcd`
                                sleep 10
                                btcd &
                                stalls=0
                        else
                                echo "Stall detected! Evicting potentially bad node $syncnode"
                                btc --notls node disconnect $syncnode
                                stalls=$(( stalls + 1 ))
                        fi
                fi
        fi
done
