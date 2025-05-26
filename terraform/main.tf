module "secret-manager" {
  source          = "./modules/secret-manager"

  project         = var.project
  mqtt_broker_url = var.mqtt_broker_url
  mqtt_username   = var.mqtt_username
  mqtt_password   = var.mqtt_password
}