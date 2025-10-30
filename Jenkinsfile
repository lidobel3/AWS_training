pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
          export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
          terraform init
        '''
      }
    }

    stage('Terraform Plan') {
      steps {
        //withAWS(credentials: 'aws-credentials', region: 'eu-west-3') {
          sh 'terraform plan -out=tfplan'
        //}
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

