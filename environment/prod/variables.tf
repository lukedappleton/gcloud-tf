variable "project_id" {
  description = "The ID of the Google Cloud project"
}

variable "region" {
  description = "The region for the GKE cluster"
  default     = "us-central1"
}

variable "environment" {
  description = "The environment for the GCP resources"
  default     = "prod"
}

variable "k8s_version" {
  description = "The version of Kubernetes to use for the GKE cluster"
  default     = "1.29"
}

variable "node_count" {
  description = "The number of nodes to create in the GKE cluster"
  default     = 1
}

variable "machine_type" {
  description = "The machine type to use for the GKE cluster nodes"
  default     = "e2-micro"
}

variable "allowed_ip_ranges" {
  description = "The list of IP ranges to allow access to the GKE cluster"
  type        = list(string)
}

variable "disk_size" {
  description = "The size of the disk to use for the GKE cluster"
  default     = 50
}