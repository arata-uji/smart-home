# Raspberri Piのコントローラ化
## 概要
このプロジェクトは、Raspberry Piを使用して、様々な家電をコントロールするためのシステムを構築することを目的としている。Raspberry Piは、GPIOピンを使用してテレビやエアコンといった赤外線リモコンの信号を学習し、それを出力することができる。あらゆる家電に対応できる疑似的なリモコンの役割を果たすことができる。Raspberry Piを疑似的なリモコンにするまでには、いくつかの手順を踏む必要がある。このドキュメントはその手順に焦点を当てている。

## 前提
まず、前提として必要な資材や環境について説明する。

### Raspberry Piと電子部品
今回の主役のRaspberry Piと疑似リモコンを実現するための電子部品は必須である。以下の資材が必要となる。
- Raspberry Pi Zero WH（モデルは問わないが、最低限ZeroのスペックがあればOK）
- 赤外線LED
- 赤外線受信モジュール
- 抵抗
- トランジスタ
- ブレッドボード
- ジャンパーワイヤ
- はんだごて一式
- microSDカード（OSインストール用）

疑似リモコンの電子工作は、以下の記事を参考にすると良い。
- https://qiita.com/takjg/items/e6b8af53421be54b62c9
- https://vintagechips.wordpress.com/2013/10/05/%E8%B5%A4%E5%A4%96%E7%B7%9Aled%E3%83%89%E3%83%A9%E3%82%A4%E3%83%96%E5%9B%9E%E8%B7%AF%E3%81%AE%E6%B1%BA%E5%AE%9A%E7%89%88/

最初はブレッドボードで動作確認するが、最終的には、はんだごてを使って配線を固定する必要がある。そのため、はんだごて一式も手元になければ購入する必要がある。

### MQTTブローカとWeb API
家のWi-Fiに自身のスマホなどが接続していない状態、つまり家の外からRaspberry Piを操作するためにはひと工夫が必要である。Raspberry Pi以外にも、MQTTブローカ、そこにメッセージをPublishするWeb APIが必要である。Raspberry PiはMQTTブローカにメッセージをSubscribeし、ブローカを中継地点とすることで家電を操作する。詳細は～～～を参照。

## Raspberry Piのセットアップ
Raspberry Piを疑似リモコンとして使用するためのセットアップ手順を以下に示す。

### OSのインストール
Raspberry PiにOSをインストールするためには、Raspberry Pi Imagerを使用するのが簡単である。以下の手順で進める。
1. Raspberry Pi Imagerをダウンロードしてインストールする。
2. Raspberry Pi OS Lite (32-bit)を選択する（デスクトップ機能は不要なため）。
3. 初期設定画面で各種設定をし、書き込みを開始する。
4. 書き込みが完了したら、SDカードをRaspberry Piに挿入する。
5. Raspberry Piを起動し、初期設定を行う。

### IPアドレスの固定化
Raspberry Piに固定IPアドレスを設定することで、常に同じIPアドレスでアクセスできるようにする。固定IPアドレスの設定は、ホームルータのDHCP設定で行うことが一般的である。

### SSH接続
固定化したIPアドレスと初期設定画面で設定した情報を使用して、SSHでRaspberry Piに接続する。以下、接続例を示す。
```
ssh raspberrypi@<固定IPアドレス>
# パスワードは初期設定時に設定したものを使用
```

### パッケージ、依存ライブラリのインストール
MQTT関連のパッケージをインストールするために、以下のコマンドを実行する。
- pigpio
```
sudo apt update
sudo apt install mosquitto mosquitto-clients
sudo systemctl enable mosquitto
sudo systemctl start mosquitto
```
- Pythonライブラリ
```
sudo apt install python3-pip
pip3 install paho-mqtt pigpio
```

### 動作確認
Subscribeが正常に動作するか確認するために、以下のコマンドを実行する。
```
mosquitto_sub -h <MQTTブローカのIPアドレス> -t room-01/light -u controller-01 -P <コントローラ側のパスワード>
```

### スクリプト
以下2つのPythonスクリプトを用意する。
- irrp.py: 赤外線信号を学習し、赤外線信号を出力する。
- subscriber.py: MQTT Subscribeを行い、受信したメッセージに応じて出力する赤外線信号を制御する。

### 赤外線信号の学習
赤外線信号を学習するために、以下の手順を実行する。
1. 赤外線モジュールをRaspberry Piに接続した状態で`irrp.py`を実行する。以下、実行例を示す。
```
python3 irrp.py -r -g18 -f codes.json aircon:cool-on
```
| オプション         | 意味                                           |
| ------------------ | ---------------------------------------------- |
| -r または --record | 記録（学習）モード                             |
| -g18               | IR受信機が接続されているGPIO番号（例: GPIO18） |
| -f codes.json      | 学習したコードを保存するファイル               |
| cool-on            | 学習するボタンのラベル                         |

2. 「Press key for 'aircon:cool-on'」と表示されたら、該当するリモコンのボタンを1回押す。
3. 「Press key for 'aircon:cool-on' to confirm」と出るので、もう1回同じボタンを押して確認。
4. `codes.json`に、以下のような形式で保存される。
```json
{
  "aircon:cool-on": [9000, 4500, 600, 550, ...]
}
```

### 赤外線信号の出力
学習した赤外線信号を出力するためには、以下のように`irrp.py`を実行する。
```
python3 irrp.py -p -g17 -f codes.json aircon:cool-on
```

### MQTT Subscribeの実行
上記の動作確認まで完了したら、MQTT Subscribeを実行するために`subscriber.py`を起動する。
```
python3 subscriber.py
```