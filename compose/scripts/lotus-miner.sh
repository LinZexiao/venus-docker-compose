#! /usr/bin/bash
set -e

echo Wait for lotus is ready ...
lotus wait-api
echo Lotus ready. Lets go

if [[ -z $LOTUS_MINER_PATH ]]; then
    echo "LOTUS_MINER_PATH is empty"
    exit 1
else
    echo "LOTUS_MINER_PATH is $LOTUS_MINER_PATH"
fi

if [[ -d $LOTUS_MINER_PATH ]]; then
    echo " repo $LOTUS_MINER_PATH already exists"
else
    # lotus miner
    ./lotus-miner init --owner=t3u6wphbih2taqrgj4a2vz3bouud3pczca6frzfu2v2s2jvwwltiwu4mhseo73m7exb4tjphpttodsx54gm55q --sector-size=2KiB --nosync
fi

./lotus-miner run --nosync
