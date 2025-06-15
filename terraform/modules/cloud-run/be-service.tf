resource "google_cloud_run_service" "be-service" {
  name     = var.be-service-name
  location = var.region

  template {
    spec {
      containers {
        image = var.be-image
      }
    }
  }
}