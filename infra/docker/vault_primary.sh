#!/bin/bash -ex
# To enable debug: export DEBUG=true

VAULT_VERSION="1.3.4"
COMPOSE_CMD="docker-compose --project-directory ./config --project-name primary -f config/vault-primary.yml -f config/vault.yml"
bold=$(tput bold)
normal=$(tput sgr0)
VAULT_ADDR=http://127.0.0.1:9201
#Internal variables
typeset -a VAULT_primary_PORTS=("9201" "9202" "9203")
typeset -a VAULT_secondary_PORTS=("9301" "9302" "9303")
typeset -a VAULT_dr_PORTS=("9401" "9402" "9403")
export VAULT_ADDR=http://127.0.0.1:9201

case "$1" in

    "config")
        ${COMPOSE_CMD} config
    ;;
    "up")
        echo "Starting up Primary Cluster with version $VAULT_VERSION"
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
        export VAULT_TOKEN=$(cat config/primary/init.json | jq -r '.root_token')
        case "$2" in
            "vault")
                vault ${@:3}
                ;;
            "yapi")
                 yapi ${@:3}
                ;;
            "vars")
                set +x
                echo "Exporting variables for Primary Vault"
                echo "export VAULT_ADDR=\"${VAULT_ADDR}\""
                echo "export VAULT_TOKEN=\"${VAULT_TOKEN}\""
                ;;
            *)
            echo "Cli not implemented: $2"
            exit 1   
            esac
    ;;        
     *)
        echo "${bold}Usage: $0 <command> <subcommand>${normal}"
        echo ""
        echo "${bold}config${normal}: Will execute docker-compose config with the proper templates "
        echo "${bold}up${normal}: This will start the Primary Vault cluster"
        echo "${bold}down${normal}: It will do a docker-compose down with the correct template"
        echo "${bold}restart${normal}: Restart the service"
        echo "  ${bold}vault | consul | proxy${normal}"
        echo "${bold}cli${normal}: Set VAULT_TOKEN and VAULT_ADDR"
        echo "  ${bold}vars${normal}: Prints variables for the given cluster "
        echo "${bold}vault${normal} <command>"
        echo "${bold}unseal${normal}"
    ;;    
esac