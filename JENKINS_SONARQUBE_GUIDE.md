# Jenkins & SonarQube Integration - Quick Reference

## 📋 What's Included

This project now has a complete CI/CD setup with:

- ✅ **Jenkins Pipeline** - Automated build, test, and deploy pipeline
- ✅ **SonarQube Integration** - Code quality analysis and reporting
- ✅ **JaCoCo Code Coverage** - Test coverage tracking
- ✅ **Docker Support** - Containerized application
- ✅ **GitHub Actions** - Alternative cloud-based CI/CD
- ✅ **Docker Compose** - Easy local development environment

## 🚀 Quick Start (5 minutes)

### Option 1: Using Setup Script (Recommended)

```bash
cd /Users/rajat/IdeaProjects/restweb-service

# Make script executable and run
chmod +x setup-cicd.sh
./setup-cicd.sh
```

### Option 2: Manual Docker Compose

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

## 🔗 Access Points After Startup

| Service | URL | Credentials |
|---------|-----|-------------|
| **SonarQube** | http://localhost:9000 | admin / admin |
| **Jenkins** | http://localhost:8081 | See setup logs |
| **PostgreSQL** | localhost:5432 | sonar / sonar |

## 📝 Initial Setup Steps

### 1. SonarQube Configuration

```bash
# Access SonarQube at http://localhost:9000
# 1. Login with admin/admin
# 2. Go to Profile → My Account → Security
# 3. Generate Token (copy and save)
# 4. Create a project with key: restweb-service
```

### 2. Jenkins Configuration

```bash
# Access Jenkins at http://localhost:8081
# 1. Complete setup wizard
# 2. Go to Manage Jenkins → Credentials
# 3. Add SonarQube token from step 1
# 4. Create new Pipeline job
```

### 3. Create Jenkins Pipeline Job

1. **New Item** → Enter name: `restweb-service`
2. **Pipeline** type
3. **Definition**: Pipeline script from SCM
4. **SCM**: Git
5. **Repository URL**: Your git repo
6. **Script Path**: `Jenkinsfile`
7. Save and build

## 🏗️ CI/CD Pipeline Stages

```
┌──────────────┐
│   Checkout   │ (Get code from Git)
└──────┬───────┘
       ↓
┌──────────────┐
│    Build     │ (Compile with Maven)
└──────┬───────┘
       ↓
┌──────────────────┐
│  Unit Tests      │ (Run JUnit tests)
└──────┬───────────┘
       ↓
┌──────────────────────┐
│ SonarQube Analysis   │ (Code quality check)
└──────┬───────────────┘
       ↓
┌──────────────────────┐
│ Docker Build         │ (Build image)
└──────┬───────────────┘
       ↓
┌──────────────────────┐
│ Deploy to Staging    │ (Run container)
└──────┬───────────────┘
       ↓
┌──────────────────────┐
│ Integration Tests    │ (Health check)
└──────────────────────┘
```

## 🔨 Common Maven Commands

```bash
# Clean build with tests
mvn clean install

# Build without tests (faster)
mvn clean package -DskipTests

# Run only tests
mvn test

# Run SonarQube analysis locally
mvn sonar:sonar \
  -Dsonar.projectKey=restweb-service \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=YOUR_TOKEN_HERE

# Generate code coverage report
mvn test jacoco:report
```

## 🐳 Docker Commands

```bash
# Build image
docker build -t restweb-service:latest .

# Run container
docker run -p 8080:8080 restweb-service:latest

# View container logs
docker logs -f restweb-service

# Stop container
docker stop restweb-service
```

## 📊 SonarQube Code Quality Gates

Key metrics tracked:

- **Code Coverage**: Target 80%+
- **Code Smells**: Issues to refactor
- **Bugs**: Detected issues
- **Vulnerabilities**: Security issues
- **Duplicated Lines**: Code duplication %

## 📁 Project Files

| File | Purpose |
|------|---------|
| `Jenkinsfile` | Jenkins pipeline configuration |
| `sonar-project.properties` | SonarQube settings |
| `docker-compose.yml` | Services orchestration |
| `Dockerfile` | Application containerization |
| `.github/workflows/ci-cd.yml` | GitHub Actions workflow |
| `pom.xml` | Maven + plugins configuration |

## 🆘 Troubleshooting

### SonarQube won't start
```bash
# Check system max map count
sysctl vm.max_map_count

# Increase if needed (Linux/Mac)
docker-compose exec sonarqube \
  sysctl -w vm.max_map_count=262144
```

### Jenkins can't reach SonarQube
```bash
# Check network connectivity
docker-compose exec jenkins \
  curl http://sonarqube:9000/api/system/health

# Check SonarQube is running
docker-compose logs sonarqube
```

### Port already in use
```bash
# Change port in docker-compose.yml
# Example: "9001:9000" for SonarQube
```

### Clear everything and restart
```bash
docker-compose down -v
docker-compose up -d
```

## 📚 Resources

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [SonarQube Guide](https://docs.sonarqube.org/)
- [Docker Documentation](https://docs.docker.com/)
- [Maven Guide](https://maven.apache.org/guides/)

## 🎯 Learning Path

1. ✅ Start services with Docker Compose
2. ✅ Access and configure SonarQube
3. ✅ Configure Jenkins for your Git repo
4. ✅ Trigger a build manually
5. ✅ Review SonarQube analysis results
6. ✅ Fix code quality issues
7. ✅ Configure git webhooks for auto-build
8. ✅ Set up deployment to production

## 💡 Tips

- **Never commit credentials** - Use Jenkins credentials management
- **Monitor build trends** - Check SonarQube dashboard regularly
- **Set quality gates** - Enforce minimum standards
- **Use feature branches** - Test before merging to main
- **Automate deployment** - Once confident with pipeline

## 🔒 Security Considerations

- Change default SonarQube password immediately
- Use strong Jenkins admin password
- Store secrets in Jenkins credentials, not code
- Enable HTTPS for production
- Use private Docker registries
- Implement access controls

---

**For detailed setup instructions, refer to `CICD_SETUP.md`**

