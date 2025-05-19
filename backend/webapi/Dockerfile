# ── Builder ステージ (Amazon Corretto 17)
FROM amazoncorretto:17 AS builder
WORKDIR /workspace
COPY . .
RUN ./gradlew clean bootJar --no-daemon

# ── Runtime ステージ (軽量 JRE)
FROM amazoncorretto:17-jre AS runtime
WORKDIR /app
COPY --from=builder /workspace/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]