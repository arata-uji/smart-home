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

resource "google_secret_manager_secret" "mqtt_web_password" {
  project   = var.project
  secret_id = "MQTT_WEB_PASSWORD"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "mqtt_ctrl_password" {
  project   = var.project
  secret_id = "MQTT_CTRL_PASSWORD"
  replication {
    auto {}
  }
}