pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
        timeout(time: 1, unit: 'HOURS')
    }

    environment {
        JAVA_HOME = '/usr/libexec/java_home -v 17'
        MAVEN_HOME = '/usr/local/opt/maven'
        SONAR_HOST_URL = 'http://localhost:9000'
        SONAR_LOGIN = credentials('sqp_437ba26995fcb13f1bbd4ad968d837e8d7e65846')
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
        }

        stage('SonarQube Analysis') {
            steps {
                echo '=============== Running SonarQube analysis ==============='
                sh '''
                    mvn sonar:sonar \
                        -Dsonar.projectKey=restweb-service \
                        -Dsonar.sources=src/main/java \
                        -Dsonar.tests=src/test/java \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.login=$SONAR_LOGIN
                '''
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
            echo '=============== Collecting test results ==============='
            junit 'target/surefire-reports/*.xml'

            echo '=============== Publishing code coverage ==============='
            publishHTML([
                reportDir: 'target/site/jacoco',
                reportFiles: 'index.html',
                reportName: 'Code Coverage Report'
            ])
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

