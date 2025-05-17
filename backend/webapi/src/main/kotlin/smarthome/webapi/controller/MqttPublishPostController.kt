package smarthome.webapi.controller

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.RestController
import smarthome.api.MqttPublishPostApi
import smarthome.model.MqttPublishPost200Response
import smarthome.model.MqttPublishPostRequest
import smarthome.webapi.service.MqttPublishPostService

@RestController
class MqttPublishPostController(private val service: MqttPublishPostService) : MqttPublishPostApi {
  override fun mqttPublishPost(
      mqttPublishPostRequest: MqttPublishPostRequest
  ): ResponseEntity<MqttPublishPost200Response> {
    return ResponseEntity.ok(service.execute(mqttPublishPostRequest))
  }
}
