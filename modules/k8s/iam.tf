resource "google_service_account" "gke_sa" {
    account_id   = "${var.environment}-gke-sa"
    display_name = "GKE Service Account"
    project      = var.project_id
}

resource "google_project_iam_member" "gke_sa_node_service" {
    project = var.project_id
    role    = "roles/container.defaultNodeServiceAccount"
    member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_artifact_registry" {
    project = var.project_id
    role    = "roles/artifactregistry.reader"
    member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_project_iam_member" "gke_sa_storage" {
    project = var.project_id
    role    = "roles/storage.objectViewer"
    member  = "serviceAccount:${google_service_account.gke_sa.email}"
}