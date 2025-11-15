# variables.tf

# 1. Región de AWS
variable "aws_region" {
  description = "Región de AWS donde se desplegará la infraestructura."
  type        = string
}

# 2. AMI para la instancia EC2
variable "ami_id" {
  description = "ID de la AMI (Amazon Machine Image) para la instancia EC2."
  type        = string
}

# 3. Tipo de instancia EC2
variable "instance_type" {
  description = "Tipo de instancia EC2 (e.g., t2.micro)."
  type        = string
}

# 4. Etiqueta para el nombre de los recursos
variable "resource_name" {
  description = "Nombre base para los recursos (Instancia y SG)."
  type        = string
}

# 5. Par de claves SSH
variable "key_name" {
  description = "Nombre del par de claves SSH ya cargado en AWS."
  type        = string
}

# 6. CIDR para permitir acceso SSH/HTTP (normalmente tu IP pública)
variable "allowed_cidr" {
  description = "CIDR que se permitirá para los puertos 22 y 80 (ej. 0.0.0.0/0 para cualquier IP)."
  type        = string
  default     = "0.0.0.0/0"
}