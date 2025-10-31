pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
  }

  options {
    ansiColor('xterm')   // 🔹 Active les couleurs dans la console Jenkins
    timestamps()         // 🔹 Ajoute les timestamps pour chaque ligne de log
  }

  parameters {
    booleanParam(
      name: 'DO_APPLY',
      defaultValue: false,
      description: 'Appliquer les changements Terraform ?'
    )
  }

  stages {

    stage('Checkout') {
      steps {
        echo "\u001B[36m🔄 Étape : Checkout du code source\u001B[0m"
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        echo "\u001B[33m🚀 Initialisation de Terraform...\u001B[0m"
        sh '''
          echo -e "\\033[1;33m==> terraform init\\033[0m"
          terraform init
        '''
      }
    }

    stage('Terraform Plan') {
      steps {
        echo "\u001B[34m🧭 Génération du plan Terraform...\u001B[0m"
        sh '''
          echo -e "\\033[1;34m==> terraform plan -out=tfplan\\033[0m"
          terraform plan -out=tfplan
        '''
      }
    }

    stage('Terraform Apply') {
      when {
        expression { return params.DO_APPLY }
      }
      steps {
        echo "\u001B[32m✅ Application du plan Terraform...\u001B[0m"
        sh '''
          echo -e "\\033[1;32m==> terraform apply -auto-approve tfplan\\033[0m"
          terraform apply -input=false -auto-approve tfplan
        '''
      }
    }
  }

  post {
    success {
      echo "\u001B[32m🎉 Pipeline terminé avec succès !\u001B[0m"
    }
    failure {
      echo "\u001B[31m❌ Le pipeline a échoué.\u001B[0m"
    }
    aborted {
      echo "\u001B[33m⚠️ Pipeline interrompu.\u001B[0m"
    }
  }
}
