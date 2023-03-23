#!/bin/sh

echo "Arg: $@"
token=$(cat /env/token )
echo "token:"
echo ${token}


/app/venus-market run \
--node-url=/dns/node/tcp/3453  \
--auth-url=http://auth:8989 \
--gateway-url=/dns/gateway/tcp/45132/ \
--messager-url=/dns/messager/tcp/39812/ \
--cs-token=${token} \
--signer-type="gateway" &

sleep 3
exist=$(/app/venus-market  piece-storage list | grep DefaultPieceStorage )
if [ -z "$exist" ]; then
    echo "add piece storage"
    /app/venus-market piece-storage add-fs --name DefaultPieceStorage --path /root/data/pieces
fi

pkill venus-market

/compose/bin/toml set ~/.venusmarket/config.toml API.ListenAddress "/ip4/0.0.0.0/tcp/41235" > ~/.venusmarket/config.toml.tmp
mv -f ~/.venusmarket/config.toml.tmp ~/.venusmarket/config.toml
/app/venus-market run
