pipeline {
    agent any
    parameters {
        booleanParam(defaultValue: true, description: '', name: 'Build')
    }

    stages {

        stage ('Build and Tag Image') {
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
               withCredentials([[
                               $class: 'AmazonWebServicesCredentialsBinding',
                               credentialsId: 'aws-secret',
                               accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                               secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]){
                                   sh "aws eks update-kubeconfig --name alphas-cluster --region ap-southeast-1"
                                   sh "kubectl get nodes"
                                   sh "kubectl apply -f deployment/dockerSecrets.yml"
                                   sh "kubectl apply -f deployment/deployment.yml"
                                //    sh "kubectl apply -f deployment/service.yml"
                                   sh "kubectl apply -f deployment/loadbalancer.yml"
                                   sh "kubectl get all -o wide"

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
