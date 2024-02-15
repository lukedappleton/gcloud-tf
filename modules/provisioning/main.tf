resource "google_storage_bucket" "backend_bucket" {
    name     = "${var.environment}-lda-terraform-state"
    location = var.region
    project  = var.project_id
    public_access_prevention = "enforced"
    versioning {
        enabled = true
    }
    uniform_bucket_level_access {
        enabled = true
    }
}