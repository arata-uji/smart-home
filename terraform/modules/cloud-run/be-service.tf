resource "google_cloud_run_v2_service" "be_service" {
  name     = var.be_service_name
  location = var.region

  template {
    annotations = {
      "run.googleapis.com/health-check-path" = "/actuator/health"
    }

    service_account = google_service_account.run_sa.email

    containers {
      image = var.be_image

      env {
        name = "MQTT_BROKER_URL"
        value_source {
          secret_key_ref {
            secret  = "MQTT_BROKER_URL"
            version = "latest"
          }
        }
      }

      env {
        name = "MQTT_WEB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = "MQTT_WEB_PASSWORD"
            version = "latest"
          }
        }
      }
    }

    scaling {
      max_instance_count = 1
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}

resource "google_cloud_run_v2_service_iam_binding" "public_invoker" {
  project  = google_cloud_run_v2_service.be_service.project
  location = google_cloud_run_v2_service.be_service.location
  name     = google_cloud_run_v2_service.be_service.name
  role     = "roles/run.invoker"
  members  = ["allUsers"]
}
