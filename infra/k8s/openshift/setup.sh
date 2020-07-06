vault secrets enable -version=2 -ns myns_vault -path=secret kv
vault policy write -ns myns_vault  myapp-kv-ro myapp-kv-ro.hcl
vault kv put -ns myns_vault secret/database/config username=user password=mypass
oc apply -n myapp -f internal-app-sc.yaml
oc apply -n openshift-config -f vault-auth.yaml
vault auth enable -ns myns_vault kubernetes
