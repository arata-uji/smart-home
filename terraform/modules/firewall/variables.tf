variable "project" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "name" {
  description = "ファイアウォールポリシー名"
  type        = string
  default     = "policy"
}

variable "subnet_cidr" {
  description = "サブネットのCIDR"
  type        = string
  default     = "10.138.0.0/20"
}
