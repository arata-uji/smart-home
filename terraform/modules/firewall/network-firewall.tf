resource "google_compute_network_firewall_policy" "allow_http_https_mqtt" {
  name    = var.name
  project = var.project
}
