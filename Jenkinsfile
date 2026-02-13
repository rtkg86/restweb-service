pipeline {
    agent any

    options {
        skipDefaultCheckout()
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn -B clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn -B test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('SonarQube Analysis') {
            when {
                anyOf {
                    branch 'main'
                    changeRequest()
                }
            }
            steps {
                withSonarQubeEnv('SonarQube') {
                    script {
                        if (env.CHANGE_ID) {
                            // Pull Request analysis
                            sh """
                              mvn -B sonar:sonar \\
                                -Dsonar.pullrequest.key=${env.CHANGE_ID} \\
                                -Dsonar.pullrequest.branch=${env.CHANGE_BRANCH} \\
                                -Dsonar.pullrequest.base=${env.CHANGE_TARGET}
                            """
                        } else {
                            // Regular branch analysis (e.g. main)
                            sh 'mvn -B sonar:sonar'
                        }
                    }
                }
            }
        }

        stage('Quality Gate') {
            when {
                anyOf {
                    branch 'main'
                    changeRequest()
                }
            }
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            when {
                allOf {
                    branch 'main'
                    not { changeRequest() }
                }
            }
            steps {
                sh "docker build -t restweb-service:${env.BUILD_NUMBER} ."
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'target/**/*.jar', fingerprint: true, allowEmptyArchive: true
        }
    }
}

