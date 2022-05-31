FROM openjdk:11
LABEL maintainer="kukim <kukim.dev@gmail.com>, jerry <hsjang0405@gmail.com>"
LABEL title="CodeSquad : Airbnb Project"
LABEL version="0.0.1"
LABEL description="openjdk 11"
ARG JAR_FILE=./build/libs/airbnb-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]
