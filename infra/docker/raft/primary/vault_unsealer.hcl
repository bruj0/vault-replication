storage "file" {
  path    = "/vault/raft"
}
listener "tcp" {
  address = "primary-unsealer:8200"
  tls_cert_file = "/vault/config/ssl/vault_unsealer.pem"
  tls_key_file = "/vault/config/ssl/vault_unsealer.key"
}
ui = "true"
telemetry {
  prometheus_retention_time = "30s"
  disable_hostname          = true
}
disable_clustering = "true"
raw_storage_endpoint = true
log_level = "debug"