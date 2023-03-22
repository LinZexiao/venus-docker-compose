#!/bin/bash

echo "Arg: $@"

PSWD=$(head -n 10 /dev/urandom | md5sum | head -c 20)
if [[ -f /env/wallet_pswd ]]; then
    PSWD=$(cat /env/wallet_pswd)
else
    echo $PSWD > /env/wallet_pswd
fi


token=$(cat /env/token )

Args=""
if [ $nettype ]
then
    Args="$Args --nettype=$nettype"
fi

Args="$Args run --password=$PSWD --gateway-api=/ip4/127.0.0.1/tcp/45132 --gateway-token=$token --support-accounts=admin"


echo "EXEC: ./venus-wallet $Args \n\n"
./venus-wallet $Args &

sleep 3
addr_exist=$( venus-wallet list )
if [ -z "$addr_exist" ]
then
    if [ -f /env/init.key ]; then
        ADDR=$(venus-wallet import /env/init.key  | awk '{print $3}')
        while [ $? -ne 0 ]; do
            ADDR=$(venus-wallet import /env/init.key | awk '{print $3}')
        done
        echo "imported address: $ADDR"
    else
        ADDR=$(venus-wallet new bls)
        echo "new address: $ADDR"
    fi
    echo $ADDR > /env/wallet_address
fi

wallet_api=$(venus-wallet auth api-info --perm admin)
echo "wallet_api: $wallet_api"
echo $wallet_api > /env/wallet_api

wait
