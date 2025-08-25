#!/bin/bash
set -e

# Project setup variables
PROJECT_NAME="java-service"
PACKAGE_PATH="com/example/javaservice"

# Create project structure
echo "Creating project structure for $PROJECT_NAME..."
mkdir -p src/main/java/$PACKAGE_PATH
mkdir -p src/main/java/$PACKAGE_PATH/controller
mkdir -p src/main/java/$PACKAGE_PATH/config
mkdir -p src/main/resources
mkdir -p src/test/java/$PACKAGE_PATH
mkdir -p .github/workflows

# Create build.gradle
cat > build.gradle << 'EOF'
plugins {
    id 'org.springframework.boot' version '3.2.3'
    id 'io.spring.dependency-management' version '1.1.4'
    id 'java'
}

group = 'com.example'
version = '0.0.1-SNAPSHOT'
sourceCompatibility = '17'

repositories {
    mavenCentral()
}

dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web'
    implementation 'org.springdoc:springdoc-openapi-starter-webmvc-ui:2.3.0'
    testImplementation 'org.springframework.boot:spring-boot-starter-test'
}

test {
    useJUnitPlatform()
}
EOF

# Create settings.gradle
cat > settings.gradle << EOF
rootProject.name = '$PROJECT_NAME'
EOF

# Create gradlew wrapper scripts (simplified for this example)
touch gradlew
chmod +x gradlew

# Create main application class
cat > src/main/java/$PACKAGE_PATH/JavaServiceApplication.java << 'EOF'
package com.example.javaservice;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class JavaServiceApplication {
    public static void main(String[] args) {
        SpringApplication.run(JavaServiceApplication.class, args);
    }
}
EOF

# Create controller
cat > src/main/java/$PACKAGE_PATH/controller/HelloController.java << 'EOF'
package com.example.javaservice.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@Tag(name = "Hello API", description = "Demo endpoints")
public class HelloController {

    @GetMapping("/hello")
    @Operation(summary = "Say hello", description = "Returns a greeting message")
    public String hello() {
        return "Hello from java-service!";
    }
}
EOF

# Create OpenAPI config
cat > src/main/java/$PACKAGE_PATH/config/OpenApiConfig.java << 'EOF'
package com.example.javaservice.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.Contact;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Java Service API")
                        .version("1.0.0")
                        .description("Spring Boot REST API with Swagger documentation")
                        .contact(new Contact()
                                .name("Your Name")
                                .email("your.email@example.com")));
    }
}
EOF

# Create application.properties
cat > src/main/resources/application.properties << 'EOF'
server.port=8080
springdoc.swagger-ui.path=/swagger-ui.html
springdoc.api-docs.path=/api-docs
EOF

# Create CI/CD workflow
cat > .github/workflows/ci-cd.yml << 'EOF'
name: Java Service CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v3

    - name: Set up JDK 17
      uses: actions/setup-java@v3
      with:
        java-version: '17'
        distribution: 'temurin'
        cache: gradle

    - name: Grant execute permission for gradlew
      run: chmod +x gradlew

    - name: Build with Gradle
      run: ./gradlew build

    - name: Run tests
      run: ./gradlew test

    - name: Build Docker image
      run: |
        # For now just print a message
        echo "Docker image would be built here"
EOF

# Create Dockerfile
cat > Dockerfile << 'EOF'
FROM eclipse-temurin:17-jre-alpine
VOLUME /tmp
ARG JAR_FILE=build/libs/*.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
EOF

# Update README.md
cat > README.md << 'EOF'
# java-service
Just a CI/CD project with Spring Boot and Gradle

## How to run
./gradlew bootRun

## Swagger UI
Access the Swagger UI at http://localhost:8080/swagger-ui.html after starting the application.
EOF

# Initialize git repository
git init
echo "*.class" > .gitignore
echo "build/" >> .gitignore
echo ".gradle/" >> .gitignore
echo ".idea/" >> .gitignore
echo "*.iml" >> .gitignore
echo ".DS_Store" >> .gitignore

echo "Project $PROJECT_NAME created successfully!"
echo "To run the application, execute: cd $PROJECT_NAME && ./gradlew bootRun"