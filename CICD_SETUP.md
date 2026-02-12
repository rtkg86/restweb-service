# CI/CD Setup Guide with Jenkins and SonarQube

This guide will help you set up a complete CI/CD pipeline using Jenkins and SonarQube for code quality checks.

## Prerequisites

- Docker and Docker Compose installed
- Git repository initialized
- Maven 3.6+ (optional, will use Docker image)

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CI/CD Pipeline                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Git Commit → Jenkins Pipeline                             │
│               ├─ Checkout Code                             │
│               ├─ Build (Maven)                             │
│               ├─ Unit Tests                                │
│               ├─ SonarQube Analysis → Quality Gate        │
│               ├─ Build Docker Image                       │
│               ├─ Push to Registry (optional)              │
│               ├─ Deploy to Staging                        │
│               └─ Integration Tests                        │
│                                                              │
│  SonarQube Dashboard (http://localhost:9000)              │
│  Jenkins Dashboard (http://localhost:8081)                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Quick Start

### 1. Start Services with Docker Compose

```bash
# Navigate to project directory
cd /Users/rajat/IdeaProjects/restweb-service

# Start all services (Jenkins, SonarQube, PostgreSQL)
docker-compose up -d

# Wait 2-3 minutes for services to start
# Check status
docker-compose ps
```

### 2. Access SonarQube

- **URL**: http://localhost:9000
- **Default Credentials**: 
  - Username: `admin`
  - Password: `admin`
- **First Login**: You'll be prompted to change the password

#### Create SonarQube Token

1. Log in to SonarQube
2. Click on your profile icon (top right)
3. Go to **My Account** → **Security** → **Generate Tokens**
4. Create a token named `jenkins-token`
5. Copy the token and save it safely

### 3. Access Jenkins

- **URL**: http://localhost:8081
- **Initial Setup**: 
  - Unlock Jenkins and complete initial setup wizard
  - Install suggested plugins
  - Create first admin user

#### Get Jenkins Initial Password

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

#### Configure Jenkins Credentials

1. Go to **Manage Jenkins** → **Credentials** → **System** → **Global credentials**
2. Click **Add Credentials**
3. Create a new credential with:
   - **Kind**: Secret text
   - **Secret**: Paste the SonarQube token from step 2
   - **ID**: `sonarqube-token`

#### Create Jenkins Pipeline Job

1. Click **New Item**
2. Enter job name: `restweb-service-pipeline`
3. Select **Pipeline**
4. In **Definition**, choose **Pipeline script from SCM**
5. Configure SCM:
   - **SCM**: Git
   - **Repository URL**: Your Git repository URL
   - **Branch**: `*/main` or `*/master`
6. **Script Path**: `Jenkinsfile`
7. Save and build

### 4. Run Maven Build Locally (Optional)

```bash
# Build and run tests
mvn clean install

# Build with SonarQube analysis
mvn clean install sonar:sonar \
  -Dsonar.projectKey=restweb-service \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=<YOUR_SONARQUBE_TOKEN>

# Build and run only unit tests
mvn clean test

# Build without tests
mvn clean package -DskipTests
```

## File Descriptions

### `Jenkinsfile`
- Defines the complete CI/CD pipeline stages
- Stages: Checkout, Build, Unit Tests, SonarQube Analysis, Docker Build, Deploy, Integration Tests
- Post actions for test results and code coverage

### `sonar-project.properties`
- SonarQube project configuration
- Defines source paths, test paths, and coverage settings
- Can be customized for different quality profiles

### `Dockerfile`
- Multi-stage Docker build for the application
- Builder stage compiles the Maven project
- Runtime stage creates lightweight Alpine-based image
- Exposes port 8080

### `docker-compose.yml`
- Orchestrates Jenkins, SonarQube, PostgreSQL, and Maven services
- Sets up networking for inter-service communication
- Configures persistent volumes

### `pom.xml` (Updated)
- Added SonarQube Maven plugin
- Added JaCoCo for code coverage tracking
- Added compiler and surefire plugins

## Key Features

### Code Quality Analysis
- **SonarQube**: Static code analysis with quality gates
- **JaCoCo**: Code coverage reporting
- **Automatic Quality Gate**: Pipeline blocks if quality thresholds not met

### Testing
- **Unit Tests**: Maven Surefire plugin runs tests
- **Integration Tests**: Health check curl in staging environment
- **Test Reports**: Published in Jenkins dashboard

### Containerization
- **Multi-stage Docker builds**: Optimized image size
- **Docker Registry**: Ready for Docker Hub/ECR integration

### Monitoring
- **Build Logs**: Jenkins dashboard shows detailed logs
- **Code Coverage Reports**: HTML reports generated after tests
- **SonarQube Dashboard**: Real-time code quality metrics

## Useful Commands

```bash
# View logs
docker-compose logs -f sonarqube
docker-compose logs -f jenkins
docker-compose logs -f postgres

# Stop services
docker-compose stop

# Start services
docker-compose start

# Restart services
docker-compose restart

# Remove services and volumes
docker-compose down -v

# Execute Maven in container
docker-compose exec maven mvn clean install

# Build Docker image manually
docker build -t restweb-service:1.0.0 .

# Run container
docker run -p 8080:8080 restweb-service:1.0.0
```

## Next Steps

1. **Configure Git Webhook**: Set up GitHub/GitLab webhooks to trigger Jenkins automatically
2. **Add Code Coverage Requirements**: Set minimum coverage % in SonarQube quality gates
3. **Integrate with Slack**: Add Slack notifications on build success/failure
4. **Add Load Testing**: Integrate JMeter or Gatling for performance testing
5. **Production Deployment**: Add staging and production environments
6. **Security Scanning**: Add OWASP dependency check and code scanning
7. **Database Integration**: Add database tests with Testcontainers

## Troubleshooting

### SonarQube not starting
```bash
# Check logs
docker-compose logs sonarqube

# Increase memory if needed
docker-compose exec sonarqube sysctl -w vm.max_map_count=262144
```

### Jenkins can't connect to SonarQube
- Ensure both containers are on same network
- Check firewall settings
- Verify SonarQube is fully started (health check)

### Pipeline fails at SonarQube stage
- Verify SonarQube token is correct
- Check SonarQube URL is accessible
- Review SonarQube logs for errors

## Learning Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [SonarQube Documentation](https://docs.sonarqube.org/)
- [Maven Documentation](https://maven.apache.org/guides/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

