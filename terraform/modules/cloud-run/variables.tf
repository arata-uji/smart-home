variable "project" {
  description = "GCPプロジェクトID"
  type        = string
}

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

variable "vpc_network" {
  description = "VPCネットワーク名"
  type        = string
  default     = "default"
}

variable "vpc_subnet" {
  description = "VPCサブネット名"
  type        = string
  default     = "default"
}

variable "vpc_egress" {
  description = "VPC egress設定（ALL_TRAFFICまたはPRIVATE_RANGES_ONLY）"
  type        = string
  default     = "PRIVATE_RANGES_ONLY"
}
