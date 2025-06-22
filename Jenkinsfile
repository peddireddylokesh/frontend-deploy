pipeline {
    agent {
        label 'AGENT-1'
    }

    environment {
        PROJECT = 'expense'
        COMPONENT = 'frontend'
        appVersion = ''
        region = 'us-east-1'
        CLUSTER_NAME = 'expense-dev'
        environment = 'production'
        ACC_ID = '897729141306'
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
                            aws eks update-kubeconfig --region ${region} --name ${CLUSTER_NAME}
                            kubectl get nodes
                            curl -s -o crds.yaml https://raw.githubusercontent.com/aws/eks-charts/master/stable/aws-load-balancer-controller/crds/crds.yaml
                            kubectl apply -f crds.yaml || true
                            kubectl get crd | grep targetgroupbindings || echo '⚠️ CRDs might not be installed'
                            kubectl create namespace ${PROJECT} --dry-run=client -o yaml | kubectl apply -f -
                            cd helm
                            cp values-${DEPLOY_ENV}.yaml values-temp.yaml
                            sed -i 's/IMAGE_VERSION/${params.version}/g' values-temp.yaml
                            helm upgrade --install ${component} -n ${project} -f values-temp.yaml .

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
              