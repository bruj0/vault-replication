#!/bin/bash -ex
# To enable debug: export DEBUG=true

bold=$(tput bold)
normal=$(tput sgr0)
#Internal variables
typeset -a VAULT_primary_PORTS=("9201" "9202" "9203")
typeset -a VAULT_secondary_PORTS=("9301" "9302" "9303")
typeset -a VAULT_dr_PORTS=("9401" "9402" "9403")
export VAULT_ADDR=http://127.0.0.1:9301
export VAULT_DATA="./data/secondary"
export VAULT_TOKEN=$(cat $VAULT_DATA/init.json | jq -r '.root_token')
export SECONDARY_HAPROXY_ADDR=$(docker network inspect vault_secondary | jq -r '.[] .Containers | with_entries(select(.value.Name=="haproxy"))| .[] .IPv4Address' | awk -F "/" '{print $1}')
export VAULT_DATA_PRIMARY="./data/primary"

case "$1" in
"activate_replication")
        echo "Enabling secondary replication to primary"
        yapi vault/05-replication_activate_secondary.yaml 
;;
"generate_root")
        echo "Creating a root token for secondary with the new unseal keys"
        yapi vault/06-replication_generate_root_secondary.yaml 
;;
    "yapi")
        yapi ${@}
    ;;
    "vars")
        echo "Exporting variables for Secondary Vault"
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
