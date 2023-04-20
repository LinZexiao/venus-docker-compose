#!/bin/bash
set -e

Args="run "

if [[ ! -d ~/.venustool ]]; then
token=$(cat /env/token )
wallet_api=$(cat /env/wallet_api )

Args="$Args --node-api=/dns/node/tcp/3453"
Args="$Args --msg-api=/dns/messager/tcp/39812"
Args="$Args --market-api=/dns/market/tcp/41235"
Args="$Args --wallet-api=${wallet_api}"
Args="$Args --common-token=${token}"

fi

echo "EXEC: venus-tool $Args"
venus-tool $Args
