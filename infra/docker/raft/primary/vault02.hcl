storage "raft" {
  path    = "/vault/raft"
  node_id = "vault02"
}
listener "tcp" {
  address = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable = true
}
seal "transit" {
  address            = "http://0.0.0.0:8200"
  # token is read from VAULT_TOKEN env
  # token              = ""
  disable_renewal    = "false"
  // Key configuration
  key_name           = "unseal_key"
  mount_path         = "transit/"
}
ui = "true"
cluster_addr = "http://0.0.0.0:8201"
cluster_name = "Primary"
telemetry {
  prometheus_retention_time = "30s"
  disable_hostname          = true
}
raw_storage_endpoint = true
log_level = "debug"