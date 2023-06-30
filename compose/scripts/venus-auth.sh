#!/bin/bash
set -e
# make alias work
shopt -s expand_aliases

alias auth=/app/sophon-auth
# check AUTH_BIN is set
if [[ ! -z $AUTH_BIN ]]; then
    if [[ ! -f $AUTH_BIN ]]; then
        echo "$AUTH_BIN not exists"
    else
        alias auth=$AUTH_BIN
    fi
fi

auth --version

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
auth --listen 0.0.0.0:8989 run  &

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
