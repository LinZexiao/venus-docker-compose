#!/bin/sh

echo "Arg: $@"

token=$(cat /env/token )
echo "token:"
echo ${token}


if [ ! -d "/root/.venusminer" ];
then
    echo "not found ~/.venusminer"
    /app/venus-miner init  --auth-api http://auth:8989 --token ${token} --gateway-api /dns/gateway/tcp/45132 --api /dns/node/tcp/3453 --slash-filter local
fi

/app/venus-miner run 
