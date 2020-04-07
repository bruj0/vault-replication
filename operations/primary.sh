#!/bin/bash -e
# To enable debug: export DEBUG=true
# Enable debug if the env variable DEBUG is set to true
if [[ "$DEBUG" == "true" ]];then
    set -x
fi
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
"help")
        echo "${bold}Usage: $0 <vault command>| <operation command>${normal}"
        echo ""
        echo "${bold}init${normal}"
        echo "${bold}unseal${normal}"
        echo "${bold}enable_replication${normal}"
        echo "${bold}vars${normal}: show Vault env vars"
        echo "${bold}yapi${normal}: runs yapi with correct variables"
;;
"enable_replication")
        set +e
        export SECONDARY_HAPROXY_ADDR=$(docker network inspect vault_secondary | jq -r '.[] .Containers | with_entries(select(.value.Name=="haproxy"))| .[] .IPv4Address' | awk -F "/" '{print $1}')
        echo "Enabling replication in primary"
        yapi vault/03-replication_enable_primary.yaml 

        echo "Creating secondary JWT token id=secondary"
        yapi vault/04-replication_secondary_token.yaml 
;;
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
