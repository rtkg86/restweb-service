# REST Web Service

A simple REST API project built with Maven and Spring Boot.

## Prerequisites

- Java 17 or higher
- Maven 3.6 or higher

## Project Structure

```
restweb-service/
├── src/
│   ├── main/
│   │   ├── java/com/rtkg86/restweb/
│   │   │   ├── Application.java
│   │   │   └── controller/
│   │   │       └── ApiController.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
├── pom.xml
└── README.md
```

## Building the Project

```bash
mvn clean install
```

## Running the Application

```bash
mvn spring-boot:run
```

The application will start on `http://localhost:8080`

## API Endpoints

- `GET /api/hello` - Simple greeting
- `GET /api/greet/{name}` - Greet with a name
- `POST /api/echo` - Echo back the request body
- `GET /api/health` - Health check endpoint

## Example Requests

### GET Hello
```bash
curl http://localhost:8080/api/hello
```

### GET Greet
```bash
curl http://localhost:8080/api/greet/John
```

### POST Echo
```bash
curl -X POST http://localhost:8080/api/echo \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello World"}'
```

### Health Check
```bash
curl http://localhost:8080/api/health
```

## Next Steps

1. Add more controllers for your specific REST API requirements
2. Implement service and model classes for business logic
3. Add database integration using Spring Data JPA
4. Configure security with Spring Security if needed
5. Add API documentation with Springdoc OpenAPI/Swagger

## Technology Stack

- **Framework**: Spring Boot 3.2.0
- **Build Tool**: Maven
- **Java Version**: 17
- **HTTP Server**: Embedded Tomcat

