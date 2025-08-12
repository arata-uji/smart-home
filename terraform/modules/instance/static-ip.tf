data "google_compute_address" "mqtt_broker_ip" {
  name    = "mqtt-broker-ip"
  project = var.project
  region  = var.region
}

data "google_compute_subnetwork" "target" {
  name    = var.subnet
  project = var.project
  region  = var.region
}

resource "google_compute_address" "internal" {
  name         = "mqtt-broker-internal-ip"
  project      = var.project
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = data.google_compute_subnetwork.target.self_link
  address      = "10.138.0.100"
}
