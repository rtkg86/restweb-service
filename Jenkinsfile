pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 1, unit: 'HOURS')
    }

    environment {
        // Default Sonar host (override in Jenkins job if needed)
        SONAR_HOST_URL = 'http://localhost:9000'
        // The Jenkins credential ID that stores the Sonar token (create this secret text in Jenkins)
        SONAR_CREDENTIALS_ID = 'sonar-token'
        // The Jenkins credential ID used to access the Git repository (create this as 'Username with password' where password is a GitHub PAT)
        GIT_CREDENTIALS_ID = 'github-credentials'
        // Git repository URL
        GIT_REPO_URL = 'https://github.com/rtkg86/restweb-service.git'
        // Branch to check out (adjust if your repo uses 'master')
        GIT_BRANCH = 'main'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '=============== Checking out code ==============='
                // Ensure workspace is clean before attempting to configure remote/origin
                deleteDir()
                // Use explicit 'git' step with credentialsId to avoid anonymous access issues
                git branch: env.GIT_BRANCH, url: env.GIT_REPO_URL, credentialsId: env.GIT_CREDENTIALS_ID
            }
        }

        stage('Build') {
            steps {
                echo '=============== Building project ==============='
                sh 'mvn clean package -DskipTests || true'
            }
        }

        stage('Unit Tests') {
            steps {
                echo '=============== Running unit tests ==============='
                sh 'mvn test || true'
            }
            post {
                always {
                    junit testResults: 'target/surefire-reports/*.xml', allowEmptyResults: true
                }
            }
        }

        stage('Code Coverage') {
            steps {
                echo '=============== Generating code coverage ==============='
                sh 'mvn jacoco:report || true'
            }
            post {
                always {
                    publishHTML([
                        reportDir: 'target/site/jacoco',
                        reportFiles: 'index.html',
                        reportName: 'Code Coverage Report',
                        allowMissing: true
                    ])
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo '=============== Running SonarQube analysis ==============='
                // Use a Jenkins Credential (secret text) to inject the Sonar token instead of passing it on the command line
                withCredentials([string(credentialsId: env.SONAR_CREDENTIALS_ID, variable: 'SONAR_TOKEN')]) {
                    // Run the same mvn command you used locally; token and host come from env/credentials
                    sh '''
                        mvn clean verify sonar:sonar \
                          -Dsonar.projectKey=restweb-service \
                          -Dsonar.host.url=${SONAR_HOST_URL} \
                          -Dsonar.login=${SONAR_TOKEN}
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo '=============== Building Docker image ==============='
                sh '''
                    docker build -t restweb-service:${BUILD_NUMBER} .
                    docker tag restweb-service:${BUILD_NUMBER} restweb-service:latest
                '''
            }
        }

        stage('Deploy to Staging') {
            steps {
                echo '=============== Deploying to staging ==============='
                sh '''
                    docker rm -f restweb-service-staging || true
                    docker run -d \
                        --name restweb-service-staging \
                        -p 8080:8080 \
                        restweb-service:${BUILD_NUMBER}
                '''
            }
        }

        stage('Integration Tests') {
            steps {
                echo '=============== Running integration tests ==============='
                sh 'sleep 10'
                sh 'curl -f http://localhost:8080/api/health || exit 1'
            }
        }
    }

    post {
        always {
            echo '=============== Pipeline execution completed ==============='
            deleteDir()
        }
        success {
            echo '=============== Pipeline succeeded ==============='
        }
        failure {
            echo '=============== Pipeline failed ==============='
        }
        unstable {
            echo '=============== Pipeline unstable ==============='
        }
    }
}
