#!/bin/bash
# set -e

# make alias work
shopt -s expand_aliases

token=$(cat /env/token )
echo "token:"
echo ${token}

alias venus-market=/app/venus-market
# check MARKET_BIN is set
if [[ ! -z $MARKET_BIN ]]; then
    if [[ ! -f $MARKET_BIN ]]; then
        echo "$MARKET_BIN not exists"
    else
        alias venus-market=$MARKET_BIN
    fi
fi
venus-market --version


if [[ -d ~/.venusmarket ]];then
    venus-market run &
else
    Args="run "
    Args="$Args --auth-url=http://auth:8989"
    Args="$Args --listen=/ip4/0.0.0.0/tcp/41235"
    Args="$Args --node-url=/dns/node/tcp/3453"
    Args="$Args --auth-url=http://auth:8989"
    Args="$Args --gateway-url=/dns/gateway/tcp/45132/"
    Args="$Args --messager-url=/dns/messager/tcp/39812/"
    Args="$Args --cs-token=${token}"
    Args="$Args --signer-type=gateway"
    echo "EXEC: venus-market $Args \n\n"
    venus-market $Args &

    sleep 30
    exist=$(venus-market  piece-storage list | grep DefaultPieceStorage )
    if [ -z "$exist" ]; then
        echo "add piece storage"
        venus-market piece-storage add-fs --name DefaultPieceStorage --path /data/pieces
    fi

    #  todo : upsert miner , set peerid , set ask , set publish period
fi

wait
