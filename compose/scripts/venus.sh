#!/bin/bash
set -e

if [[ -d ~/.venus ]];then
    /app/venus daemon
else

Args=" --auth-url=http://auth:8989 "

while [ ! -f /env/token ] ; do
    echo "wait token ..."
    sleep 5
done
token=$(cat /env/token )
Args="$Args --auth-token=$token"

if [ $nettype ]
then
    Args="$Args --network=$nettype"
fi

if [ $snapshot ]
then
    Args="$Args --import-snapshot=~/snapshot.car"
fi

Args="$Args --genesisfile=/root/genesis.car"

# wait genesis
sleep 30

echo "EXEC: /app/venus daemon $Args \n\n"
/app/venus daemon $Args &

echo "wait to restart ..."
sleep 20
echo "restart ..."
if [ -f /env/bootstrap ];
then
    bootstraper=$(cat /env/bootstrap )
    /app/venus swarm connect $bootstraper
    echo "connect to $bootstraper"
fi

pkill venus
jq '.api.apiAddress="/ip4/0.0.0.0/tcp/3453" ' ~/.venus/config.json | jq --arg bp $bootstraper '.bootstrap.addresses +=[ $bp ]' > ~/.venus/config.json.tmp
mv -f ~/.venus/config.json.tmp ~/.venus/config.json 

/app/venus daemon $Args

fi
