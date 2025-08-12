package smarthome.webapi.controller

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.RestController
import smarthome.api.HelloWorldGetApi
import smarthome.model.HelloWorldGet200Response
import smarthome.webapi.service.HelloWorldGetService

@RestController
class HelloWorldGetController : HelloWorldGetApi {
  private final val service = HelloWorldGetService()

  override fun helloWorldGet(): ResponseEntity<HelloWorldGet200Response> {
    return ResponseEntity.ok(service.execute())
  }
}
