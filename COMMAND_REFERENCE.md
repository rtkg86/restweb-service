# 🔧 Quick Command Reference Card

## 📋 Print This or Bookmark It!

---

## 🚀 SETUP & START

### Fastest Setup
```bash
cd /Users/rajat/IdeaProjects/restweb-service
chmod +x setup-cicd.sh
./setup-cicd.sh
```

### Manual Start
```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

---

## 🐳 DOCKER & DOCKER-COMPOSE

### View Services
```bash
docker-compose ps                           # List running services
docker-compose images                       # List images
docker-compose version                      # Check version
```

### Manage Services
```bash
docker-compose up -d                        # Start background
docker-compose start                        # Start stopped services
docker-compose restart [service]            # Restart specific service
docker-compose stop                         # Stop all services
docker-compose down                         # Stop and remove
docker-compose down -v                      # Remove including volumes
```

### View Logs
```bash
docker-compose logs                         # All service logs
docker-compose logs -f                      # Follow logs (stream)
docker-compose logs -f [service]            # Follow specific service
docker-compose logs --tail=50               # Last 50 lines
docker-compose logs [service] | grep ERROR  # Find errors
```

### Execute Commands
```bash
docker-compose exec jenkins bash            # Shell into Jenkins
docker-compose exec sonarqube bash          # Shell into SonarQube
docker-compose exec postgres psql -U sonar  # SQL shell
docker-compose exec maven mvn clean install # Run Maven
```

---

## 🏗️ MAVEN COMMANDS

### Build & Package
```bash
mvn clean install                           # Full build with tests
mvn clean package                           # Package only
mvn clean package -DskipTests               # Skip tests
mvn clean compile                           # Compile only
```

### Testing
```bash
mvn test                                    # Run tests
mvn test -Dtest=ApiControllerTest          # Run specific test
mvn test -Dgroups=UnitTest                 # Run test group
mvn test -DfailIfNoTests=false              # Ignore if no tests
```

### Code Quality
```bash
# SonarQube analysis
mvn sonar:sonar \
  -Dsonar.projectKey=restweb-service \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.login=YOUR_TOKEN_HERE

# Code coverage only
mvn test jacoco:report
```

### Clean & Reset
```bash
mvn clean                                   # Delete target dir
mvn clean validate                          # Validate structure
mvn dependency:tree                         # Show dependency tree
mvn dependency:tree -DoutputFile=deps.txt   # Save to file
```

---

## 🌐 ACCESS & CREDENTIALS

### Service URLs
```
SonarQube:  http://localhost:9000
Jenkins:    http://localhost:8081
API:        http://localhost:8080
PostgreSQL: localhost:5432
```

### Credentials
```
SonarQube:   admin / admin (change on login)
PostgreSQL:  sonar / sonar
Jenkins:     (setup wizard on first access)
```

### Get Jenkins Password
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

---

## 🔍 TROUBLESHOOTING COMMANDS

### Check Port Usage
```bash
# macOS
lsof -i :9000                              # Check port 9000
lsof -i :8081                              # Check port 8081
lsof -i :8080                              # Check port 8080

# Kill process using port
kill -9 $(lsof -t -i :9000)
```

### Health Checks
```bash
# Test connectivity
curl http://localhost:9000                 # SonarQube
curl http://localhost:8081                 # Jenkins
curl http://localhost:8080/api/health      # API

# Check service health
docker-compose ps                           # All services
docker-compose exec sonarqube curl http://localhost:9000/api/system/health
```

### View Container Info
```bash
docker ps                                   # All running containers
docker ps -a                                # All containers
docker images                               # All images
docker volume ls                            # All volumes
docker network ls                           # All networks
```

### Restart Services
```bash
# Restart everything
docker-compose restart

# Restart one service
docker-compose restart jenkins
docker-compose restart sonarqube

# Full restart
docker-compose down
docker-compose up -d
```

---

## 📊 JENKINS COMMANDS

### Via Jenkins CLI
```bash
# List jobs
java -jar jenkins-cli.jar -s http://localhost:8081 list-jobs

# Build job
java -jar jenkins-cli.jar -s http://localhost:8081 build restweb-service-pipeline

# Watch build
java -jar jenkins-cli.jar -s http://localhost:8081 console restweb-service-pipeline
```

### View Logs
```bash
# Jenkins logs
docker-compose logs -f jenkins

# Jenkins master log
docker exec jenkins tail -f /var/jenkins_home/logs/master.log

# Build console output
# Access via: http://localhost:8081/job/restweb-service-pipeline/1/console
```

---

## 📈 SONARQUBE COMMANDS

### API Calls
```bash
# Get project info
curl -u admin:password http://localhost:9000/api/projects/search?key=restweb-service

# Get project quality gate status
curl -u admin:password http://localhost:9000/api/qualitygates/project_status?projectKey=restweb-service

