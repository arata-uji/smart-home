variable "project" {
  description = "GCPプロジェクトID"
  type        = string
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