# Pruebas de funcionamiento y rendimiento
| Prueba | Resultado | ¿Correcto? |
|---|---|---|
| Servicios en marcha |db |ngix wordpress | Correcto
| Sitio y panel | Los dos se pueden ver con el tema incluido. | Correcto
| Subida de ficheros |Las imagenes se han subido correctamente. | Correcto
| Enlaces permanentes |Todas las entradas cargan sin errores. | Correcto
| Persistencia (down/up) |El contenido no ha sido borrado. | Correcto
| Seguridad (403) |El mensaje 403 Forbidden ha salido. | Correcto

## Rendimiento
- Tiempos de respuesta en el aula (5 medidas):
1.353909s
0.087580s
0.071085s
0.070774s
0.069134s

- Memoria por contenedor (docker stats):
ngix: 5.219 MiB
wordpress: 103.7 MiB
db: 100.5 MiB

- Interpretación:
nginx (5.2 MiB): Consumo mínimo; solo redirige el tráfico web como proxy inverso.
wordpress (103.7 MiB): El mayor consumo; ejecuta PHP 8.3-FPM y la lógica de la aplicación.
db (100.5 MiB): Mantiene en memoria RAM la caché de consultas e índices de MariaDB 11.

## Publicación
- Dirección desde la que accedió mi compañero/a: http://10.20.13.25:8080/
