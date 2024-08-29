FROM giangndj/jdk:17 AS build

WORKDIR /app
COPY ./src /app/src
COPY ./pom.xml /app/pom.xml
RUN mvn package


FROM eclipse-temurin:17.0.12_7-jre-noble
WORKDIR /app
COPY --from=build /app/target/*.jar /app/app.jar
CMD ["java", "-jar", "app.jar"]
