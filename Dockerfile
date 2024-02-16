# Stage 1: Build React app
FROM node:14 AS react-build
WORKDIR /app
COPY ./example-client/ /app
RUN npm install
RUN npm run build

# Stage 2: Build Spring Boot app
FROM eclipse-temurin:17 AS spring-build
WORKDIR /app
COPY ./example/ /app
RUN mvn package

# Stage 3: Combine React and Spring Boot apps
FROM eclipse-temurin:17
WORKDIR /app
COPY --from=spring-build /app/target/*.jar /app/app.jar
COPY --from=react-build /app/build /app/src
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
