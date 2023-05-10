#!/bin/bash
set -e

token=$(cat /env/token )
echo "token:"
echo ${token}

wallet_api=$(cat /env/wallet_api )
WALLET_TOKEN=$(echo "$wallet_api" | sed 's/.*[:]\(.*\)/\1/')  
WALLET_URL=$(echo "$wallet_api" | sed 's/.*:\(.*\)/\1/')

Args="run "
if [[ -d ~/.marketclient ]];then
    echo "repo ~/.marketclient already exists"
else
    Args="$Args --listen=/ip4/0.0.0.0/tcp/41231"
    Args="$Args --auth-token=${token}"
    Args="$Args --node-url=/dns/node/tcp/3453"
    Args="$Args --messager-url=/dns/messager/tcp/39812/"
    Args="$Args --signer-type=wallet"
    Args="$Args --signer-url=$WALLET_URL"
    Args="$Args --signer-token=$WALLET_TOKEN"
fi

echo "EXEC: /app/market-client $Args \n\n"
/app/market-client $Args 
