terraform {
  backend "gcs" {
    bucket  = "prod-lda-terraform-state"
    prefix  = "terraform/state"
  }
}