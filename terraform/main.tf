module "secret-manager" {
  source  = "./modules/secret-manager"
  project = var.project
}

module "service-account" {
  source  = "./modules/service-account"
  project = var.project
}

module "mqtt-broker" {
  source  = "./modules/instance"
  project = var.project
  region  = var.region
  zone    = var.zone
}

module "cloud-run" {
  source = "./modules/cloud-run"
  region = var.region
}