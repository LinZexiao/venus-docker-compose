#! /usr/bin/bash
set -e

if [[ -d ~/.lotus ]]; then
    echo " repo ~/.lotus already exists"
    ./lotus daemon  &
else
    echo " repo ~/.lotus not exists, init lotus."
        
    # as a genisis node, we need to rm all data remail from last time
    rm -rf ~/.lotus ~/.genesis-sectors ~/genesis.car 

    # seed
    ./lotus-seed pre-seal --sector-size 2KiB --num-sectors 2
    ./lotus-seed genesis new --network-name $NET_TYPE localnet.json
    ./lotus-seed genesis add-miner localnet.json ~/.genesis-sectors/pre-seal-t01000.json

    # lotus daemon
    ./lotus daemon --lotus-make-genesis=/root/genesis.car --genesis-template=localnet.json --bootstrap=false  &

    # echo bootstrap
    if [ -f /env/bootstrap ];then
        rm -f /env/bootstrap
    fi
    while [ -z "$bootstrap" ];do
        sleep 1
        bootstrap=`/app/lotus net listen | grep ip4 |awk 'NR==1'`
        echo "bootstrap: $bootstrap"
    done
    if [ -d /env ]; then
        echo "${bootstrap#*: }" > /env/bootstrap
    fi


    lotus wait-api
    lotus wallet import --as-default ~/.genesis-sectors/pre-seal-t01000.key
    cp ~/.genesis-sectors/pre-seal-t01000.key /env/init.key
fi

wait
