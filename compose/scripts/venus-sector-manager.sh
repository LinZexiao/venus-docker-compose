#!/bin/bash


if [[ -f /env/token ]];
then
    echo "token exists"
    token=$(cat /env/token )
    echo "token: ${token}"
else
    echo "token not exists"
    echo "please create token file in /env/token"
fi

if [[ -f /env/wallet_address  ]];
then
    echo "address exists"
    address=$(cat /env/wallet_address )
    echo "address: ${address}"
else
    echo "address not exists"
    echo "please create address file in /env/wallet_address"
fi


# config
if [[ -d ~/.venus-sector-manager ]]; then
    echo " repo ~/venus-sector-manager already exists"
else
    echo " repo ~/venus-sector-manager not exists, init it."
    venus-sector-manager daemon init
    sed "s/<TOKEN>/$token/g" /compose/config/sector-manager.cfg > ~/.venus-sector-manager/sector-manager.cfg
    sed -i "s/<ADDRESS>/$address/g" ~/.venus-sector-manager/sector-manager.cfg

    venus-sector-manager util miner create --from $address --sector-size 8MiB &> miner.log
    miner=$(cat miner.log | grep 'miner actor:' | awk '{print $7}' )
    if [[  ${miner:2} != 1001 ]]; then
        echo "unexpected miner: $miner"
        exit 1
    fi
    echo "miner: $miner"
    echo "miner created"
    echo $miner > /env/miner
fi

if [[ ! -d /root/data/pieces/ ]]; then
    mkdir /root/data/pieces/
fi

# wait for node warm up
sleep 30
venus-sector-manager --net=$nettype daemon run
