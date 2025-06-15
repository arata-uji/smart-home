variable "region" {
  description = "GCPリージョン"
  type        = string
}

variable "be-service-name" {
  description = "サービス名（backend）"
  type        = string
  default     = "be-service"
}

variable "be-image" {
  description = "イメージ（backend）"
  type        = string
  default     = "ujimatcha/smart-home-be:latest"
}