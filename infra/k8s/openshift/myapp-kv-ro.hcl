path "secret/database/*" {
    capabilities = ["read", "list"]
}
path "secret-v1/database/*" {
    capabilities = ["read", "list"]
}

# If working with K/V v2
path "secret/data/database/*" {
    capabilities = ["read", "list"]
}
