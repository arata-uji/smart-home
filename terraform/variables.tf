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

variable "mqtt_broker_url" {
  description = "MQTTブローカーのURL"
  type        = string
}

variable "mqtt_username" {
  description = "MQTTブローカーのユーザー名"
  type        = string
}

variable "mqtt_password" {
  description = "MQTTブローカーのパスワード"
  type        = string
}