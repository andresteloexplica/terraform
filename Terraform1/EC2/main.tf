# main.tf

## --- 1. Security Group (SG) ---
resource "aws_security_group" "web_sg" {
  name        = "${var.resource_name}-sg"
  description = "Permitir SSH y HTTP"

  # Regla para HTTP (Puerto 80)
  ingress {
    description = "HTTP desde cualquier lugar"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  # Regla para SSH (Puerto 22)
  ingress {
    description = "SSH desde el CIDR permitido"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr]
  }

  # Regla de salida (permite todo el tráfico saliente)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 significa todos los protocolos
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.resource_name}-SG"
  }
}

## --- 2. Instancia EC2 ---
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  # Asocia el Security Group creado
  security_groups = [aws_security_group.web_sg.name]

  # Opcional: Instalar un servidor web básico al iniciar (User Data)
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<h1>Hola desde Terraform!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = var.resource_name
  }
}
