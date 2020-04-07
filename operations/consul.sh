#!/bin/bash -ex
# To enable debug: export DEBUG=true

export CONSUL_CLUSTER=$1
bold=$(tput bold)
normal=$(tput sgr0)
typeset -a p_PORT="8500"
typeset -a s_PORT="8502"
typeset -a dr_PORT="8503"
eval CONSUL_PORT=( \${${CONSUL_CLUSTER}_PORT} ) ;

#External variables used by other scripts
export CONSUL_HTTP_ADDR=http://127.0.0.1:${CONSUL_PORT}

case "$1" in
     *)
     consul ${@:2}
    ;;  
esac
