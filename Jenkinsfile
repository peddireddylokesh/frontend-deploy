pipeline {
    agent {
        label 'AGENT-1'
    }

    environment {
        project = 'expense'
        component = 'frontend'
        deploy_to = "production"
        appVersion = ''
        region = 'us-east-1'
        environment = ''
        DEBUG = 'true'
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }
     parameters{
        string(name: 'version',  description: 'Enter the application version')
        choice(name: 'deploy_to', choices: ['dev', 'qa', 'prod'], description: 'Pick something')
    }
    stages {                               
        stage('Setup Environment') {
            steps {
                script {
                    appVersion = params.version
                    environment = params.deploy_to
                    
                }
            }
        }


         stage('Deploy') {
            steps {
                script {
                    withAWS(region: "${env.region}", credentials: "aws-credentials") {
                        sh """
                            aws eks update-kubeconfig --region $region --name expense-dev
                            kubectl get nodes
                            cd helm
                            sed -i 's/IMAGE_VERSION/${params.version}/g' values-${environment}.yaml
                            helm upgrade --install $component -n $project -f values-${environment}.yaml .

                        """
                    }
                }
            }
        }
       
    }           

    post {
        always {
            echo 'This will always run'
            deleteDir()  // 💡 Jenkins built-in step to clean workspace
        }
        success {
            echo 'This will run only if the pipeline is successful'
        }
        failure {
            echo 'This will run only if the pipeline fails'
        }
        unstable {
            echo 'This will run only if the pipeline is unstable'
        }
    }
}
              