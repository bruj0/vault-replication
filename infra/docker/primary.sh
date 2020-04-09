#!/bin/bash -e
# To enable debug: export DEBUG=true
# Enable debug if the env variable DEBUG is set to true
if [[ "$DEBUG" == "true" ]];then
    set -x
fi
VAULT_CLUSTER="primary"
STORAGE=${VAULT_STORAGE:-"raft"}
VAULT_VERSION="1.3.4"
COMPOSE_CMD="docker-compose --project-directory ./${STORAGE} --project-name ${VAULT_CLUSTER}  -f ${STORAGE}/vault-${VAULT_CLUSTER}.yml -f ${STORAGE}/vault.yml"
bold=$(tput bold)
normal=$(tput sgr0)
VAULT_ADDR=http://127.0.0.1:9201
#Internal variables
typeset -a VAULT_primary_PORTS=("9201" "9202" "9203")
typeset -a VAULT_secondary_PORTS=("9301" "9302" "9303")
typeset -a VAULT_dr_PORTS=("9401" "9402" "9403")
export VAULT_ADDR=http://127.0.0.1:9201
echo "# Using storage: ${STORAGE}"
case "$1" in
    "wipe")
         sudo rm -fr storage/raft/${VAULT_CLUSTER}
         mkdir -p storage/raft/${VAULT_CLUSTER}/{01,02,03,unsealer}
    ;;
    "restart")
        ${COMPOSE_CMD} restart vault01 vault02 vault03
    ;;
    "down")
         ${COMPOSE_CMD} down
    ;;
    "config")
        ${COMPOSE_CMD} config
    ;;
    "compose")
        ${COMPOSE_CMD} ${@:2}
    ;;
    "up")
        if [ "$3"=="recreate" ]; then
            RECREATE="--force-recreate"
        fi
        echo "Starting up ${VAULT_CLUSTER} Cluster with version $VAULT_VERSION"
        ${COMPOSE_CMD} up -d ${RECREATE}
    ;;
     *)
        echo "${bold}Usage: $0 <command> <subcommand>${normal}"
        echo ""
        echo "${bold}config${normal}: Will execute docker-compose config with the proper templates "
        echo "${bold}up${normal}: This will start the ${VAULT_CLUSTER} Vault cluster"
        echo "${bold}down${normal}: It will do a docker-compose down with the correct template"
        echo "${bold}restart${normal}: Restart the service"

    ;;    
esac