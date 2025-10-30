pipeline {
  agent any

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Terraform Plan') {
      steps {
        withAWS(credentials: 'aws-credentials', region: 'eu-west-3') {
          sh 'terraform apply -auto-approve'
        }
      }
    }

    stage('Terraform Apply') {
      when {
        expression { return params.DO_APPLY }
      }
      steps {
        sh 'terraform apply -input=false -auto-approve tfplan'
      }
    }
  }

  parameters {
    booleanParam(name: 'DO_APPLY', defaultValue: false, description: 'Appliquer les changements ?')
  }
}

