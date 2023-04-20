#!/bin/bash
set -e

shopt -s expand_aliases
alias venus-worker=/venus-worker

if [[ -f /env/token ]];
then
    echo "token exists"
    token=$(cat /env/token )
    echo "token: ${token}"
else
    echo "token not exists"
    echo "please create token file in /env/token"
fi

if [[ ! -f /config.toml ]]; then
sed "s/<TOKEN>/$token/g" /compose/config/venus-worker.toml > /root/config.toml
echo "venus-worker config:"
cat /root/config.toml
fi


if [[ ! -d /root/data/store/store1 ]]; then
    venus-worker store sealing-init -l /root/data/store/store1
fi

if [[ ! -d /root/data/pieces/ ]]; then
    mkdir /root/data/pieces/
fi

venus-worker daemon -c /root/config.toml