# List quality gates
curl -u admin:password http://localhost:9000/api/qualitygates/list
```

### Via Web Interface
```
1. Login: http://localhost:9000
2. Analyze project: Projects menu
3. View metrics: Dashboard
4. Set quality gates: Administration → Quality Gates
5. Create token: Profile → My Account → Security
```

---

## 💾 BACKUP & RESTORE

### Backup Volumes
```bash
# List volumes
docker volume ls

# Backup volume
docker run --rm -v sonarqube_data:/data -v $(pwd):/backup \
  ubuntu tar czf /backup/sonarqube.tar.gz -C /data .

# Restore volume
docker run --rm -v sonarqube_data:/data -v $(pwd):/backup \
  ubuntu tar xzf /backup/sonarqube.tar.gz -C /data
```

### Backup Jenkins
```bash
# Copy Jenkins home
docker cp jenkins:/var/jenkins_home ./jenkins-backup

# Restore Jenkins
docker cp jenkins-backup jenkins:/var/jenkins_home
```

---

## 🔐 SECURITY COMMANDS

### Change Passwords
```bash
# SonarQube - do via web UI
# Jenkins - do via web UI
# PostgreSQL - update via SQL
docker-compose exec postgres psql -U sonar -d sonarqube \
  -c "ALTER USER sonar WITH PASSWORD 'newpassword';"
```

### View Credentials
```bash
# Jenkins credentials file
docker exec jenkins cat /var/jenkins_home/credentials.xml

# Environment variables
docker-compose exec jenkins env | grep -i sonar
```

---

## 📦 BUILD & DEPLOY

### Build Docker Image
```bash
# Build with version
docker build -t restweb-service:1.0.0 .
docker tag restweb-service:1.0.0 restweb-service:latest

# Build and run
docker build -t restweb-service . && \
docker run -p 8080:8080 restweb-service
```

### Push to Registry
```bash
# Login to registry
docker login registry.example.com

# Tag image
docker tag restweb-service:latest registry.example.com/restweb-service:latest

# Push
docker push registry.example.com/restweb-service:latest
```

---

## 📝 COMMON WORKFLOWS

### Fresh Start
```bash
# Stop everything
docker-compose down -v

# Remove images
docker rmi sonarqube:lts postgres:15-alpine jenkins/jenkins:lts

# Start fresh
docker-compose up -d
```

### Debug Pipeline
```bash
# Watch logs while building
docker-compose logs -f jenkins

# Check build output
# Visit: http://localhost:8081/job/restweb-service-pipeline/
```

### Fix SonarQube Issues
```bash
# Restart SonarQube
docker-compose restart sonarqube

# Wait for startup
sleep 30

# Check health
curl http://localhost:9000/api/system/health
```

### Update Dependencies
```bash
# Check updates
mvn versions:display-dependency-updates

# Update all
mvn versions:use-latest-versions

# Update plugin versions
mvn versions:display-plugin-updates
```

---

## 🔗 USEFUL LINKS

### Documentation in Project
```
INDEX.md                    - Full navigation
CI_CD_SUMMARY.md           - Quick overview
CICD_SETUP.md              - Detailed setup
JENKINS_SONARQUBE_GUIDE.md - Quick reference
CI_CD_BEST_PRACTICES.md    - Advanced topics
SETUP_CHECKLIST.md         - Verification items
```

### External Resources
```
Jenkins:    https://www.jenkins.io/doc/
SonarQube:  https://docs.sonarqube.org/
Docker:     https://docs.docker.com/
Maven:      https://maven.apache.org/guides/
Spring:     https://spring.io/projects/spring-boot
```

---

## 🎯 QUICK DECISION TREE

```
❓ Services won't start?
 └─ Try: docker-compose logs -f
 └─ Try: docker-compose down -v && docker-compose up -d

❓ Jenkins won't connect?
 └─ Try: docker-compose exec jenkins curl http://sonarqube:9000
 └─ Check: SonarQube is running: docker-compose ps

❓ Port already in use?
 └─ Try: lsof -i :9000 (to find it)
 └─ Try: Change port in docker-compose.yml

❓ Build fails?
 └─ Check: docker-compose logs -f jenkins
 └─ Check: Maven build locally: mvn clean install

❓ Need new build?
 └─ Manual: Click "Build Now" in Jenkins
 └─ Automated: Push to Git (if webhook configured)

❓ Need to reset?
 └─ Partial: docker-compose restart [service]
 └─ Full: docker-compose down -v && docker-compose up -d
```

---

## ⏱️ TYPICAL TIMES

| Task | Time |
|------|------|
| Setup with script | 5-10 min |
| Services to start | 3-5 min |
| Maven build | 1-2 min |
| SonarQube analysis | 30-60 sec |
| Full pipeline | 5-10 min |

---

## ✨ PRO TIPS

```
1. Keep this card open while working
2. Services slow? Check: docker stats
3. Lost? Go to: INDEX.md
4. Stuck? Check: Docker logs first
5. Test locally: mvn clean install
6. Monitor: Keep dashboards open
7. Learn: Read one guide per day
8. Practice: Run builds frequently
```

---

**Print & Keep Handy! 📌**

*Last updated: February 12, 2026*

