terraform {
  required_version = ">= 1.5.0"

  backend "gcs" {
    # terraform init -backend-config="bucket=***"
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
