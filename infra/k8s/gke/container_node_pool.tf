resource "google_container_node_pool" "tfer--vault-002D-cluster1_default-002D-pool" {
  cluster            = google_container_cluster.tfer--vault-002D-cluster1.name
  initial_node_count = "3"
  location           = "europe-west4-a"

  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  max_pods_per_node = "110"
  name              = "default-pool"

  node_config {
    disk_size_gb    = "100"
    disk_type       = "pd-standard"
    image_type      = "COS"
    local_ssd_count = "0"
    machine_type    = "n1-standard-4"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]
    preemptible     = "true"
    service_account = "default"

    shielded_instance_config {
      enable_integrity_monitoring = "true"
      enable_secure_boot          = "false"
    }
  }

  #node_count = "3"
  project    = "rodrigo-support"

  upgrade_settings {
    max_surge       = "1"
    max_unavailable = "0"
  }

  version = "1.14.10-gke.27"
}
