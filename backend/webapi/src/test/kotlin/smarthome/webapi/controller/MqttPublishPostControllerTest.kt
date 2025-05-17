package smarthome.webapi.controller

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import smarthome.model.MqttPublishPost200Response
import smarthome.model.MqttPublishPostRequest

@SpringBootTest
class MqttPublishPostControllerTest {

  @Autowired private lateinit var controller: MqttPublishPostController

  @Test
  @DisplayName("MQTTブローカへのpublishが成功したときにメッセージ付きの200レスポンスを返すこと")
  fun testMqttPublishPostController() {
    // given
    val request = MqttPublishPostRequest(topic = "room-01/light", payload = "light:on")

    // when
    val actual = controller.mqttPublishPost(request).body

    // then
    val expected = MqttPublishPost200Response(message = "MQTT Publish Success")
    assertEquals(expected, actual)
  }
}
