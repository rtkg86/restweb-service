# ✅ CI/CD Setup Checklist

## Pre-Setup Requirements
- [ ] Docker installed (`docker --version`)
- [ ] Docker Compose installed (`docker-compose --version`)
- [ ] Git installed and repository initialized
- [ ] Sufficient disk space (5GB+ recommended)
- [ ] Ports available: 8080, 8081, 9000, 5432

## Installation Steps

### Step 1: Quick Setup (Recommended)
```bash
cd /Users/rajat/IdeaProjects/restweb-service
chmod +x setup-cicd.sh
./setup-cicd.sh
```

**Checklist:**
- [ ] Script executed successfully
- [ ] SonarQube starting (check logs)
- [ ] Jenkins starting (check logs)
- [ ] PostgreSQL starting (check logs)
- [ ] Access URLs displayed
- [ ] Wait 3-5 minutes for services

### Step 2: Verify Service Status
```bash
docker-compose ps
```

**Expected Output:**
- [ ] postgres → running
- [ ] sonarqube → running
- [ ] jenkins → running
- [ ] All services healthy

### Step 3: SonarQube Configuration

#### Access SonarQube
- [ ] Navigate to http://localhost:9000
- [ ] Login with: admin / admin
- [ ] Change default password when prompted
- [ ] Read/Accept license agreement

