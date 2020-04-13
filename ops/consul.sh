#!/bin/bash -e
# To enable debug: export DEBUG=true
# Enable debug if the env variable DEBUG is set to true
if [[ "$DEBUG" == "true" ]];then
    set -x
fi
export CONSUL_CLUSTER=$1
bold=$(tput bold)
normal=$(tput sgr0)
typeset -a p_PORT="8500"
typeset -a s_PORT="8502"
typeset -a dr_PORT="8503"
eval CONSUL_PORT=( \${${CONSUL_CLUSTER}_PORT} ) ;

#External variables used by other scripts
export CONSUL_HTTP_ADDR=http://127.0.0.1:${CONSUL_PORT}

if [ "$1" == "help" ]; then
    echo "${bold}Usage: $0 <p|s|dr> <consul command>| <operation command>${normal}"
    echo "${bold}stats${normal}"
    echo "${bold}wipe${normal}"
    echo "${bold}vars${normal}"
    exit 0
fi
case "$2" in

"vars")
    echo "export CONSUL_HTTP_ADDR=http://127.0.0.1:${CONSUL_PORT}"
;;
"stats")
    consul kv get -recurse -keys -separator=" " vault/${@:3} | awk -F"/" '{print $3}' | sort | uniq -c | sort -nr 
;;
"wipe")
    echo "export CONSUL_HTTP_ADDR=http://127.0.0.1:${CONSUL_PORT}" 
    echo consul kv delete -recurse vault/
;;
*)
     consul ${@:2}
;;  
esac
