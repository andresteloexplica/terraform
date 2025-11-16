# 1. RECURSO PRINCIPAL: VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags,
    { Name = "${var.project_name}-vpc" }
  )
}

# 2. INTERNET GATEWAY (IGW)
# Permite que la VPC se comunique con Internet.
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.default_tags,
    { Name = "${var.project_name}-igw" }
  )
}

# 3. SUBNET PÚBLICA (para Bastion y NAT Gateway)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true # Las instancias aquí tendrán IP pública (opcional, pero útil para Bastion)

  tags = merge(
    var.default_tags,
    { Name = "${var.project_name}-public-subnet" }
  )
}

# 4. IP ELÁSTICA (EIP)
# Una dirección IP estática requerida por el NAT Gateway.
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = merge(
    var.default_tags,
    { Name = "${var.project_name}-nat-eip" }
  )
}

# 5. NAT GATEWAY
# Permite que las subnets privadas accedan a internet de manera saliente.
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
  depends_on    = [aws_internet_gateway.igw] # Asegura que el IGW exista primero

  tags = merge(
    var.default_tags,
    { Name = "${var.project_name}-nat-gw" }
  )
}

# 6. SUBNET PRIVADA (para la aplicación)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone
  # Las instancias aquí NO tendrán IP pública
  map_public_ip_on_launch = false 

  tags = merge(
    var.default_tags,
    { Name = "${var.project_name}-private-subnet" }
  )
}

# 7. TABLA DE RUTEOS PÚBLICA
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.default_tags,
    { Name = "${var.project_name}-public-rt" }
  )
}

# RUTA: Todo el tráfico de salida (0.0.0.0/0) va al Internet Gateway (IGW).
resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# ASOCIACIÓN: Conecta la Tabla de Ruteo Pública con la Subnet Pública.
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# 8. TABLA DE RUTEOS PRIVADA
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.default_tags,
    { Name = "${var.project_name}-private-rt" }
  )
}

# RUTA: Todo el tráfico de salida (0.0.0.0/0) va al NAT Gateway.
# ESTO GARANTIZA QUE LA SALIDA SEA POR ESE ÚNICO PUNTO.
resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# ASOCIACIÓN: Conecta la Tabla de Ruteo Privada con la Subnet Privada.
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}