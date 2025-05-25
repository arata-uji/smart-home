resource "google_secret_manager_secret" "mqtt_broker_url" {
  project   = var.project
  secret_id = "MQTT_BROKER_URL"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "mqtt_username" {
  project   = var.project
  secret_id = "MQTT_USERNAME"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret" "mqtt_password" {
  project   = var.project
  secret_id = "MQTT_PASSWORD"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "mqtt_broker_url_version" {
  secret      = google_secret_manager_secret.mqtt_broker_url.id
  secret_data = var.mqtt_broker_url_value
}

resource "google_secret_manager_secret_version" "mqtt_username_version" {
  secret      = google_secret_manager_secret.mqtt_username.id
  secret_data = var.mqtt_username_value
}

resource "google_secret_manager_secret_version" "mqtt_password_version" {
  secret      = google_secret_manager_secret.mqtt_password.id
  secret_data = var.mqtt_password_value
}