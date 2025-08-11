resource "google_compute_network_firewall_policy" "policy" {
  name    = var.name
  project = var.project
}

resource "google_compute_network_firewall_policy_rule" "allow_http_https_mqtt" {
  project         = var.project
  firewall_policy = google_compute_network_firewall_policy.policy.id

  description    = "Allow HTTP/HTTPS and MQTT(1883) from anywhere"
  priority       = 2000
  direction      = "INGRESS"
  action         = "allow"
  enable_logging = true

  match {
    src_ip_ranges = ["0.0.0.0/0"]

    layer4_configs {
      ip_protocol = "tcp"
      ports       = ["80", "443", "1883"]
    }
  }
}

data "google_project" "smart-home" {
  project_id = var.project
}

resource "google_compute_network_firewall_policy_association" "assoc_to_project" {
  project           = var.project
  firewall_policy   = google_compute_network_firewall_policy.policy.id
  attachment_target = "projects/${data.google_project.smart-home.number}"
  name              = "${var.name}-assoc"
}