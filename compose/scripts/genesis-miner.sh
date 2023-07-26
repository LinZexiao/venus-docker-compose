#! /usr/bin/bash
set -e

echo Wait for lotus is ready ...
lotus wait-api
echo Lotus ready. Lets go

if [[ -d ~/.lotus-miner ]]; then
    echo " repo ~/.lotus-miner already exists"
else
    # lotus miner
    ./lotus-miner init --genesis-miner --actor=t01000 --sector-size=2KiB --pre-sealed-sectors=~/.genesis-sectors --pre-sealed-metadata=~/.genesis-sectors/pre-seal-t01000.json --nosync
fi

./lotus-miner run --nosync
