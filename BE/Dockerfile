FROM openjdk:11
LABEL maintainer="kukim <kukim.dev@gmail.com>, jerry <hsjang0405@gmail.com>"
LABEL title="CodeSquad : Airbnb Project"
LABEL version="0.0.1"
LABEL description="openjdk 11"
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
