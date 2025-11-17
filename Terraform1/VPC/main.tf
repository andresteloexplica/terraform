# La configuración del proveedor y región está ahora en providers.tf

# 1. Recurso para crear la VPC
resource "aws_vpc" "mi_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-ejemplo-terraform"
  }
}

# 2. Recurso para la Internet Gateway (IGW)
resource "aws_internet_gateway" "mi_igw" {
  # Asocia la IGW a la VPC
  vpc_id = aws_vpc.mi_vpc.id

  tags = {
    Name = "igw-ejemplo"
  }
}

# 3. Subred Pública
resource "aws_subnet" "subnet_publica" {
  vpc_id                  = aws_vpc.mi_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.az_name
  # Habilita la asignación automática de IPs públicas (necesario para la subred pública)
  map_public_ip_on_launch = true 

  tags = {
    Name = "Subnet-Publica"
  }
}

# 4. Subred Privada (usando 10.0.1.0/24)
resource "aws_subnet" "subnet_privada" {
  vpc_id            = aws_vpc.mi_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.az_name

  tags = {
    Name = "Subnet-Privada"
  }
}

# 5. Tabla de Rutas Pública
resource "aws_route_table" "route_table_publica" {
  vpc_id = aws_vpc.mi_vpc.id

  # Ruta que dirige todo el tráfico de Internet (0.0.0.0/0) a la Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mi_igw.id
  }

  tags = {
    Name = "Route-Table-Publica"
  }
}

# 6. Tabla de Rutas Privada
resource "aws_route_table" "route_table_privada" {
  vpc_id = aws_vpc.mi_vpc.id

  # Por defecto, solo contendrá la ruta local a la VPC (sin acceso a Internet)

  tags = {
    Name = "Route-Table-Privada"
  }
}

# 7. Asociación de la Subred Pública con su Route Table
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.subnet_publica.id
  route_table_id = aws_route_table.route_table_publica.id
}

# 8. Asociación de la Subred Privada con su Route Table
resource "aws_route_table_association" "private_association" {
  subnet_id      = aws_subnet.subnet_privada.id
  route_table_id = aws_route_table.route_table_privada.id
}