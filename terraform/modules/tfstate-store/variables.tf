variable "name" {
  description = "tfstate-backetの名前"
  type        = string
  default     = "smart-home-tfstate"
}

variable "region" {
  description = "GCPリージョン"
  type        = string
}

variable "storage_class" {
  description = "ストレージクラス"
  type        = string
  default     = "STANDARD"
}
