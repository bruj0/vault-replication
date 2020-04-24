storage "file" {
  path    = "/vault/raft"
}
listener "tcp" {
  address = "primary_vault_pki_1:8200"
  tls_disable = "true"
telemetry {
  prometheus_retention_time = "30s"
#  disable_hostname          = true
#  unauthenticated_metrics_access = true
}  
}
ui = "true"
disable_clustering = "true"

raw_storage_endpoint = true
log_level = "debug"