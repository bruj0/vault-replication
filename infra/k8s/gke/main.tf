module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "rodrigo-support"
  name                       = "vault-cluster"
  region                     = "europe-west4"
  zones                      = ["europe-west4-a"]
  network                    = "gke"
  subnetwork                 = "gke-01"
  ip_range_pods              = "pods"
  ip_range_services          = "services"
  http_load_balancing        = false
  horizontal_pod_autoscaling = false
  network_policy             = false
  grant_registry_access      = true
  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-4"
      min_count          = 1
      max_count          = 10
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = true
      initial_node_count = 3
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
