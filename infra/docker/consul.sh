#!/bin/bash -ex
# To enable debug: export DEBUG=true

export CONSUL_CLUSTER=$1
VAULT_VERSION=$(grep image config/consul.yaml | head -1 | awk -F ":" '{print $3}')
COMPOSE_CMD="docker-compose --project-directory ./config --project-name ${CONSUL_CLUSTER} -f config/consul-${CONSUL_CLUSTER}.yml -f config/consul.yml"
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
    "cli")
# Cli command
# $2 vault or consul or show
# $3 command
        export VAULT_TOKEN=$(cat ${VAULT_DATA}/init.json | jq -r '.root_token')
        case "$2" in
            "vault")
                vault ${@:3}
                ;;
            "yapi")
                 yapi ${@:3}
                ;;
            "vars")
                set +x
                echo "Exporting variables for ${CLUSTER}"
                echo "export VAULT_ADDR=\"${VAULT_ADDR}\""
                echo "export VAULT_DATA=\"${VAULT_DATA}\""
                echo "export VAULT_TOKEN=\"${VAULT_TOKEN}\""
                ;;
            *)
            echo "Cli not implemented: $2"
            exit 1   
            esac
    ;;    
     *)
        echo "${bold}Usage: $0 <primary|secondary|dr> [command] [subcommand]${normal}"
        echo "Commands:"
        echo "${bold}config${normal}: Will execute docker-compose config with the proper templates "
        echo "${bold}up${normal}: This will start the Primary Vault cluster"
        echo "${bold}down${normal}: It will do a docker-compose down with the correct template"
        echo "${bold}restart${normal}: Restart the service"
        echo "${bold}cli${normal}: Use the CLI with correct variables"
        echo "  ${bold}vars${normal}: Prints variables for the given cluster "
        echo "${bold}consul${normal} <command>"
    ;;    
esac