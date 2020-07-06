#!/bin/bash -x
export VAULT_ADDR="http://vault.oc.b0x.dev:8200"
TOKEN_REVIEW_JWT=$(kubectl -n openshift-config get secret vault-auth -o go-template='{{ .data.token }}' | base64 --decode)
VAULT_INJECTOR_POD=$(kubectl get pods --selector="app.kubernetes.io/name=vault-agent-injector" -o jsonpath='{.items[].metadata.name}')
KUBE_CA_CERT=$(kubectl exec -ti $VAULT_INJECTOR_POD -- cat /run/secrets/kubernetes.io/serviceaccount/ca.crt )
KUBE_HOST=$(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.server}')

vault write myns_vault/auth/kubernetes/config \
        token_reviewer_jwt="$TOKEN_REVIEW_JWT" \
        kubernetes_host="$KUBE_HOST" \
        kubernetes_ca_cert="$KUBE_CA_CERT"
        
vault write myns_vault/auth/kubernetes/role/myapp-role \
        bound_service_account_names=internal-app \
        bound_service_account_namespaces=vaultapp \
        policies=myapp-kv-ro \
        ttl=24h
