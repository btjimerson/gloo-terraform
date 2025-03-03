data "google_client_config" "default" {}

provider "google" {
  project = var.project_id
  region  = var.region
}

# VPCs
resource "google_compute_network" "vpc" {
  count                   = length(var.vpcs)
  auto_create_subnetworks = false
  name                    = "${var.resource_prefix}-${var.vpcs[count.index].name}-vpc"
  project                 = var.project_id
}

# Subnets
resource "google_compute_subnetwork" "subnet" {
  count         = length(var.vpcs)
  ip_cidr_range = var.subnet_cidr
  name          = "${var.resource_prefix}-${var.vpcs[count.index].name}-subnet"
  network       = google_compute_network.vpc[count.index].name
  project       = var.project_id
  region        = var.region
}

# GKE clusters
resource "google_container_cluster" "cluster" {
  count                    = length(var.vpcs)
  deletion_protection      = false
  initial_node_count       = 1
  location                 = var.region
  name                     = "${var.resource_prefix}-${var.vpcs[count.index].name}-cluster"
  network                  = google_compute_network.vpc[count.index].name
  provider                 = google
  remove_default_node_pool = true
  subnetwork               = google_compute_subnetwork.subnet[count.index].name
}

# Default node pools
resource "google_container_node_pool" "primary_node_pool" {
  count    = length(var.vpcs)
  cluster  = google_container_cluster.cluster[count.index].name
  location = var.region
  name     = "${google_container_cluster.cluster[count.index].name}-node-pool"
  node_config {
    disk_size_gb = var.node_pool_disk_size
    disk_type    = var.node_pool_disk_type
    labels = {
      "created-by" = var.created_by_tag
      "team"       = var.team_tag
    }
    machine_type = var.node_pool_machine_type
    metadata = {
      disable-legacy-endpoints = true
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  node_count = var.node_pool_size
  provider   = google
}

