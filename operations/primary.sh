#!/bin/bash -e
# To enable debug: export DEBUG=true
# Enable debug if the env variable DEBUG is set to true
if [[ "$DEBUG" == "true" ]];then
    set -x
fi
YAPI_PATH="./api/vault"
bold=$(tput bold)
normal=$(tput sgr0)
#Internal variables
typeset -a VAULT_primary_PORTS=("9201" "9202" "9203")
typeset -a VAULT_secondary_PORTS=("9301" "9302" "9303")
typeset -a VAULT_dr_PORTS=("9401" "9402" "9403")
export VAULT_ADDR=http://127.0.0.1:9301
export VAULT_DATA="./${STORAGE}/primary"
export VAULT_TOKEN=$(cat $VAULT_DATA/init.json | jq -r '.root_token')

echo "Using storage: ${bold}${STORAGE}${normal}"
case "$1" in
"help")
        echo "${bold}Usage: $0 <vault command>| <operation command>${normal}"
        echo ""
        echo "${bold}init${normal}"
        echo "${bold}init_unsealer${normal}"
        echo "${bold}unseal${normal}"
        echo "${bold}unseal_unsealer${normal}"
        echo "${bold}enable_replication${normal}"
        echo "${bold}vars${normal}: show Vault env vars"
        echo "${bold}yapi${normal}: runs yapi with correct variables"
;;
"enable_replication")
        set +e
        export SECONDARY_HAPROXY_ADDR=$(docker network inspect vault_secondary | jq -r '.[] .Containers | with_entries(select(.value.Name=="haproxy"))| .[] .IPv4Address' | awk -F "/" '{print $1}')
        echo "Enabling replication in primary"
        yapi ${YAPI_PATH}/03-replication_enable_primary.yaml 

        echo "Creating secondary JWT token id=secondary"
        yapi ${YAPI_PATH}/04-replication_secondary_token.yaml 
;;
    "yapi")
        yapi ${@}
;;
    "vars_unsealer")
        export VAULT_ADDR=http://127.0.0.1:9300
        export VAULT_TOKEN=$(cat $VAULT_DATA/unsealer_init.json | jq -r '.root_token')    
        echo "Exporting variables for Unsealer Vault"
        echo "export VAULT_ADDR=\"${VAULT_ADDR}\""
        echo "export VAULT_TOKEN=\"${VAULT_TOKEN}\""
;;

    "vars")
        echo "Exporting variables for Primary Vault"
        echo "export VAULT_ADDR=\"${VAULT_ADDR}\""
        echo "export VAULT_TOKEN=\"${VAULT_TOKEN}\""
;;
    "init_unsealer")
        # Initializaing and Unsealing
        if [ ! -f "$VAULT_DATA/unsealer_init.json" ]; then
            export VAULT_PREFIX="unsealer_"
            export VAULT_ADDR=http://127.0.0.1:9300
            echo "Initializing Vault cluster ${CLUSTER} at ${VAULT_ADDR}, files stored in ${VAULT_DATA}"
            yapi ${YAPI_PATH}/01-init.yaml 
        fi
;;
    "init")
        # Initializaing and Unsealing
        if [ ! -f "$VAULT_DATA/init.json" ]; then
            echo "Initializing Vault cluster ${CLUSTER} at ${VAULT_ADDR}, files stored in ${VAULT_DATA}"
            yapi ${YAPI_PATH}/01-init.yaml 
        fi    
;;
    "unseal")
        echo "Unsealing Vault"
        yapi ${YAPI_PATH}/02-unseal.yaml
;;
    "unseal_unsealer")
        export VAULT_PREFIX="unsealer_"
        export VAULT_ADDR=http://127.0.0.1:9300
        echo "Unsealing Vault Unsealer"
        yapi ${YAPI_PATH}/02-unseal.yaml
;;
    *)
        vault ${@:1}
;;    
esac
