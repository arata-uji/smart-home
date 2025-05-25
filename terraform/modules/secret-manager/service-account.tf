data "google_project" "project" {}

locals {
  run_sa = "serviceAccount:${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

resource "google_secret_manager_secret_iam_member" "mqtt_broker_url_access" {
  project   = var.project
  secret_id = google_secret_manager_secret.mqtt_broker_url.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = local.run_sa
}

resource "google_secret_manager_secret_iam_member" "mqtt_username_access" {
  project   = var.project
  secret_id = google_secret_manager_secret.mqtt_username.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = local.run_sa
}

resource "google_secret_manager_secret_iam_member" "mqtt_password_access" {
  project   = var.project
  secret_id = google_secret_manager_secret.mqtt_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = local.run_sa
}
