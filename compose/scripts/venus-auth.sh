#!/bin/bash
set -e

# make alias work
shopt -s expand_aliases
alias auth=/app/venus-auth
# check VENUS_WORKER_BIN is set
if [[ ! -z $AUTH_BIN ]]; then
    if [[ ! -f $AUTH_BIN ]]; then
        echo "$AUTH_BIN not exists"
    else
        alias auth=$AUTH_BIN
    fi
fi


echo "Arg: $@"
auth run  &

# wait genesis
sleep 30

# if /env/token is not exist
if [ ! -f /env/token ]; then
    echo "regist admin"
    auth user add admin
    token=`auth token gen --perm admin admin`

    echo "token: ${token#*: }"
    echo "${token#*: }" > /env/token
    auth  user active admin

fi

wait
