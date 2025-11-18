💡 Introducción

Este repositorio contiene los scripts de Terraform necesarios para desplegar una infraestructura en la nube robusta y escalable. El objetivo es automatizar la creación de una arquitectura base que incluye una red privada segura, máquinas virtuales para servidores, balanceo de carga, almacenamiento persistente y un servicio de base de datos.

🏗️ Arquitectura Desplegada

La infraestructura creada por estos Terraforms sigue un patrón de alta disponibilidad y seguridad, incluyendo los siguientes componentes principales:

    VPC (Virtual Private Cloud): Una red virtual aislada.

        Subredes Privadas: Donde residirán los servidores (EC2) y la base de datos (BBDD), garantizando que no tengan acceso directo desde Internet.

        Salida a Internet: Se configura el acceso saliente para los recursos privados.

    Servidores EC2 (Elastic Compute Cloud) y ALB (Application Load Balancer): Creación de máquinas virtuales para alojar los servicios, con un balanceador de carga para distribuir el tráfico y asegurar la disponibilidad.

    S3 Buckets: Almacenamiento de objetos duradero y escalable.

    BBDD (Base de Datos): Creación de una instancia de base de datos relacional o no relacional, desplegada en subredes privadas.

🛠️ Requisitos Previos

    Terraform CLI: Versión 1.x o superior.

    Proveedor de la Nube: Las credenciales y la configuración de acceso deben estar configuradas en tu entorno.

📁 Estructura del Repositorio

Todos los componentes de la infraestructura se gestionan a través de directorios separados a nivel raíz, lo que facilita la modularidad y el mantenimiento:

.
├── VPC/          # Configuración de red, subredes, tablas de ruteo, etc.
├── EC2/          # Creación de instancias EC2 y sus grupos de seguridad.
├── ALB/          # Creación del Application Load Balancer y sus Listeners.
├── S3/           # Definición de los buckets de almacenamiento.
├── BBDD/         # Configuración del servicio de base de datos (e.g., RDS, DynamoDB).
└── main.tf       # (Opcional) Archivo principal para llamar a los módulos si se usan como tal, o archivos de configuración base.
└── variables.tf  # Variables de configuración globales o compartidas.

🚀 Uso y Despliegue

Sigue estos pasos en el directorio donde se encuentran tus archivos .tf de configuración:

1. Inicializar Terraform

Bash

terraform init

2. Planificar el Despliegue

Revisa el plan para asegurar que la infraestructura a crear es la esperada:
Bash

terraform plan

3. Aplicar los Cambios

Aplica el plan para crear los recursos:
Bash

terraform apply

4. Destruir la Infraestructura (Opcional)

Para eliminar todos los recursos:
Bash

terraform destroy
