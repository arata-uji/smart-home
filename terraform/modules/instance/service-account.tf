resource "google_service_account" "mqtt_broker_sa" {
  account_id   = "mqtt-broker-sa"
  display_name = "Custom Service Account for MQTT Broker VM"
  project      = var.project
}

resource "google_project_iam_member" "sa_secret_accessor" {
  project = var.project
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.mqtt_broker_sa.email}"
}

resource "google_project_iam_member" "sa_log_writer" {
  project = var.project
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.mqtt_broker_sa.email}"
}

resource "google_project_iam_member" "sa_metric_writer" {
  project = var.project
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.mqtt_broker_sa.email}"
}