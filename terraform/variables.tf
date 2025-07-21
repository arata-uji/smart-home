variable "project" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "region" {
  description = "GCPリージョン"
  type        = string
  default     = "us-west1"
}

variable "zone" {
  description = "GCPゾーン"
  type        = string
  default     = "us-west1-a"
}
