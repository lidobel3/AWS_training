# Terraform

La branche `master` est configurée pour utiliser un backend distant basé sur HashiCorp Cloud (HCP Terraform).

Ce backend permet :
- La centralisation du **state Terraform**
- Le **verrouillage automatique** (state locking)
- Une exécution des plans à distance
- Une meilleure collaboration entre utilisateurs et pipelines CI/CD

## 💰 Estimation des coûts

À chaque exécution du pipeline (CI/CD), une estimation du coût de l’infrastructure est réalisée automatiquement via les fonctionnalités intégrées de HCP Terraform.

Cela permet :
- D’anticiper les coûts avant déploiement
- De détecter les dérives budgétaires
- D’ajouter une couche de contrôle dans le processus de déploiement

## ⚙️ Fonctionnement

- Le code Terraform est versionné dans ce dépôt
- Chaque modification déclenche un `plan` automatique
- Les changements peuvent ensuite être validés et appliqués
- Le state est stocké et géré à distance par HCP Terraform

## 🔐 Sécurité

Les credentials et variables sensibles ne sont pas stockés dans le dépôt.  
Ils sont gérés via :
- Les variables sécurisées HCP Terraform
- Ou les variables d’environnement du pipeline CI/CD

## 📌 Remarques

- Aucun state local n’est utilisé
- Le locking est géré nativement par HCP Terraform
- Aucune dépendance à un backend externe (S3, DynamoDB, etc.)