storage "raft" {
  path    = "/vault/raft"
  node_id = "vault02"
  retry_join {
    leader_api_addr = "https://primary-vault02:8200"
    leader_ca_cert = "-----BEGIN CERTIFICATE-----\nMIIDITCCAgmgAwIBAgIUKZ4O3HQsR8907jBm5oe2gN36jmQwDQYJKoZIhvcNAQEL\nBQAwGDEWMBQGA1UEAxMNVmF1bHQgQ0Egcm9vdDAeFw0yMDA0MjQxNDA4NDZaFw0z\nMDA0MjIxNDA5MTZaMBgxFjAUBgNVBAMTDVZhdWx0IENBIHJvb3QwggEiMA0GCSqG\nSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCnTRr1eZK+qJVyEf5hVBZqO2/Zzulitt2U\nXeZUKJI+q9vWpuwg5iBX0JVxpZcakmANPHFWIrvbtRnOeTC0PgFQpc2oNzSHqrkv\npWsGv0/50TnUjlAQstmoO8sYYGZaH1ywYxMq8Biw6xyQiUHgs2krzTalyK86B3Vf\nU0ATkOfC5PRpG/f+k31EsUCpUrnx3RWQX58jmAK69rFcuRwXlSHlZsBVf6CoFW6L\nCnpM2F1BNlLlZdTv6g3M4oyPUnmkU/Q+ljrbnDr0phhO+1NLPFUdtqUpSwTsrssW\nAI/b3OY+b+fSKABy6+AtfhZVlv1o/LSAGnh/hhpLsBnno6RUxufLAgMBAAGjYzBh\nMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTK+frt\nCF84y45DpeYk6CDWPhWuYTAfBgNVHSMEGDAWgBTK+frtCF84y45DpeYk6CDWPhWu\nYTANBgkqhkiG9w0BAQsFAAOCAQEAA99qO/VpeGAhaD73SNHDcNpyeE/mdOikSV4S\n7prbCHVoM60pffKPTxd8Owp4vcHD4VftgEf5bJktjvDLn99mntsEdhvNqxirl2Jt\nqizh2uSqGFaNyG5Lu1SKpXMwTXTHHYGddvY+ZntmG8WmB7izvk+Wl5c+EeFw1uzS\nNpcO+7Iv1JhUsdWZ3L52VOBl8MjNTFARygVNGCCn4kSz0eKMfhjuYpzFcgl+N8ML\n02W6fpnbr190WU+/qJN6mmc4+2X/C70cozDfd/OfBEUWJ9B18w6+FDz7YjrFXvcy\nQWJXTFCPuCqCdWerfCZ3kdvsKO1ragauWi1/Hcp2ZrS6lfihhw==\n-----END CERTIFICATE-----"
    leader_client_cert = "-----BEGIN CERTIFICATE-----\nMIIDvzCCAqegAwIBAgIUT5CQ9gbLYcp9EhtLdqdFPF4c8S4wDQYJKoZIhvcNAQEL\nBQAwGDEWMBQGA1UEAxMNVmF1bHQgQ0Egcm9vdDAeFw0yMDA0MjgxMjU3NThaFw0y\nMDA1MzAxMjU4MjhaMBoxGDAWBgNVBAMTD3ByaW1hcnktdmF1bHQwMTCCASIwDQYJ\nKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMhuBj+dEEMoLWJqeyh/GRfKanXVBnLw\n17LqgNYMTBfSOi+BpGRdRwj3IU0VYtbmtV6s4HnETtK1w2FTTRmcMz0LgWh7XKXU\nX1GPG5+XT3q4S4CxhFRqytgkpKz9shHRVKSkgwx0MIKsvYL/2prI4MKKKrO8Qqgp\nEepkZbigyG7b9pl9gf9jPhd5qvBow/VbhK1ojJ6CzVurKM+xeLD/esCpvxcsfvXt\nnp2o5oNJQVpTDtzckDOwDLqnkUWS4kHKoZGzZT+/AxyPaWbnx/KR9Yq+oyex7Wr9\nMrg4lFA5bsvfdO+5Z4MsCW0/IZtfyzw7KhBUrtWiHV734mUXvhO/uoUCAwEAAaOB\n/jCB+zAOBgNVHQ8BAf8EBAMCA6gwHQYDVR0lBBYwFAYIKwYBBQUHAwEGCCsGAQUF\nBwMCMB0GA1UdDgQWBBQiVNZ7h96HmZ0rwp4Y8AiaudZMcjAfBgNVHSMEGDAWgBTK\n+frtCF84y45DpeYk6CDWPhWuYTA7BggrBgEFBQcBAQQvMC0wKwYIKwYBBQUHMAKG\nH2h0dHA6Ly8xMjcuMC4wLjE6ODIwMC92MS9wa2kvY2EwGgYDVR0RBBMwEYIPcHJp\nbWFyeS12YXVsdDAxMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly8xMjcuMC4wLjE6\nODIwMC92MS9wa2kvY3JsMA0GCSqGSIb3DQEBCwUAA4IBAQB91xrffiAsYkbF4++z\nJHKuoC3Pgnv0oUFWEErhz0dJ/LddrKhKnJO54koYYG5oL3gtvtTdiMN42ymbR7wF\nDIbK/v9eeTPZvtN2nlgfrOi0ArS7Y2wrx2Zpsgc9oVRhZstOdl99gNKEmVNoTJjN\nydM7yKfJwvvb3YJ0BVsw8gRZwLKmS91D4t15R90zYU/IJpwre+BuId9JEmlvga63\nwz2Doz7hqhA6d4imGJ7c1zUEEROW+Pmd8fNN27l7L5lQ0grH+74YTUewtTmDZ2jk\nYXoTMZ8ALmyVQkAaO+08AUKqLxTXNBV6c2f4ci9wWY3JsjAQ30nBGsUArB0qEm+z\ncxOc\n-----END CERTIFICATE-----"
    leader_client_key = "-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQEAyG4GP50QQygtYmp7KH8ZF8pqddUGcvDXsuqA1gxMF9I6L4Gk\nZF1HCPchTRVi1ua1XqzgecRO0rXDYVNNGZwzPQuBaHtcpdRfUY8bn5dPerhLgLGE\nVGrK2CSkrP2yEdFUpKSDDHQwgqy9gv/amsjgwooqs7xCqCkR6mRluKDIbtv2mX2B\n/2M+F3mq8GjD9VuErWiMnoLNW6soz7F4sP96wKm/Fyx+9e2enajmg0lBWlMO3NyQ\nM7AMuqeRRZLiQcqhkbNlP78DHI9pZufH8pH1ir6jJ7Htav0yuDiUUDluy99077ln\ngywJbT8hm1/LPDsqEFSu1aIdXvfiZRe+E7+6hQIDAQABAoIBAQClChwxE5cJhbLh\nYEbrkMTL10yUnIZD7VfgJsNR/ixGTUDGT51bW4ebtUuBmsOZq73bKMVq3x/819j7\nckmBdiKm+KtlqnceweJ/WTTo1AKJTeo2HXaWwJ0pH/tNy1Vu4I0vSZvzjFVJtQ4U\nKbQLUq/o4TbKa5IDwFXVSTiNsC97QEXA6xcyWqfLfVkCOhwY2AA3+uVd/ZWYUaC7\noMq3V+QOzSoeVCV1R8+564s/qb3w5qDafIfCzSRlu8CTOuYkcqO+8KliBQ3lgveQ\nrqgHYGUiBHMQJCOP8wkO2mYahRYZJ4QZtVMcF/XMn+Eh4oxIxEY2lHYJi1Mnakwl\njRkp2efBAoGBANiGayHM9H4XlYdIXmJIA+ygW9wI+Q+ZqSfFUPZlz2K7Qcy/Odk2\no4hCEsya2RcQlCfmQNQAUgl76OwXtR2PCgwG+aIDL30fLuriUhMoNz+gJcCl2Vg+\nIzNK4SfeNXfnunGaYU6it8Ea1WaslI3TBS5ULiGNTnJm5IRIHnuxU9jxAoGBAOz4\naYr3Eu7ISwB2zJeBYrB+9lcLj0ZFZW8nG5gLH99xbl/5vAJanWhdiOX7LlZOwKKG\nFBbeHKHpfi4YYlBDr7WgViaFecrZKc1p+cYMXM4R6AyYpgnswUmFc7/HxfW2rUwA\nuNCgYRIQayeNlJXo/NWuRsdHx5H3M13i3ZIuL9rVAoGBAJlGpmYaCWWNWmuW3kGi\niyyh5AUiUPUrKKSfuI2ESsewmYbQQ6oxVJhrdZVjdJQwR0DrbS7mPyy5i4w9yBdx\nn4IeGe8HZEGlpnfd2I35JQskWjVC8lXWPuLbegHX+m+0Gba7u3CIHZ5UWYbCWrL/\nE6bVLobP2h2AGvpNd07Gm/1xAoGAKbzLIh3IaORASZGjEWBJmJqUGtq/XnokloJF\n2u7Cq2FYNnFPCv8Y0GQBE7i8/ZibV0TUTv7J/j6Y6deDoW16ijv2UIyb2f2L3lE3\nHAnbYrRGsclFHWRk2uU1cObn2BJXzZYm9x/4WO0pYmsOa6UAu0YZ00myPeRTWMr3\niaK27Q0CgYA3MJ5zvFd8R/E1QputtG+DCBcw9Jk7Fzg0WQ3HbeMjehHMtu2cx5oZ\nzenw0E5NMz5nf5zwPOy2WU0LlXsOw6vx+hgr9qS+YY8fQ5ONPr84/dhoBGolDC9U\nv1kfHmad8Hgvvl1/z8aag2XQh7jCoI9iYrc0iBKmVK0W2UYc6bDvsw==\n-----END RSA PRIVATE KEY-----"
  }   
}
listener "tcp" {
  address = "primary-vault02:8200"
  cluster_address = "primary-vault02:8201"
  tls_cert_file = "/vault/config/ssl/vault02.pem"
  tls_key_file = "/vault/config/ssl/vault02.key"
telemetry {
  prometheus_retention_time = "30s"
#  disable_hostname         = true
#  unauthenticated_metrics_access = true
}  
}
seal "transit" {
  address            = "https://primary-unsealer:8200"
  # token is read from VAULT_TOKEN env
  # token              = ""
  disable_renewal    = ""
  //empty=false
  // Key configuration
  key_name           = "autounseal"
  mount_path         = "transit/"
  tls_ca_cert        = "/vault/config/ssl/ca.pem"
}
ui = "true"
cluster_addr = "https://primary-vault02:8201"
cluster_name = "Primary"
raw_storage_endpoint = true
log_level = "debug"