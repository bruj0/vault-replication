#!/bin/bash -e
# To enable debug: export DEBUG=true
if [[ "$DEBUG" == "true" ]];then
    set -x
fi
STORAGE={$VAULT_STORAGE:-consul}
export CONSUL_CLUSTER=$1
VAULT_VERSION=$(grep image consul/consul.yml | head -1 | awk -F ":" '{print $3}')
COMPOSE_CMD="docker-compose --project-directory ./consul --project-name ${CONSUL_CLUSTER} -f consul/consul-${CONSUL_CLUSTER}.yml -f consul/consul.yml"
bold=$(tput bold)
normal=$(tput sgr0)
VAULT_ADDR=http://127.0.0.1:9201

#External variables used by other scripts

case "$2" in
    "config")
        ${COMPOSE_CMD} config
    ;;
    "down")
    ${COMPOSE_CMD} down
    ;;
    "up")
        
        echo "Starting up ${CONSUL_CLUSTER} Cluster with version $VAULT_VERSION"
        if [ "$1" == "recreate" ]; then
            RECREATE="--force-recreate"
            echo "* Forcing recreate"
        fi    
        ${COMPOSE_CMD} up -d ${RECREATE}
    ;;
     *)
        echo "${bold}Usage: $0 <primary|secondary|dr> [command] [subcommand]${normal}"
        echo "Commands:"
        echo "${bold}config${normal}: Will execute docker-compose config with the proper templates "
        echo "${bold}up${normal}: This will start the Primary Vault cluster"
        echo "${bold}down${normal}: It will do a docker-compose down with the correct template"
        echo "${bold}restart${normal}: Restart the service"
    ;;    
esac