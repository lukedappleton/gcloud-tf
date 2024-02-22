data "google_container_engine_versions" "gke_version" {
    location       = var.region
    version_prefix = var.k8s_version
}

resource "google_project_service" "kubernetes_api" {
  project = var.project_id
  service = "container.googleapis.com"
}

resource "google_container_cluster" "primary" {
    name                       = var.cluster_name
    location                   = var.zone
    project                    = var.project_id
    remove_default_node_pool   = true
    initial_node_count         = 1
    network                    = google_compute_network.vpc.self_link
    subnetwork                 = google_compute_subnetwork.subnet.self_link
    logging_service            = "logging.googleapis.com/kubernetes"
    monitoring_service         = "monitoring.googleapis.com/kubernetes"
    min_master_version         = data.google_container_engine_versions.gke_version.version_prefix
    node_config                {
        disk_size_gb = var.disk_size
    }
}

resource "google_container_node_pool" "primary_nodes" {
    name       = "${google_container_cluster.primary.name}-nodes"
    location   = var.zone
    cluster    = google_container_cluster.primary.name
    version    = data.google_container_engine_versions.gke_version.version_prefix
    node_count = var.node_count

    node_config {
        machine_type = var.machine_type
        disk_size_gb = var.disk_size
        preemptible  = false
        service_account = google_service_account.gke_sa.email
        oauth_scopes = [
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring"
        ]
        tags = ["${var.environment}-gke-nodes"]
    }
}