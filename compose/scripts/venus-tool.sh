#!/bin/bash
set -e

# make alias work
shopt -s expand_aliases

alias venus-tool=/app/venus-tool
# check VENUS_TOOL_BIN is set
if [[ ! -z $VENUS_TOOL_BIN ]]; then
    if [[ ! -f $VENUS_TOOL_BIN ]]; then
        echo "$VENUS_TOOL_BIN not exists"
    else
        alias venus-tool=$VENUS_TOOL_BIN
    fi
fi

venus-tool --version

Args="run "

if [[ ! -d ~/.venus-tool ]]; then
token=$(cat /env/token )
wallet_api=$(cat /env/wallet_api )

Args="$Args --listen=0.0.0.0:12580"
Args="$Args --node-api=/dns/node/tcp/3453"
Args="$Args --msg-api=/dns/messager/tcp/39812"
Args="$Args --market-api=/dns/market/tcp/41235"
Args="$Args --wallet-api=${wallet_api}"
Args="$Args --auth-api=http://auth:8989"
Args="$Args --damocles-api=/dns/vsm/tcp/1789"
Args="$Args --miner-api=/dns/miner/tcp/12308"
Args="$Args --common-token=${token}"

fi

echo "EXEC: venus-tool $Args"
venus-tool $Args
