# Proyecto WordPress Stack (CMS)

Este proyecto consiste en el despliegue containerizado de un entorno web para WordPress utilizando **Docker Compose**. La arquitectura sigue una estructura desacoplada mediante un reverse proxy (**Nginx**), el procesador de scripts PHP (**WordPress / PHP-FPM 8.3**) y el motor de base de datos relacional (**MariaDB 11**).

## Requisitos Previos

* Git (versión 2.x o superior)
* Docker Engine
* Docker Compose (Plugin V2)

## Cómo arrancarlo desde cero

1. Clonar el repositorio:
   git clone https://github.com/XxSergio06xX/proyecto-wordpress-stack
   cd proyecto-wordpress-stack

2. Configurar las variables de entorno:
   cp .env.example .env

3. Desplegar la pila de contenedores:
   docker compose up -d

4. Verificar el estado:
   docker compose ps

## Estructura de carpetas

proyecto-wordpress-stack/
├── config/                  # Archivos de configuración de PHP (uploads.ini)
├── docs/                    # Documentación del proyecto y memoria de pruebas
│   └── pruebas.md           # Resultados de funcionamiento y rendimiento
├── nginx/                   # Archivos de configuración del servidor web
├── wp-content/              # Temas, plugins y subidas persistentes
├── .env.example             # Plantilla de variables de entorno
├── docker-compose.yml       # Definición de servicios Docker
└── README.md                # Guía e información principal

## Documentación adicional

* Memoria de Pruebas y Rendimiento: docs/pruebas.md
