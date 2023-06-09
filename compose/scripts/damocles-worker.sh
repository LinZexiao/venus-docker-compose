#!/bin/bash
set -e

# make alias work
shopt -s expand_aliases

alias damocles-worker=/damocles-worker
# check WORKER_BIN is set
if [[ ! -z $WORKER_BIN ]]; then
    if [[ ! -f $WORKER_BIN ]]; then
        echo "$WORKER_BIN not exists"
    else
        alias damocles-worker=$WORKER_BIN
    fi
fi

damocles-worker --version

if [[ -z $WORKER_NAME ]]; then
    echo "WORKER_NAME not set"
    exit 1
fi

if [[ -f /env/token ]];
then
    echo "token exists"
    token=$(cat /env/token )
    echo "token: ${token}"
else
    echo "token not exists"
    echo "please create token file in /env/token"
    exit 1
fi

if [[ ! -f /root/$WORKER_NAME.toml ]]; then
sed "s/<TOKEN>/$token/g" /compose/config/damocles-worker.toml > /tmp/worker.toml
sed "s/<WORKER_NAME>/$WORKER_NAME/g" /tmp/worker.toml > /root/$WORKER_NAME.toml
fi


if [[ ! -d /data/$WORKER_NAME/store/store1 ]]; then
    damocles-worker store sealing-init -l /data/$WORKER_NAME/store/store1
fi

if [[ ! -d /data/$WORKER_NAME/store/store2 ]]; then
    damocles-worker store sealing-init -l /data/$WORKER_NAME/store/store2
fi

if [[ ! -d /data/$WORKER_NAME/store/store3 ]]; then
    damocles-worker store sealing-init -l /data/$WORKER_NAME/store/store3
fi

if [[ ! -d /data/pieces/ ]]; then
    mkdir /data/pieces/
fi

damocles-worker daemon -c /root/$WORKER_NAME.toml
