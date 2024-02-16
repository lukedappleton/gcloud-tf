data "google_container_engine_versions" "gke_version" {
    location       = var.region
    version_prefix = var.k8s_version
}

resource "google_service_account" "gke_sa" {
    account_id   = "${var.environment}-gke-sa"
    display_name = "GKE Service Account"
}

resource "google_project_service" "kubernetes_api" {
  project = var.project_id
  service = "container.googleapis.com"
}

resource "google_container_cluster" "primary" {
    name                     = var.cluster_name
    location                 = var.region
    project                  = var.project_id
    remove_default_node_pool = true
    initial_node_count       = 1
    network                  = google_compute_network.vpc.self_link
    subnetwork               = google_compute_subnetwork.subnet.self_link
    logging_service          = "logging.googleapis.com/kubernetes"
    monitoring_service       = "monitoring.googleapis.com/kubernetes"
}

resource "google_container_node_pool" "primary_nodes" {
    name       = "${google_container_cluster.primary.name}-nodes"
    location   = var.region
    cluster    = google_container_cluster.primary.name
    version    = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
    node_count = var.node_count

    node_config {
        machine_type = var.machine_type
        preemptible  = false
        service_account = google_service_account.gke_sa.email
        oauth_scopes = [
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.read_only",
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring",
            "https://www.googleapis.com/auth/dataproc"
            ]
        tags = ["${var.environment}-gke-nodes"]
    }
}

resource "google_compute_network" "vpc" {
    name                    = "${var.cluster_name}-vpc"
    auto_create_subnetworks = false
    project                 = var.project_id
}

resource "google_compute_subnetwork" "subnet" {
    name          = "${var.cluster_name}-subnet"
    ip_cidr_range = "10.0.0.0/16"
    region        = var.region
    network       = google_compute_network.vpc.self_link
}

resource "google_compute_firewall" "allow-internal" {
    name    = "${var.cluster_name}-allow-internal"
    network = google_compute_network.vpc.self_link

    allow {
        protocol = "all"
    }

    source_ranges = ["10.0.0.0/16"]
}

resource "google_compute_firewall" "allow-https-from-specific-ip" {
    name    = "${var.cluster_name}-allow-https-from-specific-ip"
    network = google_compute_network.vpc.self_link

    allow {
        protocol = "tcp"
        ports    = ["443"]
    }

    source_ranges = var.allowed_ip_ranges
}