#!/bin/bash
set -e

if [[ -z "$VENUS_PATH" ]];then 
    VENUS_PATH="~/.venus"
fi

if [[ -d "$VENUS_PATH" ]];then
    /app/venus daemon
else

    Args=" --auth-url=http://auth:8989 "

    while [ ! -f /env/token ] ; do
        echo "wait token ..."
        sleep 5
    done
    token=$(cat /env/token )
    Args="$Args --auth-token=$token"

    if [ ! -z $NET_TYPE ]
    then
        Args="$Args --network=$NET_TYPE"
    fi

    if [ ! -z $SNAP_SHOT ]
    then
        Args="$Args --import-snapshot=/root/snapshot.car"
    fi

    if [ -z $SNAP_SHOT  ] && [ ! -z $GEN_FILE ] 
    then
        Args="$Args --genesisfile=/root/genesis.car"
    fi

    # if not mainnet,calibrationnet,butterflynet, wait for bootstrap
    if [ ! -z $NET_TYPE ] && [ $NET_TYPE != "mainnet" ] && [ $NET_TYPE != "calibrationnet" ] && [ $NET_TYPE != "butterflynet" ]
    then
        while [ ! -f /env/bootstrap ] ; do
            echo "wait bootstrap ..."
            sleep 5
        done
        bootstraper=$(cat /env/bootstrap )
        if [[ $bootstraper == *"/ip4/127.0.0.1"* ]]; then
            bootstraper=${bootstraper//\/ip4\/127.0.0.1/\/dns\/genesis}
        fi
        Args="$Args --bootstrap-peers=$bootstraper"
    fi


    echo "EXEC: /app/venus daemon $Args \n\n"
    /app/venus daemon $Args &

    # restart to change api
    echo "wait to restart ..."
    sleep 30
    echo "restart ..."
    kill $!
    jq '.api.apiAddress="/ip4/0.0.0.0/tcp/3453" ' ~/.venus/config.json > ~/.venus/config.json.tmp
    mv -f ~/.venus/config.json.tmp ~/.venus/config.json 

    /app/venus daemon $Args
fi
