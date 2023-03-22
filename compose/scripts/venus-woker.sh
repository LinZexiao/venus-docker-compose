alias venus-worker=/app/venus-worker

if [[ -f /env/token ]];
then
    echo "token exists"
    token=$(cat /env/token )
    echo "token: ${token}"
else
    echo "token not exists"
    echo "please create token file in /env/token"
fi

sed "s/<TOKEN>/$token/g" /compose/config/venus-worker.toml > /app/config.toml
echo "venus-worker config:"
cat /app/config.toml

if [[ ! -d /root/venus-worker-data/store/ ]]; then
    venus-worker store sealing-init -l /root/data/store/store1
fi

if [[ ! -d /root/data/pieces/ ]]; then
    mkdir /root/data/pieces/
fi

venus-worker daemon -c /app/config.toml
