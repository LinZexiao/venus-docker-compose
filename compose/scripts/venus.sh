#!/bin/sh

echo "Arg: $@"
Args=" --auth-url=http://127.0.0.1:8989 "

if [ $nettype ]
then
    Args="$Args --network=$nettype"
fi

if [ $snapshot ]
then
    Args="$Args --import-snapshot=~/snapshot.car"
fi

Args="$Args --genesisfile=/root/genesis.car"

# wait lotus init
sleep 30

echo "EXEC: /app/venus daemon $Args \n\n"
/app/venus daemon $Args &

sleep 3
if [ -f /env/bootstrap ];
then
    bootstraper=$(cat /env/bootstrap )
    /app/venus swarm connect $bootstraper
    echo "connect to $bootstraper"
fi
wait
