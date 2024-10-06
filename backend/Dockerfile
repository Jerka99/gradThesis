FROM eclipse-temurin:22-jdk-alpine
VOLUME /tmp
ARG VERSION=latest
COPY target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["sh", "-c", "java -jar /app.jar --server.port=${PORT:8080}"]
