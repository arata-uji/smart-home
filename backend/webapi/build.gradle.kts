plugins {
  kotlin("jvm") version "1.9.25"
  kotlin("plugin.spring") version "1.9.25"
  id("org.springframework.boot") version "3.4.5"
  id("io.spring.dependency-management") version "1.1.7"
  id("org.openapi.generator") version "7.13.0"
  id("com.diffplug.spotless") version "7.0.3"
}

group = "smarthome"

version = "0.0.1-SNAPSHOT"

java { toolchain { languageVersion = JavaLanguageVersion.of(17) } }

repositories { mavenCentral() }

dependencies {
  implementation("org.springframework.boot:spring-boot-starter-web")
  implementation("org.jetbrains.kotlin:kotlin-reflect")
  implementation("io.swagger.core.v3:swagger-annotations:2.2.30")
  implementation("javax.validation:validation-api:2.0.1.Final")
  implementation("javax.servlet:javax.servlet-api:4.0.1")
  implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.8.8")
  testImplementation("org.springframework.boot:spring-boot-starter-test")
  testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
  testRuntimeOnly("org.junit.platform:junit-platform-launcher")
}

kotlin { compilerOptions { freeCompilerArgs.addAll("-Xjsr305=strict") } }

tasks.withType<Test> { useJUnitPlatform() }

// OpenAPI Generator configuration
openApiGenerate {
  generatorName.set("kotlin-spring")
  inputSpec.set("$rootDir/src/main/resources/openapi.yaml")
  outputDir.set("${layout.buildDirectory.get().asFile}/generated")
  apiPackage.set("smarthome.api")
  modelPackage.set("smarthome.model")
  invokerPackage.set("smarthome.invoker")
  packageName.set("smarthome") // 追加
  configOptions.set(
      mapOf(
          "interfaceOnly" to "true",
          "useTags" to "true",
          "dateLibrary" to "java8",
      ),
  )
}

sourceSets {
  main { kotlin { srcDir("${layout.buildDirectory.get().asFile}/generated/src/main/kotlin") } }
}

tasks.named("openApiGenerate").configure { outputs.upToDateWhen { false } }

tasks.named("compileKotlin").configure { dependsOn("openApiGenerate") }

// Spottless configuration
spotless {
  kotlin {
    ktfmt()
    targetExclude("build/generated/**/*.kt") // 生成されたコードを除外
  }
  kotlinGradle {
    target("*.kts")
    ktfmt()
  }
  java { googleJavaFormat() }
}

tasks.named("build") { dependsOn("spotlessApply") }
