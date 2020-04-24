resource "google_container_cluster" "tfer--vault-002D-cluster1" {
  addons_config {
    horizontal_pod_autoscaling {
      disabled = "false"
    }

    http_load_balancing {
      disabled = "false"
    }

    network_policy_config {
      disabled = "true"
    }
  }

  cluster_autoscaling {
    enabled = "false"
  }

  #cluster_ipv4_cidr           = "10.60.0.0/14"
  default_max_pods_per_node   = "110"
  enable_binary_authorization = "false"
  enable_kubernetes_alpha     = "false"
  enable_legacy_abac          = "false"
  initial_node_count          = "3"

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "10.60.0.0/14"
    services_ipv4_cidr_block = "10.124.0.0/20"
  }

  location        = "europe-west4-a"
  logging_service = "logging.googleapis.com/kubernetes"

  master_auth {
    client_certificate_config {
      issue_client_certificate = "false"
    }
  }

  monitoring_service = "monitoring.googleapis.com/kubernetes"
  name               = "vault-cluster1"
  network            = "projects/rodrigo-support/global/networks/default"

  network_policy {
    enabled  = "false"
#    provider = "PROVIDER_UNSPECIFIED"
  }

  node_version = "1.14.10-gke.27"
  min_master_version = "1.14.10-gke.27"
  project      = "rodrigo-support"
  subnetwork   = "projects/rodrigo-support/regions/europe-west4/subnetworks/default"
}
