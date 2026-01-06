# 2. Role IAM pour EC2
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-s3-access-role"
  description = "Role permettant à EC2 d'accéder à S3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 3. Politique IAM pour accéder à S3
resource "aws_iam_role_policy" "s3_access" {
  name = "s3-access-policy"
  role = aws_iam_role.ec2_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          aws_s3_bucket.mon_bucket.arn,
          "${aws_s3_bucket.mon_bucket.arn}/*"
        ]
      }
    ]
  })
}

# 4. Instance Profile (pour lier le rôle à l'EC2)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-profile"
  role = aws_iam_role.ec2_s3_role.name
}
