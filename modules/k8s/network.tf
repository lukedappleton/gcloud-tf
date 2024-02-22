resource "google_compute_network" "vpc" {
    name                                   = "${var.cluster_name}-vpc"
    auto_create_subnetworks                = false
    routing_mode                           = "GLOBAL"
    project                                = var.project_id
    description                            = "Network to use as shared VPC for Data projects"
    delete_default_internet_gateway_routes = false
    mtu                                    = 0
    enable_ula_internal_ipv6               = false
}

resource "google_compute_subnetwork" "subnet" {
    name                     = "${var.cluster_name}-subnet"
    project                  = var.project_id
    ip_cidr_range            = "10.0.0.0/16"
    region                   = var.region
    network                  = google_compute_network.vpc.self_link
    private_ip_google_access = "true"
    secondary_ranges         = [
        for range_name, range in var.secondary_ranges : {
            range_name    = range_name
            ip_cidr_range = range
        }
    ]
}

resource "google_compute_router" "router" {
    name    = "${var.cluster_name}-router"
    project = var.project_id
    region  = var.region
    network = google_compute_network.vpc.self_link
}

resource "google_compute_router_nat" "nat" {
    name                                = "${var.cluster_name}-nat"
    project                            = var.project_id
    region                             = var.region
    router                             = google_compute_router.router.name
    nat_ip_allocate_option             = "AUTO_ONLY"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_global_address" "private_ip_alloc" {
  project       = var.project_id
  name          = "airflow-db-ip"
  address_type  = "INTERNAL"
  purpose       = "VPC_PEERING"
  prefix_length = 16
  network       = google_compute_network.vpc.self_link
  address       = "10.81.0.0"
}

resource "google_service_networking_connection" "vpc_connection" {
  network                 = google_compute_network.vpc.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}