variable "project" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "name" {
  description = "ファイアウォールポリシー名"
  type        = string
  default     = "allow-http-https-mqtt"
}
