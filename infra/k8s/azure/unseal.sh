#!/bin/bash -x
UNSEAL=$( cat $2 |grep -Po '1\: \K.*' )
TOKEN=$( cat $2 |grep -Po 'Token\: \K.*' )
kubectl port-forward pod/vault-$1 10200:8200 &
sleep 2
KPID=$!
export VAULT_ADDR="HTTP://127.0.0.1:10200"
export VAULT_TOKEN=$TOKEN

vault operator unseal $UNSEAL

kill -TERM $KPID

