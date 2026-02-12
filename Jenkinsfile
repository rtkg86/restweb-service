pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 1, unit: 'HOURS')
        timestamps()
    }

    environment {
        SONAR_HOST_URL = 'http://sonarqube:9000'
    }

    stages {
        stage('Checkout') {
            steps {
                echo '=============== Checking out code ==============='
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo '=============== Building project ==============='
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Unit Tests') {
            steps {
                echo '=============== Running unit tests ==============='
                sh 'mvn test'
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
                sh 'mvn jacoco:report'
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
                withSonarQubeEnv('sonarqube-local') {
                    sh '''
                        mvn sonar:sonar \
                            -Dsonar.projectKey=restweb-service \
                            -Dsonar.sources=src/main/java \
                            -Dsonar.tests=src/test/java \
                            -Dsonar.java.binaries=target/classes
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
            cleanWs()
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

