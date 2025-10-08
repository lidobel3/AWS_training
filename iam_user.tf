# provider "aws" {
#   region = "us-east-1"  # Remplace par la région que tu utilises
# }

resource "aws_iam_user" "lidobel" {
  name = "lidobel"
}

resource "aws_iam_user_login_profile" "lidobel_login" {
  user    = aws_iam_user.lidobel.name
  #password = "MotDePasseSecurise123!"  # Remplace par un mot de passe sécurisé
  password_reset_required = true  # L'utilisateur devra changer son mot de passe lors de la première connexion
}

resource "aws_iam_access_key" "lidobel_access_key" {
  user = aws_iam_user.lidobel.name
}

resource "aws_iam_policy" "lidobel_policy" {
  name        = "lidobel-policy"
  description = "Politique d'accès limité pour l'utilisateur lidobel"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:ListBucket"
        Effect   = "Allow"
        Resource = "arn:aws:s3:::mon_bucket"
      },
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Resource = "arn:aws:s3:::mon_bucket/*"
      },
      {
        Action = [ 
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:CreateCluster",
          "eks:DeleteCluster",
          "eks:UpdateClusterConfig",
          "eks:UpdateClusterVersion",
          "eks:DescribeNodegroup",
          "eks:ListNodegroups",
          "eks:CreateNodegroup",
          "eks:DeleteNodegroup",
          "eks:UpdateNodegroupConfig",
          "eks:UpdateNodegroupVersion"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "lidobel_policy_attachment" {
  user       = aws_iam_user.lidobel.name
  policy_arn = aws_iam_policy.lidobel_policy.arn
}
