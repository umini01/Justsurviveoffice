FROM eclipse-temurin:17-jdk
WORKDIR /app
COPY build/libs/Justsurviveoffice-0.0.1-SNAPSHOT.war app.war
EXPOSE 9090
ENTRYPOINT [ "java","-jar","app.war" ]