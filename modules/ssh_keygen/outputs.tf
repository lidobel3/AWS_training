output "private_key_pem" {
  description = "Clé privée en PEM"
  value       = tls_private_key.ssh_key.private_key_pem
  sensitive   = true
}

output "public_key_openssh" {
  description = "Clé publique OpenSSH"
  value       = tls_private_key.ssh_key.public_key_openssh
}

