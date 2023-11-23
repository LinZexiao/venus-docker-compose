#!/bin/bash
set -e


# make alias work
shopt -s expand_aliases
alias damocles-manager=/damocles-manager
# check MANAGER_BIN is set
if [[ ! -z $MANAGER_BIN ]]; then
    if [[ ! -f $MANAGER_BIN ]]; then
        echo "$MANAGER_BIN not exists"
    else
        alias damocles-manager=$MANAGER_BIN
    fi
fi

damocles-manager --version

if [[ -f /env/token ]];
then
    echo "token exists"
    token=$(cat /env/token )
    echo "token: ${token}"
else
    echo "token not exists"
    echo "please create token file in /env/token"
    exit 1
fi

if [[ -f /env/wallet_address  ]];
then
    echo "address exists"
    address=$(cat /env/wallet_address )
    echo "address: ${address}"
else
    echo "address not exists"
    echo "please create address file in /env/wallet_address"
    exit 1
fi


# config
if [[ -d ~/.damocles-manager ]]; then
    echo " repo ~/damocles-manager already exists"
else
    echo " repo ~/damocles-manager not exists, init it."
    damocles-manager daemon init

    sed "s/<TOKEN>/$token/g" /compose/config/sector-manager.cfg > ~/.damocles-manager/sector-manager.cfg
    sed -i "s/<ADDRESS>/$address/g" ~/.damocles-manager/sector-manager.cfg

    damocles-manager util miner create --from $address --sector-size 2KiB &> miner.log
    # e.g: 'miner actor: f01002 (f2fkejepoehsrcrmtifnydslnkzqzb6hzuntey5ky)'
    miner=$(cat miner.log | grep 'miner actor:' | awk '{print $3}' )
    # Todo: use toml when it supports non-string
    # /compose/bin/toml set ~/.damocles-manager/sector-manager.cfg Miners[0].Actor ${miner:2} > ~/.damocles-manager/sector-manager.cfg.tmp
    # mv -f ~/.damocles-manager/sector-manager.cfg.tmp ~/.damocles-manager/sector-manager.cfg
    if [[  ${miner:2} != 1002 ]]; then
        echo "unexpected miner: $miner"
        exit 1
    fi
    echo "miner: $miner"
    echo "miner created"
    echo $miner > /env/miner
fi

if [[ ! -d /data/pieces/ ]]; then
    mkdir /data/pieces/
fi

if [[ ! -d /data/persist/ ]]; then
    mkdir /data/persist/
fi

# wait for node warm up
sleep 30
damocles-manager daemon run --poster --miner
