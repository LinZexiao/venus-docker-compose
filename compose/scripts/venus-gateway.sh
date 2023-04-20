#!/bin/bash
set -e

sleep 15
echo "Arg: $@"

while ture ; do
    if [ -f /env/token ]; then
        break
    fi
    echo "wait token ..."
    sleep 5
done
token=$(cat /env/token )
echo ${token}

/app/venus-gateway --listen=/ip4/0.0.0.0/tcp/45132 \
run \
--auth-url=http://auth:8989 \
--auth-token=${token}
