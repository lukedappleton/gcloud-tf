variable "project_id" {
  description = "The ID of the Google Cloud project"
}

variable "environment" {
  description = "The environment to deploy resources in"
}

variable "region" {
  description = "The region for the GKE cluster"
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
}

variable "k8s_version" {
  description = "The version of Kubernetes to use for the GKE cluster"
}

variable "node_count" {
  description = "The number of nodes to create in the GKE cluster"
}

variable "machine_type" {
  description = "The machine type to use for the GKE cluster"
}   

variable "allowed_ip_ranges" {
  description = "The list of CIDR ranges to allow access to the GKE cluster"
  type = list(string)
}

variable "disk_size" {
  description = "The size of the disk to use for the GKE cluster"
}