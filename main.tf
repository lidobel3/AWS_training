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

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # à restreindre à ton IP publique en prod
  }
    ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # à restreindre à ton IP publique en prod
  }
    ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # à restreindre à ton IP publique en prod
  }
    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # à restreindre à ton IP publique en prod
  }
    ingress {
    from_port   = 3100
    to_port     = 3100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # à restreindre à ton IP publique en prod
  }
    ingress {
    from_port   = 9080
    to_port     = 9080
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
  
  root_block_device {
  volume_size = 30      # nouvelle taille souhaitée en Go
  volume_type = "gp3"   # type de volume performant
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y aws-cli
              echo "Hello from EC2" > /tmp/hello.txt
              aws s3 cp /tmp/hello.txt s3://${aws_s3_bucket.mon_bucket.bucket}/hello.txt
              EOF

  tags = {
    Name = "portfolio"
  }
}