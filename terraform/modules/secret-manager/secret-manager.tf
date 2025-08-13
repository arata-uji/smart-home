# SecretManagerのApply後に、コンソールでシークレットの値を登録する
resource "google_secret_manager_secret" "mqtt_broker_url" {
  project   = var.project
  secret_id = "MQTT_BROKER_URL"
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

resource "google_secret_manager_secret" "mqtt_ca_crt" {
  project   = var.project
  secret_id = "MQTT_CA_CRT"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "mqtt_server_crt" {
  project   = var.project
  secret_id = "MQTT_SERVER_CRT"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "mqtt_server_key" {
  project   = var.project
  secret_id = "MQTT_SERVER_KEY"
  replication {
    auto {}
  }
}
