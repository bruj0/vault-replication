az aks get-credentials --resource-group rodrigo2-aks-resources  --name rodrigo2-aks-aks
az aks update --resource-group rodrigo-aks-resources  --name rodrigo-aks-aks --attach-acr /subscriptions/eb936495-7356-4a35-af3e-ea68af201f0c/resourceGroups/rodrigo-emea-support-rg/providers/Microsoft.ContainerRegistry/registries/vault

helm template vault vault-helm/ --values values-ha-raft.yaml  --output-dir .

kubectl get pod -o=custom-columns=NODE:.spec.nodeName,NAME:.metadata.name
kubectl get pods -o=wide


kubectl port-forward pod/vault-0 8200:8200 &
kubectl port-forward svc/vault-active 8200:8200 &

vault operator init -key-shares=1 -key-threshold=1
vault operator unseal
WK4SjGmJ7YDg7EbtbsSXrC4NphUrOHbKRwyg8wpZfPM=

export VAULT_SKIP_VERIFY=true
export VAULT_TOKEN=s.OU1RDvAnKQczJttYE9A1j1B8
export VAULT_ADDR="http://127.0.0.1:8200"

kubectl get pods --selector=vault-active=false
kubectl get pods --show-labels
