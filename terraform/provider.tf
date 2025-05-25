terraform {
  required_version = ">= 1.5.0"

  backend "gcs" {
    bucket = "TFSTATE_BUCKET_NAME"
    prefix = "smart-home/terraform/state"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}
