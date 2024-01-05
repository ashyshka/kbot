pipeline {
    agent any
    parameters {
        choice(name: 'OS', choices: ['linux', 'darwin', 'windows'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Pick ARCH')
        choice(name: 'CR', choices: ['hub.docker.com/repository/docker/ashyshka', 'europe-central2-docker.pkg.dev/gl-devops-and-kubernetes/k3s-k3d', 'ghcr.io/ashyshka'], description: 'Pick Container Registry Repository (any way will use ghcr.io/ashyshka)')
    }

    environment {
        GH_USER='ashyshka'
        GH_TOKEN=credentials('github_token')
        GH_REPO = 'https://github.com/ashyshka/kbot.git'
        BRANCH = 'main'
        CR = 'ghcr.io/ashyshka'
    }

    stages {

        stage('switch to branch: main') {
            steps {
                echo 'Clone Repository'
                git branch: "${BRANCH}", url: "${GH_REPO}"
            }
        }

        stage('test') {
            steps {
                echo 'Do test golang code'
                sh "make test"
            }
        }

        stage('build') {
            steps {
                echo "Do build for ${params.OS} / ${params.ARCH}"
                sh "TARGETOS=${params.OS} TARGETARCH=${params.ARCH} REPOSITORY=${GH_CR} make ${params.OS}"
            }
        }

        stage('Do login to GHCR') {
            steps {
                sh "echo $GH_TOKEN | docker login $CR -u $GH_USER --password-stdin"
            }
        }

        stage('Do push') {
            steps {
                sh "TARGETOS=${params.OS} TARGETARCH=${params.ARCH} REPOSITORY=${CR} make push"
            }
        } 
    }
    post {
        always {
            sh 'docker logout'
        }
    }
}
