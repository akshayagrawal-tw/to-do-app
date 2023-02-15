pipeline {
    agent any
    parameters {
        booleanParam(defaultValue: true, description: '', name: 'Build')
    }

    stages {

        stage ('Build') {
            when { expression { return params.Build }}
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'pass', usernameVariable: 'user')]) {
                    sh "docker build -t ${user}/to-do-app-alphas:${currentBuild.number} ."
                    sh "docker tag ${user}/to-do-app-alphas:${currentBuild.number} ${user}/to-do-app-alphas:latest"
                }
            }
        }


        stage ('Push to registry') {
            when { expression { return params.Build }}
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'pass', usernameVariable: 'user')]) {
                    sh "docker login -u ${user} -p ${pass}"
                    sh "docker push ${user}/to-do-app-alphas:${currentBuild.number}"
                    sh "docker push ${user}/to-do-app-alphas:latest"
                }
            }


        }
        stage ('Deploy') {
            steps {
                sh "docker stop to-do-app-alphas || true && docker rm to-do-app-alphas || true"
                withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'pass', usernameVariable: 'user')]) {
                    sh "docker run -d -p 80:80  --name to-do-app-alphas ${user}/to-do-app-alphas:latest"
                }
            }
        }
    }
    post {
            always {
                cleanWs()
            }
        }

    }
