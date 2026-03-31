FROM gradle:8.4.0-jdk17-alpine AS builder
WORKDIR /app
COPY build.gradle settings.gradle ./
COPY src ./src
RUN gradle build

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/build/libs/adservice-*.jar app.jar
CMD ["java", "-jar", "app.jar"]
