resource "google_service_account" "gke_sa" {
    account_id   = "${var.environment}-gke-sa"
    display_name = "GKE Service Account"
}