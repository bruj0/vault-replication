storage "raft" {
  path    = "/vault/raft"
  node_id = "vault_unsealer"
}
listener "tcp" {
  address = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"
  tls_disable = true
}
ui = "true"
cluster_addr = "http://0.0.0.0:8201"
cluster_name = "Unsealer"
telemetry {
  prometheus_retention_time = "30s"
  disable_hostname          = true
}
raw_storage_endpoint = true
log_level = "debug"