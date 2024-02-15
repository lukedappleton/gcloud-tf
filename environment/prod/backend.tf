terraform {
  backend "gcs" {
    bucket  = modules.provisioning.backend_bucket
    prefix  = "terraform/state"
    project = var.project_id
  }
}