pipeline {
    agent any

    environment {
        // Répertoire Terraform (adapter si nécessaire)
        TF_DIR = "terraform"
        // Empêche Terraform de poser des questions interactives
        TF_IN_AUTOMATION = "true"
    }

    stages {
        stage('Cloner le dépôt') {
            steps {
                git branch: 'main', url: 'https://github.com/lidobel3/AWS_training.git'
            }
        }

        stage('Initialiser Terraform') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Appliquer Terraform') {
            steps {
                dir("${TF_DIR}") {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline terminé (succès ou échec).'
        }
        success {
            echo '✅ Déploiement réussi.'
        }
        failure {
            echo '❌ Le pipeline a échoué.'
        }
    }
}
