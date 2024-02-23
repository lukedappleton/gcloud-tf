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
    default_max_pods_per_node  = 50
    initial_node_count         = 1
    network                    = google_compute_network.vpc.self_link
    subnetwork                 = google_compute_subnetwork.subnet.self_link
    logging_service            = "logging.googleapis.com/kubernetes"
    monitoring_service         = "monitoring.googleapis.com/kubernetes"
    min_master_version         = data.google_container_engine_versions.gke_version.version_prefix
    node_config                {
        disk_size_gb = var.disk_size
    }
    ip_allocation_policy {
        cluster_secondary_range_name  = keys(var.secondary_ranges)[0]
        services_secondary_range_name = keys(var.secondary_ranges)[1]
        stack_type                    = "IPV4"
    }
    private_cluster_config {
        enable_private_endpoint = true
        enable_private_nodes    = true
        master_ipv4_cidr_block  = var.master_cidr
    }
    master_authorized_networks_config {
        cidr_blocks {
            cidr_block   = var.master_cidr
            display_name = "Master CIDR"
        }
    vertical_pod_autoscaling {
        enabled = true
    }
    cluster_autoscaling {
        enabled = true
        auto_provisioning_defaults {
            service_account = google_service_account.gke_sa.email
            oauth_scopes = [
                "https://www.googleapis.com/auth/logging.write",
                "https://www.googleapis.com/auth/monitoring"
            ]
            management {
                auto_repair  = true
                auto_upgrade = true
            }
            disk_size = var.disk_size
            disk_type  = "pd-standard"
        }
        autoscaling_profile = "optimize-utilization"
        resource_limits {
            resource_type = "cpu"
            minimum       = 1
            maximum       = 100
        }
    }
    enable_shielded_nodes = true
    datapath_provider = "DATAPATH_PROVIDER_UNSPECIFIED"
    maintenance_policy {
        window {
            daily_maintenance_window {
                start_time = "05:00"
            }
        }
    }
    addons_config {
        horizontal_pod_autoscaling {
            disabled = false
        }
        http_load_balancing {
            disabled = false
        }
        kubernetes_dashboard {
            disabled = false
        }
        network_policy_config {
            disabled = false
        }
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
            "https://www.googleapis.com/auth/logging.write",
            "https://www.googleapis.com/auth/monitoring"
        ]
        tags = ["${var.environment}-gke-nodes"]
    }
}