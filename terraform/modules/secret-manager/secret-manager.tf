resource "google_secret_manager_secret" "mqtt_broker_url" {
  project   = var.project
  secret_id = "MQTT_BROKER_URL"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "mqtt_username" {
  project   = var.project
  secret_id = "MQTT_USERNAME"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "mqtt_password" {
  project   = var.project
  secret_id = "MQTT_PASSWORD"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "mqtt_broker_url_version" {
  secret      = google_secret_manager_secret.mqtt_broker_url.id
  secret_data = var.mqtt_broker_url
}

resource "google_secret_manager_secret_version" "mqtt_username_version" {
  secret      = google_secret_manager_secret.mqtt_username.id
  secret_data = var.mqtt_username
}

resource "google_secret_manager_secret_version" "mqtt_password_version" {
  secret      = google_secret_manager_secret.mqtt_password.id
  secret_data = var.mqtt_password
}