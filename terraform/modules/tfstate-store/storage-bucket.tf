resource "google_storage_bucket" "tfstate_store" {
  name          = var.name
  location      = var.region
  storage_class = var.storage_class
}