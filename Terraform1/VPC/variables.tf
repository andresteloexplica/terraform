# Variable para la región de AWS
variable "aws_region" {
  description = "La región de AWS (ej. eu-west-3)."
  type        = string
}

# Variable para la Zona de Disponibilidad (AZ)
variable "az_name" {
  description = "La Zona de Disponibilidad (AZ) a usar (ej. eu-west-3a)."
  type        = string
}

# Variable para el bloque CIDR de la VPC
variable "vpc_cidr" {
  description = "El bloque CIDR de red para la VPC (e.g., 10.0.0.0/16)."
  type        = string
}

# Variable para el bloque CIDR de la Subred Pública
variable "public_subnet_cidr" {
  description = "El bloque CIDR de red para la subred pública."
  type        = string
}

# Variable para el bloque CIDR de la Subred Privada
variable "private_subnet_cidr" {
  description = "El bloque CIDR de red para la subred privada."
  type        = string
}