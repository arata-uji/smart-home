resource "google_cloud_run_service" "be_service" {
  name     = var.be_service_name
  location = var.region

  template {
    spec {
      service_account_name = google_service_account.run_sa.email

      containers {
        image = var.be_image

        env {
          name = "MQTT_BROKER_URL"
          value_from {
            secret_key_ref {
              name = "MQTT_BROKER_URL"
              key  = "latest"
            }
          }
        }

        env {
          name = "MQTT_WEB_PASSWORD"
          value_from {
            secret_key_ref {
              name = "MQTT_WEB_PASSWORD"
              key  = "latest"
            }
          }
        }
      }
    }
  }
}

resource "google_cloud_run_service_iam_member" "public_invoker" {
  service  = google_cloud_run_service.be_service.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}