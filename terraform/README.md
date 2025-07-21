# Terraform
このプロジェクトでは、Terraformを使用してGoogle Cloudのインフラをコードとして管理する。

## Terraformで管理するリソース
### Comuputing Engine

### Cloud Run

### Secret Manager

### Service Account

### ネットワークファイアウォールポリシー

### VPCファイアウォールルール

## Terraformで管理しないリソース
### Project
`smart-home`というプロジェクトを手動で作成。

### VPCネットワーク、サブネット
`default`VPCのus-west1サブネットを使用する。

### MQTTブローカのインスタンス用の静的グローバルIP
静的グローバルIPはApplyする前に作成してIPアドレスを確認しないといけないので、Terraformでは管理しない。

### SecretManagerの中身（バージョン）
シークレットそのものはTerraformで管理するが、シークレットのバージョンは手動で変更する（コードで秘密の情報を管理したくないため）。


