variable "region" {
  description = "GCPリージョン"
  type        = string
}

variable "be_service_name" {
  description = "サービス名（backend）"
  type        = string
  default     = "be-service"
}

variable "be_image" {
  description = "イメージ（backend）"
  type        = string
  default     = "ujimatcha/smart-home-be:latest"
}