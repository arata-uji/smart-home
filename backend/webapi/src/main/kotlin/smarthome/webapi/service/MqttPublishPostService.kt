package smarthome.webapi.service

import jakarta.annotation.PostConstruct
import org.eclipse.paho.client.mqttv3.*
import org.eclipse.paho.client.mqttv3.persist.MemoryPersistence
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import smarthome.model.MqttPublishPost200Response
import smarthome.model.MqttPublishPostRequest

@Service
class MqttPublishPostService(
    @Value("\${mqtt.broker.url}") private val brokerUrl: String,
    @Value("\${mqtt.client.id}") private val clientId: String,
    @Value("\${mqtt.username}") private val username: String,
    @Value("\${mqtt.password}") private val password: String
) {

  private val log = LoggerFactory.getLogger(javaClass)
  private lateinit var client: MqttAsyncClient
  private lateinit var connectOptions: MqttConnectOptions

  @PostConstruct
  fun init() {
    try {
      val persistence = MemoryPersistence()
      client = MqttAsyncClient(brokerUrl, clientId, persistence)

      connectOptions =
          MqttConnectOptions().apply {
            isCleanSession = true
            connectionTimeout = 10
            isAutomaticReconnect = true
            userName = username
            password = this@MqttPublishPostService.password.toCharArray()
          }

      client.connect(
          connectOptions,
          null,
          object : IMqttActionListener {
            override fun onSuccess(asyncActionToken: IMqttToken) {
              log.info("MQTT connected: broker={}, clientId={}", brokerUrl, clientId)
            }

            override fun onFailure(asyncActionToken: IMqttToken, exception: Throwable) {
              log.error("Failed to connect to MQTT broker", exception)
            }
          })
    } catch (e: Exception) {
      log.error("Error initializing MQTT client", e)
      throw RuntimeException("Failed to initialize MQTT client", e)
    }
  }

  fun execute(request: MqttPublishPostRequest): MqttPublishPost200Response {
    try {
      client.publish(
          request.topic,
          request.payload.toByteArray(),
          0,
          false,
          null,
          object : IMqttActionListener {
            override fun onSuccess(asyncActionToken: IMqttToken) {
              log.debug("Published to topic={} payload={}", request.topic, request.payload)
            }

            override fun onFailure(asyncActionToken: IMqttToken, exception: Throwable) {
              log.warn("Publish failed topic={}", request.topic, exception)
            }
          })
      return MqttPublishPost200Response(message = "MQTT Publish Scheduled")
    } catch (e: MqttException) {
      log.error("Error publishing MQTT", e)
      throw RuntimeException("MQTT publish failed: ${e.reasonCode}", e)
    }
  }
}
