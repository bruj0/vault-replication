vault secrets enable -version=2 -ns myns_vault -path=secret kv
vault kv put -ns myns_vault secret/database/config username=user password=mypass
vault auth enable -ns myns_vault kubernetes
