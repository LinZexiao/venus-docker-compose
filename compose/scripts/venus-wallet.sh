#!/bin/bash
set -e

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

Args="$Args run --password=$PSWD --gateway-api=/dns/gateway/tcp/45132 --gateway-token=$token --support-accounts=admin"

# check if /root/.venus_wallet/ exists
if [[ ! -d /root/.venus_wallet ]]; then
    echo "not found ~/.venus_wallet, init it"
    
    # set api
    ./venus-wallet $Args &
    sleep 1
    pkill venus-wallet
    /compose/bin/toml set /root/.venus_wallet/config.toml API.ListenAddress  /ip4/0.0.0.0/tcp/5678/http > /root/.venus_wallet/config.toml.tmp
    mv -f /root/.venus_wallet/config.toml.tmp /root/.venus_wallet/config.toml
fi


echo "EXEC: ./venus-wallet $Args \n\n"
./venus-wallet $Args &

sleep 3
# output wallet api
if [[ ! -f /env/wallet_api ]];then
wallet_api=$(venus-wallet auth api-info --perm admin)
echo "wallet_api: $wallet_api"
echo $wallet_api > /env/wallet_api
fi

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



wait
