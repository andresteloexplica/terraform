# Muestra el ID de la VPC creada
output "vpc_id" {
  description = "El ID de la VPC creada."
  value       = aws_vpc.mi_vpc.id
}

# Muestra el bloque CIDR asignado
output "vpc_cidr_block" {
  description = "El bloque CIDR de la VPC."
  value       = aws_vpc.mi_vpc.cidr_block
}