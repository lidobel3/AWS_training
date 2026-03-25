# 🚀 Terraform & CI/CD avec HCP Terraform

## 📚 Table des matières
- [� Terraform \& CI/CD avec HCP Terraform](#-terraform--cicd-avec-hcp-terraform)
  - [📚 Table des matières](#-table-des-matières)
  - [📌 Introduction](#-introduction)
  - [☁️ Backend HCP Terraform](#️-backend-hcp-terraform)
    - [✅ Avantages](#-avantages)
  - [⚙️ Fonctionnement](#️-fonctionnement)
  - [💰 Estimation des coûts](#-estimation-des-coûts)
    - [🎯 Objectifs](#-objectifs)
  - [🔐 Sécurité](#-sécurité)
    - [🔑 Gestion des secrets](#-gestion-des-secrets)
    - [🛡️ Bonnes pratiques](#️-bonnes-pratiques)
  - [🔑 Accès à Terraform Cloud](#-accès-à-terraform-cloud)
    - [🌐 URL](#-url)
    - [🔐 Authentification](#-authentification)
  - [🧩 Prérequis Jenkins](#-prérequis-jenkins)
    - [🔧 Plugins obligatoires](#-plugins-obligatoires)
    - [☁️ AWS](#️-aws)
    - [🎨 UI / Logs](#-ui--logs)
  - [🔧 Configuration des credentials](#-configuration-des-credentials)
    - [🟢 Terraform Cloud](#-terraform-cloud)
    - [🟡 AWS](#-aws)
  - [📦 Pipeline Jenkins](#-pipeline-jenkins)
    - [⚙️ Fonctionnement](#️-fonctionnement-1)
    - [📌 Important](#-important)
  - [📌 Bonnes pratiques](#-bonnes-pratiques)
    - [✅ À faire](#-à-faire)
    - [❌ À éviter](#-à-éviter)
  - [🧠 Remarques importantes](#-remarques-importantes)
  - [🏷️ Informations complémentaires](#️-informations-complémentaires)
  - [🚀 Conclusion](#-conclusion)

---

## 📌 Introduction

Ce projet utilise **Terraform** avec un backend distant basé sur  
👉 **HCP Terraform (Terraform Cloud)** de **HashiCorp**

Objectif :
- Industrialiser les déploiements
- Sécuriser le state
- Automatiser via CI/CD (Jenkins)

---

## ☁️ Backend HCP Terraform

La branche `master` est configurée pour utiliser un backend distant.

### ✅ Avantages

- 📦 Centralisation du **state Terraform**
- 🔒 **State locking automatique**
- ⚙️ Exécution distante des plans
- 👥 Collaboration facilitée (multi-utilisateurs / CI)

---

## ⚙️ Fonctionnement

1. Le code Terraform est versionné dans ce dépôt
2. Chaque commit déclenche un **Terraform Plan**
3. Les changements sont :
   - validés manuellement ou automatiquement
   - appliqués via pipeline
4. Le **state est stocké à distance** (aucun state local)

---

## 💰 Estimation des coûts

À chaque exécution du pipeline :

👉 Une estimation des coûts est générée automatiquement via HCP Terraform

### 🎯 Objectifs

- Anticiper les dépenses
- Détecter les dérives budgétaires
- Ajouter un contrôle avant déploiement

---

## 🔐 Sécurité

### 🔑 Gestion des secrets

Aucune donnée sensible dans le dépôt.

Les secrets sont stockés via :
- Variables sécurisées HCP Terraform
- Variables d’environnement Jenkins

### 🛡️ Bonnes pratiques

- ❌ Pas de credentials en dur
- ❌ Pas de state local
- ✅ Rotation régulière des tokens
- ✅ Accès restreint par rôle

---

## 🔑 Accès à Terraform Cloud

### 🌐 URL
https://app.terraform.io/app/organizations

### 🔐 Authentification

- Login : `lidobel3`
- Connexion via GitHub
- Credentials stockés dans Keepass (`mykp`)

---

## 🧩 Prérequis Jenkins

Pour que le pipeline fonctionne, installer les plugins suivants :

### 🔧 Plugins obligatoires

- Pipeline
- Pipeline: Declarative
- Git Plugin
- Credentials Plugin
- Credentials Binding Plugin

### ☁️ AWS

- AWS Credentials Plugin
- Pipeline: AWS Steps (**obligatoire pour `withAWS`**)

### 🎨 UI / Logs

- AnsiColor Plugin (couleurs console)
- Timestamper (horodatage logs)

---

## 🔧 Configuration des credentials

### 🟢 Terraform Cloud

- ID : `terraform_cloud_token`
- Type : **Secret Text**
- Contenu : token HCP Terraform

---

### 🟡 AWS

- Type : **AWS Credentials**
- Variables nécessaires :
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`

📌 Ces credentials permettent à **Terraform Cloud** de communiquer avec AWS.

---

## 📦 Pipeline Jenkins

### ⚙️ Fonctionnement

Le pipeline :

1. Checkout du code
2. Validation des paramètres
3. `terraform init`
4. `terraform plan`
5. `terraform apply` ou `destroy` (selon paramètres)

### 📌 Important

- L’exécution Terraform est **déléguée à HCP Terraform**
- Jenkins sert uniquement d’orchestrateur

---

## 📌 Bonnes pratiques

### ✅ À faire

- Utiliser `withCredentials` pour les secrets
- Séparer `plan` et `apply`
- Activer les logs (`timestamps`, `ansiColor`)
- Tester avec un environnement de dev

### ❌ À éviter

- Utiliser `root` ou comptes admin directs
- Stocker des tokens dans le code
- Déployer sans validation de plan

---

## 🧠 Remarques importantes

- ❌ Aucun backend S3 / DynamoDB utilisé
- ✅ Backend entièrement géré par HCP Terraform
- 🔒 Locking natif
- ☁️ Infrastructure pilotée à distance

---

## 🏷️ Informations complémentaires

- Token utilisé : `node_jenkins_node`
- Jenkins : http://192.168.1.17:8081
- Node Jenkins : `node_jenkins`

---

## 🚀 Conclusion

Cette architecture permet :

- Une infra **sécurisée**
- Une gestion **centralisée**
- Une automatisation **complète via CI/CD**
- Une meilleure **maîtrise des coûts**

---

💡 _Tip : Toujours tester un `terraform plan` avant un `apply` en production._
