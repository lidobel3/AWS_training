variable "key_name" {
  description = "Nom du fichier de la clé SSH (sans extension)"
  type        = string
  default     = "id_rsa"
}

variable "algorithm" {
  description = "Algorithme utilisé pour la clé"
  type        = string
  default     = "RSA"
}

variable "rsa_bits" {
  description = "Taille de la clé RSA"
  type        = number
  default     = 4096
}