#### Create Security Token
- [ ] Click profile icon (top right)
- [ ] Go to **My Account** → **Security**
- [ ] Click **Generate Tokens**
- [ ] Name: `jenkins-token`
- [ ] Generate token
- [ ] Copy token to clipboard
- [ ] **Save token securely** (you'll need it)

#### Create SonarQube Project (Optional)
- [ ] Click **Projects** → **Create Project**
- [ ] Project Key: `restweb-service`
- [ ] Display Name: `REST Web Service`
- [ ] Next → Main branch
- [ ] Create project

### Step 4: Jenkins Configuration

#### Access Jenkins
- [ ] Navigate to http://localhost:8081
- [ ] Get unlock password from logs or:
  ```bash
  docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
  ```
- [ ] Enter unlock password
- [ ] Click **Install suggested plugins**
- [ ] Wait for plugin installation

#### Create Admin User
- [ ] Enter your admin username
- [ ] Enter your admin password (twice)
- [ ] Enter full name (optional)
- [ ] Enter email (optional)
- [ ] Click **Save and Continue**
- [ ] Click **Save and Finish**

#### Configure Jenkins Credentials
- [ ] Go to **Manage Jenkins** → **Credentials** → **System** → **Global credentials**
- [ ] Click **Add Credentials**
- [ ] Kind: **Secret text**
- [ ] Secret: Paste your SonarQube token
- [ ] ID: `sonarqube-token`
- [ ] Description: `SonarQube Token`
- [ ] Click **Create**

### Step 5: Create Jenkins Pipeline Job

#### New Pipeline Job
- [ ] Click **New Item** (or **+ New Job**)
- [ ] Job name: `restweb-service-pipeline`
- [ ] Select **Pipeline**
- [ ] Click **OK**

#### Configure Pipeline
- [ ] Go to **Definition** section
- [ ] Choose **Pipeline script from SCM**
- [ ] **SCM**: Select **Git**
- [ ] **Repository URL**: Enter your Git repo URL
- [ ] **Branch**: Enter `*/main` or `*/master`
- [ ] **Script Path**: `Jenkinsfile`
- [ ] Click **Save**

### Step 6: Test Pipeline

#### First Build
- [ ] Click **Build Now**
- [ ] Wait for build to complete
- [ ] Check **Console Output** for logs
- [ ] Verify all stages passed

#### Review Results
- [ ] Check **Build Artifacts**
- [ ] Go to SonarQube dashboard
- [ ] Verify project analysis complete
- [ ] Review code quality metrics

---

## Verification Checklist

### Services Running
```bash
docker-compose ps
```
- [ ] postgres: Up and running
- [ ] sonarqube: Up and running  
- [ ] jenkins: Up and running

### Port Accessibility
```bash
# Test each port
curl http://localhost:8080/api/health
curl http://localhost:8081
curl http://localhost:9000
```
- [ ] Port 8080: Application responds
- [ ] Port 8081: Jenkins accessible
- [ ] Port 9000: SonarQube accessible
- [ ] Port 5432: PostgreSQL listening

### Pipeline Execution
- [ ] Jenkins job created successfully
- [ ] First build completed
- [ ] All pipeline stages executed
- [ ] No error messages in logs

### Code Quality
- [ ] SonarQube analysis completed
- [ ] Code metrics displayed
- [ ] Coverage report generated
- [ ] Quality gate evaluated

---

## Common Issues & Fixes

### Issue: Services won't start
**Solution:**
```bash
# Check Docker service
docker ps

# View logs
docker-compose logs -f

# Restart services
docker-compose restart
```
- [ ] Docker daemon running
- [ ] Ports not already in use
- [ ] Sufficient memory available

### Issue: Jenkins won't connect to SonarQube
**Solution:**
```bash
# Test connectivity
docker-compose exec jenkins curl http://sonarqube:9000

# Check SonarQube health
docker-compose logs sonarqube | tail -20
```
- [ ] SonarQube fully started (wait 2-3 min)
- [ ] Network connectivity verified
- [ ] Correct URL in Jenkins config

### Issue: Port already in use
**Solution:**
```bash
# Find process using port
lsof -i :9000

# Kill process or change docker-compose port
# Change "9000:9000" to "9001:9000" etc
```
- [ ] Port freed or changed
- [ ] docker-compose.yml updated
- [ ] Services restarted

### Issue: Insufficient memory for SonarQube
**Solution:**
```bash
# Increase Docker memory
# In Docker Desktop: Preferences → Resources → Memory (set to 4GB+)

# Or set memory limit in docker-compose.yml
```
- [ ] Docker memory increased
- [ ] Services restarted
- [ ] SonarQube started successfully

---

## Post-Setup Learning Path

### Day 1: Understanding the Setup
- [ ] Read: `CI_CD_SUMMARY.md`
- [ ] Read: `JENKINS_SONARQUBE_GUIDE.md`
- [ ] Explore SonarQube dashboard
- [ ] Explore Jenkins dashboard
- [ ] Run first manual build

### Day 2: Deep Dive
- [ ] Read: `CICD_SETUP.md`
- [ ] Trigger build manually
- [ ] Review pipeline logs
- [ ] Analyze SonarQube metrics
- [ ] Review code coverage report

### Day 3: Configuration
- [ ] Read: `CI_CD_BEST_PRACTICES.md`
- [ ] Add quality gates in SonarQube
- [ ] Configure build notifications
- [ ] Optimize pipeline stages
- [ ] Update Jenkinsfile

### Day 4: Integration
- [ ] Set up GitHub webhooks
- [ ] Enable auto-triggered builds
- [ ] Configure Slack notifications
- [ ] Add security scanning
- [ ] Monitor build metrics

### Day 5: Optimization
- [ ] Analyze pipeline bottlenecks
- [ ] Optimize build duration
- [ ] Improve code coverage
- [ ] Set up production deployment
- [ ] Create monitoring dashboard

---

## Documentation Reference

| File | Purpose | Read Time |
|------|---------|-----------|
| INDEX.md | Documentation index | 5 min |
| CI_CD_SUMMARY.md | Quick overview | 5 min |
| CICD_SETUP.md | Detailed setup | 20 min |
| JENKINS_SONARQUBE_GUIDE.md | Quick reference | 15 min |
| CI_CD_BEST_PRACTICES.md | Advanced topics | 30 min |

---

## Important Credentials & Tokens

**Keep these safe!**

### SonarQube
- URL: http://localhost:9000
- Token: `_____________________` (Save here)
- Password: `_____________________` (Save here)

### Jenkins  
- URL: http://localhost:8081
- Username: `_____________________`
- Password: `_____________________`

### Git Repository
- URL: `_____________________`
- Branch: `main` or `master`

### Docker Registry (if used)
- Registry: `_____________________`
- Username: `_____________________`
- Password: `_____________________`

---

## Useful Commands Quick Reference

### Docker
```bash
docker-compose up -d              # Start services
docker-compose ps                 # List services
docker-compose logs -f [service]  # View logs
docker-compose stop               # Stop services
docker-compose down -v            # Remove all
```

### Maven
```bash
mvn clean install                 # Build and test
mvn test                          # Run tests
mvn sonar:sonar                   # SonarQube analysis
```

### Jenkins (via CLI)
```bash
java -jar jenkins-cli.jar -s http://localhost:8081 build restweb-service-pipeline
```

---

## Success Criteria

Your setup is complete when:

- [ ] ✅ Docker services running
- [ ] ✅ SonarQube accessible and configured
- [ ] ✅ Jenkins accessible and configured
- [ ] ✅ Pipeline job created
- [ ] ✅ First build executed successfully
- [ ] ✅ Code analysis completed
- [ ] ✅ Coverage report generated
- [ ] ✅ All documentation reviewed
- [ ] ✅ Team trained on usage

---

## Next Steps After Setup

### Immediate
- [ ] Commit all files to Git
- [ ] Push to your repository
- [ ] Set up GitHub webhooks

### Short Term
- [ ] Add more unit tests
- [ ] Increase code coverage
- [ ] Fix code quality issues
- [ ] Configure notifications

### Medium Term
- [ ] Add integration tests
- [ ] Add security scanning
- [ ] Set up staging environment
- [ ] Configure auto-deployment

### Long Term
- [ ] Production deployment
- [ ] Advanced monitoring
- [ ] Performance optimization
- [ ] Team training program

---

## Troubleshooting Quick Links

- SonarQube Issues → See `JENKINS_SONARQUBE_GUIDE.md#troubleshooting`
- Jenkins Issues → See `CICD_SETUP.md#troubleshooting`
- Pipeline Issues → See `CI_CD_BEST_PRACTICES.md`
- General Help → See `INDEX.md#-need-help`

---

## Sign-Off

- [ ] Setup completed by: `_________________`
- [ ] Date completed: `_________________`
- [ ] Verified by: `_________________`
- [ ] Team trained: `_________________`

---

**Status: ✅ COMPLETE** 

Your CI/CD pipeline with Jenkins and SonarQube is now ready for learning and development!

Next: Read [`CI_CD_SUMMARY.md`](CI_CD_SUMMARY.md) and start exploring! 🚀

