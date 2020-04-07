#!/bin/bash -ex
# To enable debug: export DEBUG=true

bold=$(tput bold)
normal=$(tput sgr0)
#Internal variables
typeset -a VAULT_primary_PORTS=("9201" "9202" "9203")
typeset -a VAULT_secondary_PORTS=("9301" "9302" "9303")
typeset -a VAULT_dr_PORTS=("9401" "9402" "9403")
export VAULT_ADDR=http://127.0.0.1:9201
export VAULT_DATA="./data/primary"
export VAULT_TOKEN=$(cat $VAULT_DATA/init.json | jq -r '.root_token')

case "$1" in

"yapi")
    yapi ${@}
;;
"vars")
    echo "Exporting variables for Primary Vault"
    echo "export VAULT_ADDR=\"${VAULT_ADDR}\""
    echo "export VAULT_TOKEN=\"${VAULT_TOKEN}\""
;;
"init")
    # Initializaing and Unsealing
    if [ ! -f "$VAULT_DATA/init.json" ]; then
        echo "Initializing Vault cluster ${CLUSTER} at ${VAULT_ADDR}, files stored in ${VAULT_DATA}"
        yapi vault/01-init.yaml 
    fi    
;;
"unseal")
    echo "Unsealing Vault"
    yapi vault/02-unseal.yaml
;;
*)
    vault ${@:1}
;;    
esac
