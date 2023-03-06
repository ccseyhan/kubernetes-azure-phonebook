pipeline {
    agent any
    tools {
        terraform 'terraform'
    }

    environment {
        AWS_REGION = "us-east-1"
        AWS_ACCOUNT_ID = sh(script:'export PATH="$PATH:/usr/local/bin" && aws sts get-caller-identity --query Account --output text', returnStdout:true).trim()
    }

    stages {
        stage('Create Infrastructure for the App') {
            steps {
                echo 'Creating Infrastructure for the App on AWS Cloud'
                sh 'ls'
                sh 'cd /eks-terraform'
                sh 'ls'
                sh 'terraform init'
                sh 'terraform apply --auto-approve'
            }
        }
        stage('Destroy the Infrastructure'){
            steps{
                timeout(time:5, unit:'DAYS'){
                    input message:'Do you want to terminate?'
                }
                sh """
                terraform destroy --auto-approve
                """
            }
        }
    }
}