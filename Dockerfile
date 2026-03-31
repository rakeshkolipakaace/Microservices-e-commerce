# ---------- Stage 1: Build ----------
FROM gradle:8.4.0-jdk21 AS builder

WORKDIR /app
COPY build.gradle settings.gradle ./
COPY src ./src

RUN gradle build -x verifyGoogleJavaFormat

# ---------- Stage 2: Run ----------
FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app
COPY --from=builder /app/build/libs/adservice-*.jar app.jar

CMD ["java", "-jar", "app.jar"]
