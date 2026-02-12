# CI/CD Best Practices & Monitoring Guide

## 📈 Monitoring Your Pipeline

### Jenkins Dashboard

**Key Metrics to Monitor:**

1. **Build Success Rate**
   - Target: > 95% success rate
   - Investigate failures immediately
   - Track failure trends

2. **Build Duration**
   - Target: < 5 minutes for basic pipeline
   - Profile slow stages
   - Optimize build cache

3. **Test Coverage**
   - Target: > 80% code coverage
   - Gradually increase coverage over time
   - Focus on critical paths first

### SonarQube Dashboard

**Key Metrics:**

```
Reliability (Bugs)
  ├─ Critical issues: 0
  ├─ Major issues: Monitor trends
  └─ Minor issues: Acceptable

Security (Vulnerabilities)
  ├─ Critical: 0 tolerance
  ├─ High: Review and fix
  └─ Medium/Low: Track trends

Maintainability (Code Smells)
  ├─ Technical Debt Ratio: < 5%
  ├─ Duplicated Lines: < 3%
  └─ Cognitive Complexity: Monitor

Coverage
  ├─ Lines: Target 80%+
  ├─ Branches: Target 75%+
  └─ Functions: Track improvements
```

## ✅ Pipeline Best Practices

### 1. Code Quality

```groovy
// In Jenkinsfile - Quality Gate Stage
stage('Quality Gate') {
    steps {
        sh '''
            mvn sonar:sonar \
                -Dsonar.projectKey=restweb-service \
                -Dsonar.qualitygate.wait=true
        '''
    }
}
```

**Action Items:**
- ✅ Enable quality gates in SonarQube
- ✅ Set minimum pass criteria
- ✅ Block builds on gate failure
- ✅ Review and fix issues regularly

### 2. Test Strategy

**Unit Tests:**
```bash
# Target: 80%+ coverage
mvn test -Dgroups=UnitTest
```

**Integration Tests:**
```bash
# Test service integration
mvn verify -Dgroups=IntegrationTest
```

**End-to-End Tests:**
```bash
# Full system testing
mvn verify -Dgroups=E2ETest
```

### 3. Security Scanning

Add to pom.xml:
```xml
<!-- OWASP Dependency Check -->
<plugin>
    <groupId>org.owasp</groupId>
    <artifactId>dependency-check-maven</artifactId>
    <version>8.4.2</version>
    <configuration>
        <failBuildOnCVSS>7</failBuildOnCVSS>
    </configuration>
</plugin>
```

Add to Jenkinsfile:
```groovy
stage('Security Scan') {
    steps {
        sh 'mvn dependency-check:check'
    }
}
```

### 4. Code Review Checkpoints

```
Developer → Git Push
    ↓
GitHub/GitLab Pull Request
    ↓
Jenkins Auto Build & Test
    ↓
SonarQube Analysis
    ↓
Human Code Review
    ↓
Approval & Merge
    ↓
Production Deployment
```

### 5. Artifact Management

```bash
# Build and tag artifacts
docker build -t restweb-service:${BUILD_NUMBER} .

# Push to registry
docker push registry.example.com/restweb-service:${BUILD_NUMBER}

# Tag as latest
docker tag registry.example.com/restweb-service:${BUILD_NUMBER} \
           registry.example.com/restweb-service:latest
```

## 🔄 CI/CD Pipeline Optimization

### Stage 1: Fast Feedback
```
Checkout → Lint → Compile → Unit Tests
(< 2 minutes target)
```

### Stage 2: Quality Checks
```
Code Coverage → SonarQube → Security Scan
(2-3 minutes target)
```

### Stage 3: Integration
```
Build Docker → Push Registry → Integration Tests
(1-2 minutes target)
```

### Stage 4: Deployment
```
Deploy Staging → Smoke Tests → Production Deploy
(1-2 minutes target)
```

**Total Pipeline Target: < 10 minutes**

## 📋 Maintenance Tasks

