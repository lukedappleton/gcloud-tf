module "provisioning" {
    source      = "git@github.com:lukedappleton/gcloud-tf.git//modules/provisioning?ref=99e4fd1"
    environment = var.environment
    project_id  = var.project_id
    region      = var.region
}

module "gke_cluster" {
  source = "git@github.com:lukedappleton/gcloud-tf.git//modules/k8s?ref=99e4fd1"
  project_id     = var.project_id
  region         = var.region
  environment    = var.environment
  k8s_version    = var.k8s_version
  cluster_name   = "${var.environment}-lda-k8s"
  node_count     = var.node_count
  machine_type   = var.machine_type
}