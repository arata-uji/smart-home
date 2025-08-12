package smarthome.webapi.service

import org.springframework.stereotype.Service
import smarthome.model.HelloWorldGet200Response

@Service
class HelloWorldGetService {
  fun execute(): HelloWorldGet200Response {
    return HelloWorldGet200Response(message = "Hello, World!")
  }
}
