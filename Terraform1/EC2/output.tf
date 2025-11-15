# output.tf

output "instance_public_ip" {
  description = "Dirección IP pública de la instancia EC2"
  value       = aws_instance.web_server.public_ip
}

output "security_group_id" {
  description = "El ID del Security Group creado"
  value       = aws_security_group.web_sg.id
}