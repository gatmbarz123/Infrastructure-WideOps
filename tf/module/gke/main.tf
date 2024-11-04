resource "google_container_cluster" "gke" {
  name     = "gke"
  location = "${var.region}-a"
  project  = var.project_name

  networking_mode = "VPC_NATIVE"
  network         = var.vpc_name
  subnetwork      = var.subnet_name

  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-secondary-01"
    services_secondary_range_name = "service-secondary-02"
  }

  network_policy {
    provider = "PROVIDER_UNSPECIFIED"
    enabled  = true
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
}


resource "google_container_node_pool" "general" {
  name       = "general"
  location   = "${var.region}-a"
  cluster    = google_container_cluster.gke.name
  project    = var.project_name
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    labels = {
      role = "general"
    }
    machine_type = "e2-medium"
    disk_size_gb = 20

    service_account = var.service_account
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}