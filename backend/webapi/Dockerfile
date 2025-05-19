# ── Builder ステージ
FROM amazoncorretto:17 AS builder
WORKDIR /workspace
COPY . .
RUN ./gradlew clean bootJar --no-daemon

# ── Runtime ステージ
FROM amazoncorretto:17 AS runtime
WORKDIR /app
COPY --from=builder /workspace/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]