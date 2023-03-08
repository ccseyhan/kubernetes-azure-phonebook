pipeline {
    agent any
    tools {
        terraform 'terraform'
    }

    stages {
        stage('Az login') {
            steps {
                withCredentials([azureServicePrincipal('AZURE_SERVICE_PRINCIPAL')]) {
                sh '''
                export ARM_CLIENT_ID="${AZURE_CLIENT_ID}"
                export ARM_CLIENT_SECRET="${AZURE_CLIENT_SECRET}"
                export ARM_TENANT_ID="${AZURE_TENANT_ID}"
                export ARM_SUBSCRIPTION_ID="134eac38-c5cf-45f6-aa75-5807ff920f63"
                export ARM_USE_AZURECLICREDENTIALS = "false"
                '''
                dir('/var/lib/jenkins/workspace/Jenkins_project/aks-terraform'){
                    echo 'Creating Infrastructure for the App on AZURE Cloud'
                    sh 'terraform init'
                    sh 'terraform apply --auto-approve'
                }
                }
            }
        }
        stage('Create Infrastructure for the App') {
            steps {
                dir('/var/lib/jenkins/workspace/Jenkins_project/aks-terraform'){
                    echo 'Creating Infrastructure for the App on AZURE Cloud'
                    sh 'terraform init'
                    sh 'terraform apply --auto-approve'
                }
            }
        }
        stage('Connect to AKS') {
            steps {
                dir('/var/lib/jenkins/workspace/Jenkins_project/aks-terraform'){
                    echo 'Injecting Terraform Output into connection command'
                    script {
                        env.AKS_NAME = sh(script: 'terraform output -raw aks_name', returnStdout:true).trim()
                        env.RG_NAME = sh(script: 'terraform output -raw rg_name', returnStdout:true).trim()
                    }
                    sh 'aws eks update-kubeconfig --name=${AKS_NAME}'
                    sh 'az aks get-credentials --resource-group ${RG_NAME} --name ${AKS_NAME}'
                }
            }
        }
        stage('Deploy K8s files') {
            steps {
                dir('/var/lib/jenkins/workspace/Jenkins_project/k8s') {
                    sh 'kubectl apply -f .'
                }
            }
        }
        stage('Destroy the Infrastructure') {
            steps{
                timeout(time:5, unit:'DAYS'){
                    input message:'Do you want to terminate?'
                }
                dir('/var/lib/jenkins/workspace/Jenkins_project/aks-terraform'){
                    sh """
                    terraform destroy --auto-approve
                    """
                }
            }
        }
    }
}