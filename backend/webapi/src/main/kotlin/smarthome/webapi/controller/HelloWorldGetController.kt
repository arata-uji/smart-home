package smarthome.webapi.controller

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.RestController
import smarthome.api.HelloWorldGetApi
import smarthome.model.HelloWorldGet200Response

@RestController
class HelloWorldGetController: HelloWorldGetApi{
    override fun helloWorldGet(): ResponseEntity<HelloWorldGet200Response> {
        return ResponseEntity.ok(HelloWorldGet200Response(message = "Hello, World!"))
    }
}
