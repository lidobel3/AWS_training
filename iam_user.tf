# provider "aws" {
#   region = "us-east-1"  # Remplace par la région que tu utilises
# }

resource "aws_iam_user" "lidobel" {
  name = "lidobel"
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
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "lidobel_policy_attachment" {
  user       = aws_iam_user.lidobel.name
  policy_arn = aws_iam_policy.lidobel_policy.arn
}
