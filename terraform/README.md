# Terraform
このプロジェクトでは、Terraformを使用してGoogle Cloudのインフラをコードとして管理する。

## Terraformで管理するリソース

### Cloud Storage
tfstate用のCloud Storageバケット。

### Service Account
以下に対して権限を付与するためのサービスアカウント。
- Compute Engine（MQTTブローカー）
- Cloud Run（WebAPI）
- GitHub Actions

### Secret Manager
以下をシークレットで管理。
- MQTT_BROKER_URL：内部IPアドレスを含むMQTTブローカーのURL
- MQTT_WEB_PASSWORD：MQTTブローカーへのWeb側のパスワード
- MQTT_CA_CRT：CA証明書
- MQTT_SERVER_CRT：MQTTサーバーの証明書
- MQTT_SERVER_KEY：MQTTサーバーの秘密鍵

### Compute Engine
MQTTブローカーのインスタンス。

### Cloud Run
MQTTブローカーにPublishするためのWebAPI。

### ネットワークファイアウォールポリシー
VPCにあるインスタンスを保護するためのファイアウォールルール群。基本的には以下を許可する。
- CloudRunからの内部IPアドレスでのプライベートなMQTT（ポート1883）
- インターネットからのMQTT（ポート8883）
- IAPからのインスタンスのSSH（ポート22）
これ以外のトラフィックはすべて拒否する。
また、Googleマネージドのセキュリティルールを適用して脅威から保護する。

###  MQTTブローカーのインスタンス用の静的内部IP
内部IPアドレスは自分の裁量で決められるため、Terraformで管理する。

## Terraformで管理しないリソース
### Project
`smart-home`というプロジェクトを手動で作成。

### VPCネットワーク、サブネット
`default`VPCの`us-west1`サブネットを使用する。

### MQTTブローカーのインスタンス用の静的グローバルIP
静的グローバルIPはApplyする前に作成してIPアドレスを確認しないといけないので、Terraformでは管理しない。

### SecretManagerの中身（バージョン）
シークレットそのものはTerraformで管理するが、シークレットのバージョンは手動で変更する（コードで秘密の情報を管理したくないため）。

### VPCファイアウォールルール
ネットワークファイアウォールポリシーで一元的にルール管理するため、デフォルトで設定されているVPCファイアウォールルールは手動ですべて削除する。

### TLS証明書
MQTTブローカー↔Raspberry Pi間のMQTTでは、相互TLSで認証、暗号化を行う。そのため、自分のPCローカルで証明書を作成し、MQTTサーバー、Raspberry Piに配置する必要がある。

作成にはOpenSSLを使用する。Windowsへのインストール方法は[こちら](https://atmarkit.itmedia.co.jp/ait/articles/1601/29/news043.html)、相互TLSの証明書の作成方法は[こちら](https://zenn.dev/suzukinota14231/articles/70ed87ff1373ad)を参照。

作成するものは以下。
- CA証明書
- クライアント証明書
- クライアントキー
- サーバー証明書
- サーバーキー

## Apply手順
1. tfstate用のCloud Storageバケットをtarget指定で作成する。この時点では、provider.tfのbackend設定はコメントアウトしておく。
```
terraform apply -target=module.tfstate_store
```

2. 手順1でのコメントアウトを外してtfstateをローカルからCloud Storageに移行する。
```
terraform init -migrate-state
```

3. Secret Managerをtarget指定で作成する。
```
terraform apply -target=module.secret_manager
```

4. Secretの中身を手動で設定する。`MQTT_BROKER_URL`の内部IPアドレス部分については、任意の値を設定する。
5. MQTTブローカーのインスタンス用の静的グローバルIPを手動で作成する。
6. デフォルトで設定されているVPCファイアウォールルールを手動ですべて削除する。
7. すべてのmoduleに対してApplyする。
```
terraform apply
```
