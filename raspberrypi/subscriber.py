#!/usr/bin/env python3
import json
import time
import logging
import signal
import sys
import paho.mqtt.client as mqtt
import pigpio

# === 設定セクション ===
BROKER_HOST = ""  # TODO: MQTTブローカーのホスト名またはIPアドレス
BROKER_PORT = 1883
MQTT_USER = "" # TODO: MQTTブローカーのコントローラー側のユーザー名
MQTT_PASS = "" # TODO: MQTTブローカーのコントローラー側のパスワード
TOPICS = [("living/light", 0), ("living/aircon", 0)]  # QoS=0に変更（速度重視）
GPIO_PIN = 17  # 赤外線送信用GPIO
CODES_FILE = "/home/raspberrypi/codes.json"
FREQ = 38.0  # キャリア周波数 (kHz)
GAP_MS = 50  # 従来の100msから50msに短縮（速度重視）
# ======================

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s"
)

pi = None
ir_codes = {}


def load_ir_codes():
    """IR コードをファイルから読み込む"""
    global ir_codes
    try:
        with open(CODES_FILE, "r") as f:
            ir_codes = json.load(f)
            logging.info(f"Loaded {len(ir_codes)} IR codes from {CODES_FILE}")
    except Exception as e:
        logging.error(f"Failed to load IR codes: {e}")
        sys.exit(1)


def carrier(gpio, frequency, micros):
    """キャリア波形を生成する"""
    wf = []
    cycle = 1000.0 / frequency
    cycles = int(round(micros / cycle))
    on = int(round(cycle / 2.0))
    sofar = 0
    for c in range(cycles):
        target = int(round((c + 1) * cycle))
        sofar += on
        off = target - sofar
        sofar += off
        wf.append(pigpio.pulse(1 << gpio, 0, on))
        wf.append(pigpio.pulse(0, 1 << gpio, off))
    return wf


def send_ir_code(code_id):
    """指定されたコードIDの赤外線信号を送信する"""
    global pi, ir_codes

    if code_id not in ir_codes:
        logging.error(f"IR code '{code_id}' not found")
        return False

    code = ir_codes[code_id]

    # 波形生成の高速化: マークとスペースのキャッシュを使用
    marks_wid = {}
    spaces_wid = {}
    wave = [0] * len(code)

    # 波形を生成
    for i in range(0, len(code)):
        ci = code[i]
        if i & 1:  # スペース
            if ci not in spaces_wid:
                pi.wave_add_generic([pigpio.pulse(0, 0, ci)])
                spaces_wid[ci] = pi.wave_create()
            wave[i] = spaces_wid[ci]
        else:  # マーク
            if ci not in marks_wid:
                wf = carrier(GPIO_PIN, FREQ, ci)
                pi.wave_add_generic(wf)
                marks_wid[ci] = pi.wave_create()
            wave[i] = marks_wid[ci]

    # 送信
    pi.wave_chain(wave)

    # 送信完了まで待機（待機時間を短縮）
    while pi.wave_tx_busy():
        time.sleep(0.001)  # 従来の0.002から0.001に短縮

    # 波形のクリーンアップ
    for i in marks_wid:
        pi.wave_delete(marks_wid[i])

    for i in spaces_wid:
        pi.wave_delete(spaces_wid[i])

    return True


def on_connect(client, userdata, flags, rc):
    """MQTT接続時のコールバック"""
    if rc == 0:
        logging.info("Connected to MQTT broker")
        # トピックをサブスクライブ
        for topic, qos in TOPICS:
            client.subscribe(topic, qos=qos)
            logging.info(f"Subscribed to {topic}")
    else:
        logging.error(f"Connect failed with code {rc}")


def on_message(client, userdata, msg):
    """MQTTメッセージ受信時のコールバック"""
    topic = msg.topic
    payload = msg.payload.decode().strip()  # "light:switch", "aircon:off" など
    logging.info(f"Received {payload!r} on {topic}, sending IR for {payload}")

    # 直接赤外線送信を実行
    if send_ir_code(payload):
        logging.info(f"IR sent for {payload}")
    else:
        logging.error(f"Failed to send IR for {payload}")


def cleanup(signum=None, frame=None):
    """終了時のクリーンアップ処理"""
    global pi
    if pi is not None:
        pi.stop()
    logging.info("Exiting application")
    sys.exit(0)


def main():
    """メイン関数"""
    global pi

    # シグナルハンドラ設定
    signal.signal(signal.SIGINT, cleanup)
    signal.signal(signal.SIGTERM, cleanup)

    # pigpioに接続
    pi = pigpio.pi()
    if not pi.connected:
        logging.error("Failed to connect to pigpio daemon")
        sys.exit(1)

    # GPIOの設定
    pi.set_mode(GPIO_PIN, pigpio.OUTPUT)
    pi.wave_add_new()

    # IRコード読み込み
    load_ir_codes()

    # MQTTクライアント設定
    client = mqtt.Client()
    client.username_pw_set(MQTT_USER, MQTT_PASS)
    client.on_connect = on_connect
    client.on_message = on_message

    # 接続と実行
    try:
        # コネクション維持にclean_session=Trueを設定（セッション状態を保持しない）
        client.connect(BROKER_HOST, BROKER_PORT, keepalive=10)  # keepaliveも短縮
        client.loop_forever()
    except KeyboardInterrupt:
        pass
    except Exception as e:
        logging.error(f"Error in main loop: {e}")
    finally:
        cleanup()


if __name__ == "__main__":
    main()
