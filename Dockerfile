# ===== Build Stage =====
FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /app

# Copy pom.xml first
COPY pom.xml .

# Download dependencies
RUN mvn -B -q -DskipTests dependency:go-offline

# Copy source
COPY src ./src

# Build application
RUN mvn clean package -DskipTests

# ===== Runtime Stage =====
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
