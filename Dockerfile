FROM gradle:8.4.0-jdk21 AS builder
WORKDIR /app
COPY . .
RUN gradle build -x verifyGoogleJavaFormat

FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
COPY --from=builder /app/build/libs/hipstershop-*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
