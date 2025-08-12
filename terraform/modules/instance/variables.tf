variable "project" {
  description = "GCPプロジェクトID"
  type        = string
}

variable "region" {
  description = "GCPリージョン"
  type        = string
}

variable "zone" {
  description = "GCPゾーン"
  type        = string
}

variable "subnet" {
  description = "VPCサブネット名"
  type        = string
  default     = "default"
}

variable "name" {
  description = "インスタンス名"
  type        = string
  default     = "mqtt-broker"
}

variable "machine_type" {
  description = "インスタンスのマシンタイプ"
  type        = string
  default     = "e2-micro"
}

variable "startup_script" {
  description = "インスタンス起動時に実行するスクリプト"
  type        = string
  default     = <<-EOT
    #!/bin/bash
    apt update
    apt install -y mosquitto mosquitto-clients

    # Secretを取得
    MQTT_WEB_PASSWORD=$(gcloud secrets versions access latest --secret="MQTT_WEB_PASSWORD" --format='get(payload.data)' | base64 --decode)
    MQTT_CTRL_PASSWORD=$(gcloud secrets versions access latest --secret="MQTT_CTRL_PASSWORD" --format='get(payload.data)' | base64 --decode)

    # ユーザとパスワード設定
    mosquitto_passwd -b -c /etc/mosquitto/passwd web $${MQTT_WEB_PASSWORD}
    mosquitto_passwd -b /etc/mosquitto/passwd controller-01 $${MQTT_CTRL_PASSWORD}
    chown mosquitto:mosquitto /etc/mosquitto/passwd

    # ACL設定
    cat <<-EOF > /etc/mosquitto/acl
    user web
    topic write room-01/light
    topic write room-01/aircon
    topic write living/light
    topic write living/aircon
    topic write living/televi

    user controller-01
    topic read room-01/light
    topic read room-01/aircon
    topic read living/light
    topic read living/aircon
    topic read living/televi
    EOF

    chown mosquitto:mosquitto /etc/mosquitto/acl

    # 設定ファイルの書き換え
    cat <<-EOF > /etc/mosquitto/mosquitto.conf
    persistence true
    persistence_location /var/lib/mosquitto/
    log_dest file /var/log/mosquitto/mosquitto.log
    include_dir /etc/mosquitto/conf.d
    user mosquitto
    listener 1883
    allow_anonymous false
    password_file /etc/mosquitto/passwd
    acl_file /etc/mosquitto/acl
    EOF

    chown mosquitto:mosquitto /etc/mosquitto/mosquitto.conf

    # mosquittoを再起動
    systemctl enable mosquitto
    systemctl restart mosquitto
  EOT
}
