#!/bin/sh

echo "Arg: $@"
token=$(cat /env/token )
echo ${token}

/app/venus-messager run \
--auth-url=http://auth:8989 \
--node-url=/dns/node/tcp/3453 \
--gateway-url=/dns/gateway/tcp/45132 \
--auth-token ${token}