### Daily
- ✅ Monitor failed builds
- ✅ Check code quality trends
- ✅ Review SonarQube alerts

### Weekly
- ✅ Review security vulnerabilities
- ✅ Analyze code coverage trends
- ✅ Optimize slow stages
- ✅ Update dependencies (with testing)

### Monthly
- ✅ Review and update build parameters
- ✅ Analyze pipeline efficiency
- ✅ Plan quality improvements
- ✅ Update documentation

### Quarterly
- ✅ Major dependency upgrades
- ✅ Infrastructure review
- ✅ Security audit
- ✅ Disaster recovery testing

## 🚨 Alert Thresholds

### Critical (Immediate Action)
```
- Build failure rate > 50%
- Security vulnerabilities: Critical
- Code coverage drop > 10%
- Pipeline timeout
```

### Warning (Within 24 hours)
```
- Code smell increase > 20%
- SonarQube quality gate failure
- Build duration > 2x average
- Test failure ratio > 5%
```

### Info (Track & Improve)
```
- Coverage increase tracked
- Performance improvements
- Deployment frequency metrics
```

## 🔧 Advanced Configuration

### Parallel Execution

```groovy
stage('Parallel Tests') {
    parallel {
        stage('Unit Tests') {
            steps {
                sh 'mvn test -Dgroups=UnitTest'
            }
        }
        stage('Integration Tests') {
            steps {
                sh 'mvn verify -Dgroups=IntegrationTest'
            }
        }
    }
}
```

### Conditional Deployment

```groovy
stage('Deploy Production') {
    when {
        branch 'main'
        expression {
            currentBuild.result == 'SUCCESS'
        }
    }
    steps {
        script {
            sh './scripts/deploy-prod.sh'
        }
    }
}
```

### Notifications

```groovy
post {
    always {
        // Slack notification
        slackSend(
            channel: '#deployments',
            message: "Build ${BUILD_NUMBER} ${currentBuild.result}",
            color: currentBuild.result == 'SUCCESS' ? 'good' : 'danger'
        )
    }
}
```

## 📊 Metrics to Track

### Build Metrics
- Build frequency (deployments per day)
- Build duration (time to complete)
- Build success rate (%)
- Failed build recovery time

### Quality Metrics
- Code coverage (%)
- Technical debt ratio (%)
- Code smell density (issues per 1000 LOC)
- Duplicate code rate (%)

### Testing Metrics
- Test pass rate (%)
- Test execution time (minutes)
- Defects found per 1000 LOC
- Critical bug escape rate

### Deployment Metrics
- Deployment frequency (per week/month)
- Deployment duration (minutes)
- Rollback rate (%)
- Mean time to recovery (MTTR)

## 🎓 Continuous Improvement

### Weekly Review Meeting

**Agenda:**
1. Review pipeline metrics
2. Identify bottlenecks
3. Plan optimizations
4. Update documentation
5. Team training needs

### Sample Questions

- What made the build fail?
- How can we detect issues earlier?
- Can we reduce pipeline duration?
- Are we testing the right things?
- Is code quality improving?

## 🔗 Integration Examples

### Slack Notifications
```groovy
slackSend(
    webhookUrl: 'https://hooks.slack.com/...',
    message: "Build ${BUILD_NUMBER} deployed successfully"
)
```

### Email Reports
```groovy
emailext(
    subject: "Build Report - ${BUILD_NUMBER}",
    body: "See attached report",
    attachmentsPattern: '**/jacoco.html'
)
```

### GitHub Status
```groovy
githubNotify(
    status: 'FAILURE',
    context: 'continuous-integration/jenkins',
    description: 'Build failed'
)
```

## 📚 Resources

- [Jenkins Best Practices](https://www.jenkins.io/doc/book/pipeline-as-code/)
- [SonarQube Best Practices](https://docs.sonarqube.org/latest/)
- [Google's DORA Metrics](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-devops-performance)

---

**Remember: "Measure what matters, improve what's measured"**

