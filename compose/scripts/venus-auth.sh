#!/bin/sh

echo "Arg: $@"
/app/venus-auth run  &

# wait genesis
sleep 30

# if /env/token is not exist
if [ ! -f /env/token ]; then
    echo "regist admin"
    /app/venus-auth user add admin
    token=`/app/venus-auth token gen --perm admin admin`

    echo "token: ${token#*: }"
    echo "${token#*: }" > /env/token
    /app/venus-auth  user active admin

fi

wait
