#!/bin/bash
set -e

echo "Arg: $@"

token=$(cat /env/token )
echo "token:"
echo ${token}


if [ ! -d "/root/.sophon-miner" ];
then
    echo "not found ~/.sophon-miner"
    /app/sophon-miner init  --auth-api http://auth:8989 --token ${token} --gateway-api /dns/gateway/tcp/45132 --api /dns/node/tcp/3453 --slash-filter local
fi

/app/sophon-miner run --listen /ip4/0.0.0.0/tcp/12308
