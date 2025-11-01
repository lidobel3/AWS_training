pipeline {
  agent any

  environment {
    // AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
    // AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    TF_TOKEN_app_terraform_io = credentials('terraform_cloud_token')
  }
  options {
    ansiColor('xterm')     // ✅ active les couleurs dans toute la console, ssi le plugin ansicolor est installé
    timestamps()           // (optionnel) ajoute un horodatage dans les logs
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Debug') {
      steps {
        sh 'env | grep TF_TOKEN || echo "Token non trouvé"'
      }
    }

    stage('Terraform Init') {
      environment {
        TF_TOKEN_app_terraform_io = credentials('terraform_cloud_token')
      }
      steps {
        sh 'terraform init'
      }
    }


    stage('Terraform Plan') {
      steps {
        withAWS(credentials: '2308dbbf-1fae-4511-8ab8-c8098dc0dac4', region: 'eu-west-3') {
          sh 'terraform plan -out=tfplan'
        }
      }
    }

    stage('Terraform Apply') {
      when {
        expression { return params.DO_APPLY }
      }
      // steps {
      //   sh 'terraform apply -input=false -auto-approve tfplan'
      // }
      steps {
        withAWS(credentials: '2308dbbf-1fae-4511-8ab8-c8098dc0dac4', region: 'eu-west-3') {
          sh 'terraform apply -input=false -auto-approve tfplan'
        }
      }
    }
  }

  parameters {
    booleanParam(name: 'DO_APPLY', defaultValue: false, description: 'Appliquer les changements ?')
  }
}