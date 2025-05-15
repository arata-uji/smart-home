package smarthome.webapi.service

import org.springframework.stereotype.Service
import smarthome.model.MqttPublishPost200Response
import smarthome.model.MqttPublishPostRequest

@Service
class MqttPublishPostService {
    fun execute(request: MqttPublishPostRequest): MqttPublishPost200Response {
        return MqttPublishPost200Response(message = "MQTT Publish Success")
    }
}