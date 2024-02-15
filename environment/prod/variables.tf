variable "project_id" {
  description = "The ID of the Google Cloud project"
}

variable "region" {
  description = "The region for the GKE cluster"
  default     = "us-central1"
}

variable "zone" {
  description = "The zone for Google Cloud resources"
  default     = "us-central1-a"
}