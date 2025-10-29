pipeline {
    agent any

    tools {
        terraform 'terraform-1.0.10'  // Nom configuré dans Manage Jenkins > Tools
    }

    environment {
        TF_DIR = "terraform"
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
                    terraformInit()
                }
            }
        }

        stage('Valider la configuration') {
            steps {
                dir("${TF_DIR}") {
                    terraformValidate()
                }
            }
        }

        stage('Plan Terraform') {
            steps {
                dir("${TF_DIR}") {
                    terraformPlan planFile: 'tfplan'
                }
            }
        }

        stage('Appliquer Terraform') {
            steps {
                dir("${TF_DIR}") {
                    terraformApply planFile: 'tfplan', autoApprove: true
                }
            }
        }
    }

    post {
        success {
            echo "✅ Déploiement Terraform terminé avec succès."
        }
        failure {
            echo "❌ Erreur pendant le déploiement Terraform."
        }
        always {
            echo "Pipeline terminé (succès ou échec)."
        }
    }
}
