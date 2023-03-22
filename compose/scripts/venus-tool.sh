#!/bin/bash
Args="run "

if [[ ! -d ~/.venustool ]]; then
token=$(cat /env/token )
wallet_api=$(cat /env/wallet_api )

Args="$Args --node-api=/ip4/127.0.0.1/tcp/3453"
Args="$Args --msg-api=/ip4/127.0.0.1/tcp/39812"
Args="$Args --market-api=/ip4/127.0.0.1/tcp/41235"
Args="$Args --wallet-api=${wallet_api}"
Args="$Args --common-token=${token}"

fi

echo "EXEC: venus-tool $Args"
venus-tool $Args
