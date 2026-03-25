# Génère une clé privée
resource "tls_private_key" "ssh_key" {
  algorithm = var.algorithm
  rsa_bits  = var.rsa_bits
}

# Sauvegarde la clé privée localement
resource "local_file" "private_key_pem" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/${var.key_name}"
  file_permission = "0600"
}

# Sauvegarde la clé publique localement
resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "${path.module}/${var.key_name}.pub"
}

