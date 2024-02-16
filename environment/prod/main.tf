module "provisioning" {
    source      = "git@github.com:lukedappleton/gcloud-tf.git//modules/provisioning?ref=032385c"
    environment = var.environment
    project_id  = var.project_id
    region      = var.region
}

module "gke_cluster" {
  source            = "git@github.com:lukedappleton/gcloud-tf.git//modules/k8s?ref=032385c"
  project_id        = var.project_id
  region            = var.region
  environment       = var.environment
  k8s_version       = var.k8s_version
  cluster_name      = "${var.environment}-lda-k8s"
  node_count        = var.node_count
  machine_type      = var.machine_type
  allowed_ip_ranges = var.allowed_ip_ranges
  disk_size         = var.disk_size
}