resource "google_service_account" "run_sa" {
  account_id   = "cloud-run-sa"
  display_name = "Custom Service Account for Cloud Run"
  project      = var.project
}

resource "google_project_iam_member" "sa_secret_accessor" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}

resource "google_project_iam_member" "sa_log_writer" {
  project = var.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}

resource "google_project_iam_member" "sa_metric_writer" {
  project = var.project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}

resource "google_project_iam_member" "sa_run_service_admin" {
  project = var.project
  role    = "roles/run.serviceAdmin"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}
