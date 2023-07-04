#!/bin/bash
set -e

echo "Arg: $@"
token=$(cat /env/token )
echo ${token}

/app/sophon-messager run \
--auth-url=http://auth:8989 \
--node-url=/dns/node/tcp/3453 \
--gateway-url=/dns/gateway/tcp/45132 \
--listen=/ip4/0.0.0.0/tcp/39812 \
--auth-token ${token}
