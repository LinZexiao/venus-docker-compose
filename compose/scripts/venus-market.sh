#!/bin/bash
# set -e

token=$(cat /env/token )
echo "token:"
echo ${token}


if [[ -d ~/.venusmarket ]];then
    /app/venus-market run
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
    echo "EXEC: /app/venus-market $Args \n\n"
    /app/venus-market $Args &

    sleep 30
    exist=$(/app/venus-market  piece-storage list | grep DefaultPieceStorage )
    if [ -z "$exist" ]; then
        echo "add piece storage"
        /app/venus-market piece-storage add-fs --name DefaultPieceStorage --path /data/pieces
    fi

    wait
fi
