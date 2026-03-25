provider "aws" {
  region = "eu-west-3" # Paris
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 1. Bucket S3
resource "aws_s3_bucket" "mon_bucket" {
  bucket = "mon-bucket-tf-demo-${random_id.bucket_suffix.hex}"
  force_destroy = true
}
#
# 2. Role IAM pour EC2
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-s3-access-role"

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

# 5. Groupe de sécurité avec SSH autorisé
resource "aws_security_group" "ssh_sg" {
  name        = "allow_ssh"
  description = "Allow SSH from anywhere"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # à restreindre à ton IP publique en prod
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Cette partie va générer une paire de 
# resource "aws_key_pair" "ma_cle" {
#   key_name   = "ma-cle-ssh"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
# }

module "ssh_keygen" {
  source    = "./modules/ssh_keygen"  # Chemin relatif vers ton module
  key_name  = "ma-cle-generee"        # Nom du fichier sans extension
  algorithm = "RSA"                   # Algorithme de clé (RSA, ED25519, etc.)
  rsa_bits  = 4096                    # Taille pour RSA
}

# 6. Clé SSH publique
resource "aws_key_pair" "ma_cle" {
  key_name   = "ma-cle-ssh"
  public_key = module.ssh_keygen.public_key_openssh # adapter le chemin
}

# 7. Instance EC2 avec accès à S3
resource "aws_instance" "mon_ec2" {
  ami                    = "ami-03601e822a943105f" # Amazon Linux 2023 - eu-west-3
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.ma_cle.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y aws-cli
              echo "Hello from EC2" > /tmp/hello.txt
              aws s3 cp /tmp/hello.txt s3://${aws_s3_bucket.mon_bucket.bucket}/hello.txt
              EOF

  tags = {
    Name = "EC2-S3-Demo"
  }
}

# 8. Output de l'IP publique
output "ec2_public_ip" {
  value = aws_instance.mon_ec2.public_ip
}

# 9. Output de l'IP publique
output "ec2_instance_state" {
  value = aws_instance.mon_ec2.instance_state
}