# Use an official Gradle image to build the project
FROM gradle:8.2.1-jdk17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Gradle wrapper files, build script, and source code
COPY gradlew gradlew.bat /app/
COPY gradle /app/gradle
COPY build.gradle settings.gradle /app/
COPY src /app/src

# Build the project and create an executable JAR file
RUN ./gradlew build --no-daemon

# Use an official OpenJDK runtime as the base image for the application
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the executable JAR from the build stage to the runtime image
COPY --from=build /app/build/libs/*.jar app.jar

# Expose the port on which the application will run
EXPOSE 8080

# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]