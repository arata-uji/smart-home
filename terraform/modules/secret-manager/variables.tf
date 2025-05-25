variable "project" {
  type        = string
  description = "GCP プロジェクト ID"
}

variable "mqtt_broker_url_value" {
  type        = string
  description = "MQTTブローカURL"
}

variable "mqtt_username_value" {
  type        = string
  description = "MQTTユーザー名"
}

variable "mqtt_password_value" {
  type        = string
  description = "MQTTパスワード"
}