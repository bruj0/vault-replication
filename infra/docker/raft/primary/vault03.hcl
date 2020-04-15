storage "raft" {
  path    = "/vault/raft"
  node_id = "vault03"
}
listener "tcp" {
  address = "primary_vault03_1:8200"
  cluster_address = "primary_vault03_1:8201"
  tls_disable = true
telemetry {
  prometheus_retention_time = "30s"
#  disable_hostname          = true
#  unauthenticated_metrics_access = true
}  
}
seal "transit" {
  address            = "http://primary_vault_unsealer_1:8200"
  # token is read from VAULT_TOKEN env
  #token              = "autounseal"
  disable_renewal    = ""
  //empty=false
  // Key configuration
  key_name           = "autounseal"
  mount_path         = "transit/"
}
ui = "true"
cluster_addr = "http://primary_vault03_1:8201"
cluster_name = "Primary"

raw_storage_endpoint = true
log_level = "debug"