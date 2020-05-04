 export VAULT_TOKEN=(cat root.json | jq -r .root_token
kubectl -n vault create secret generic kms-creds --from-file=credentials.json
 vault operator raft join http://vault-0.vault-internal:8200
 vault operator unseal
 vault secrets enable -path=secret -version=2 kv
    vault kv put secret/database/config username='appuser' \
            password='suP3rsec(et!'
vault auth enable kubernetes          
export VAULT_SA_NAME=(kubectl get sa vault -o jsonpath="{.secrets[*]['name']}")
export SA_JWT_TOKEN=(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data.token}" | base64 --decode; echo)
export SA_CA_CRT=(kubectl get secret $VAULT_SA_NAME -o jsonpath="{.data['ca\.crt']}" | base64 --decode; echo)


k -n vault exec -ti vault-0 -- env |grep KUB
    export K8S_HOST="10.65.0.1"
vault write auth/kubernetes/config \
        token_reviewer_jwt="$SA_JWT_TOKEN" \
        kubernetes_host="https://$K8S_HOST:443" \
        kubernetes_ca_cert="$SA_CA_CRT"

vault write auth/kubernetes/role/internal-app \
        bound_service_account_names=default \
        bound_service_account_namespaces=myapp \
        policies=myapp-kv-ro \
        ttl=24h

kubectl run --generator=run-pod/v1 tmp --rm -i --tty \
      --serviceaccount=default --image alpine:3.7        

apk update ; apk add curl jq
export VAULT_ADDR=http://vault-0.vault-internal.vault:8200
export KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
curl --request POST \
            --data '{"jwt": "'"$KUBE_TOKEN"'", "role": "internal-app"}' \
            $VAULT_ADDR/v1/auth/kubernetes/login | jq
