data "google_compute_address" "mqtt_broker_ip" {
  name    = "mqtt-broker-ip"
  project = var.project
  region  = var.region
}

data "google_compute_address" "mqtt_broker_internal_ip" {
  name    = "mqtt-broker-internal-ip"
  project = var.project
  region  = var.region
}

resource "google_compute_instance" "mqtt_broker" {
  project      = var.project
  zone         = var.zone
  name         = var.name
  machine_type = var.machine_type

  network_interface {
    subnetwork = var.subnet
    network_ip = sensitive(data.google_compute_address.mqtt_broker_internal_ip.address)

    access_config {
      nat_ip = sensitive(data.google_compute_address.mqtt_broker_ip.address)
    }
  }

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2404-noble-amd64-v20250501"
      size  = 30
      type  = "pd-standard"
    }
  }

  service_account {
    email  = google_service_account.mqtt_broker_sa.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata_startup_script = var.startup_script

  allow_stopping_for_update = true
}
