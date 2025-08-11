resource "google_compute_network_firewall_policy" "policy" {
  name    = var.name
  project = var.project
}

resource "google_compute_network_firewall_policy_rule" "exclude_private_egress" {
  project         = var.project
  firewall_policy = google_compute_network_firewall_policy.policy.id

  description = "Exclude communication with private IP ranges, leaving only Internet traffic to be inspected"
  priority    = 1000
  direction   = "EGRESS"
  action      = "goto_next"

  match {
    dest_ip_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]

    layer4_configs {
      ip_protocol = "all"
    }
  }
}

resource "google_compute_network_firewall_policy_rule" "exclude_private_ingress" {
  project         = var.project
  firewall_policy = google_compute_network_firewall_policy.policy.id

  description = "Exclude communication with private IP ranges, leaving only Internet traffic to be inspected"
  priority    = 1001
  direction   = "INGRESS"
  action      = "goto_next"

  match {
    src_ip_ranges = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]

    layer4_configs {
      ip_protocol = "all"
    }
  }
}

resource "google_compute_network_firewall_policy_rule" "deny_tor" {
  project         = var.project
  firewall_policy = google_compute_network_firewall_policy.policy.id

  description    = "Deny TOR exit nodes ingress traffic"
  priority       = 1002
  direction      = "INGRESS"
  action         = "deny"
  enable_logging = false

  match {
    src_threat_intelligences = ["iplist-tor-exit-nodes"]

    layer4_configs {
      ip_protocol = "all"
    }
  }
}

resource "google_compute_network_firewall_policy_rule" "deny_known_malicious_ingress" {
  project         = var.project
  firewall_policy = google_compute_network_firewall_policy.policy.id

  description    = "Deny known malicious IPs ingress traffic"
  priority       = 1003
  direction      = "INGRESS"
  action         = "deny"
  enable_logging = false

  match {
    src_threat_intelligences = ["iplist-known-malicious-ips"]

    layer4_configs {
      ip_protocol = "all"
    }
  }
}

resource "google_compute_network_firewall_policy_rule" "deny_known_malicious_egress" {
  project         = var.project
  firewall_policy = google_compute_network_firewall_policy.policy.id

  description    = "Deny known malicious IPs egress traffic"
  priority       = 1004
  direction      = "EGRESS"
  action         = "deny"
  enable_logging = false

  match {
    dest_threat_intelligences = ["iplist-known-malicious-ips"]

    layer4_configs {
      ip_protocol = "all"
    }
  }
}

resource "google_compute_network_firewall_policy_rule" "deny_sanctioned_countries" {
  project         = var.project
  firewall_policy = google_compute_network_firewall_policy.policy.id

  description    = "Deny sanctioned countries ingress traffic"
  priority       = 1005
  direction      = "INGRESS"
  action         = "deny"
  enable_logging = false

  match {
    src_region_codes = ["CU", "IR", "KP", "SY", "XC", "XD"]

    layer4_configs {
      ip_protocol = "all"
    }
  }
}

resource "google_compute_network_firewall_policy_rule" "allow_ssh_ingress_from_iap" {
  project         = var.project
  firewall_policy = google_compute_network_firewall_policy.policy.id

  description    = "Allow SSH from IAP TCP forwarding proxies"
  priority       = 2000
  direction      = "INGRESS"
  action         = "allow"
  enable_logging = false

  match {
    src_ip_ranges = ["35.235.240.0/20"]

    layer4_configs {
      ip_protocol = "tcp"
      ports       = ["22"]
    }
  }
}

resource "google_compute_network_firewall_policy_rule" "allow_http_https_mqtt" {
  project         = var.project
  firewall_policy = google_compute_network_firewall_policy.policy.id

  description    = "Allow HTTP/HTTPS and MQTT(1883) from anywhere"
  priority       = 2001
  direction      = "INGRESS"
  action         = "allow"
  enable_logging = false

  match {
    src_ip_ranges = ["0.0.0.0/0"]

    layer4_configs {
      ip_protocol = "tcp"
      ports       = ["80", "443", "1883"]
    }
  }
}

data "google_compute_network" "default" {
  name    = "default"
  project = var.project
}

resource "google_compute_network_firewall_policy_association" "assoc_to_project" {
  project           = var.project
  firewall_policy   = google_compute_network_firewall_policy.policy.id
  attachment_target = data.google_compute_network.default.self_link
  name              = "${var.name}-assoc"
}
