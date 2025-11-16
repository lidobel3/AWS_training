pipeline {
  agent any

  environment {
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
    stage('Validate Parameters') {
    steps {
      script {
        if (params.DO_APPLY && params.DO_DESTROY) {
          error("❌ ERROR: Vous ne pouvez pas activer DO_APPLY et DO_DESTROY en même temps.")
        } else {
          echo "✅ Paramètres valides : DO_APPLY=${params.DO_APPLY}, DO_DESTROY=${params.DO_DESTROY}"
        }
      }
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
        withAWS(credentials: '2308dbbf-1fae-4511-8ab8-c8098dc0dac4', region: 'eu-west-3') { // Utilisation des identifiants AWS stockés dans Jenkins  
          sh 'terraform plan -out=tfplan'
//sh 'terraform plan -out=tfplan'
        }
      }
    }

    stage('Terraform Apply') {
      when {
        expression { return params.DO_APPLY }
      }
      steps {
        withAWS(credentials: '2308dbbf-1fae-4511-8ab8-c8098dc0dac4', region: 'eu-west-3') {
          sh 'terraform apply -input=false -auto-approve tfplan'
        }
      }
    }
    stage('Terraform Destroy') {
      when {
        expression { return params.DO_DESTROY }
      }
      steps {
        withAWS(credentials: '2308dbbf-1fae-4511-8ab8-c8098dc0dac4', region: 'eu-west-3') {
          sh 'terraform destroy -auto-approve'
        }
      }
    }    
  }

  parameters {
    booleanParam(name: 'DO_APPLY', defaultValue: false, description: 'Appliquer les changements ?')
    booleanParam(name: 'DO_DESTROY', defaultValue: false, description: 'Detruire l\'infrastructure ?')
  }  
}