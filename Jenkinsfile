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
        sh 'terraform init -input=false'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan -out=tfplan'
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

