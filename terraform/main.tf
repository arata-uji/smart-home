module "secret_manager" {
  source  = "./modules/secret-manager"
  project = var.project
}

module "service_account" {
  source  = "./modules/service-account"
  project = var.project
}

module "mqtt_broker" {
  source  = "./modules/instance"
  project = var.project
  region  = var.region
  zone    = var.zone
}

module "cloud_run" {
  source  = "./modules/cloud-run"
  project = var.project
  region  = var.region
}

module "firewall" {
  source  = "./modules/firewall"
  project = var.project
}

module "tfstate_store" {
  source  = "./modules/tfstate-store"
  region  = var.region
}
