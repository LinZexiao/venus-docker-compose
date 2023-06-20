#!/bin/bash
set -e

# make alias work
shopt -s expand_aliases
alias gateway=/app/venus-gateway
# check VENUS_WORKER_BIN is set
if [[ ! -z $GATEWAY_BIN ]]; then
    if [[ ! -f $GATEWAY_BIN ]]; then
        echo "$GATEWAY_BIN not exists"
    else
        alias gateway=$GATEWAY_BIN
    fi
fi

while  [ ! -f /env/token ] ; do
    echo "wait token ..."
    sleep 5
done
token=$(cat /env/token )
echo ${token}

gateway --listen=/ip4/0.0.0.0/tcp/45132 \
run \
--auth-url=http://auth:8989 \
--auth-token=${token}
