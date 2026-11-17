# Informe Práctica 1 (RA3) — Administración de WordPress: WP-CLI, Usuarios y Módulos

**Alumno:** Sergio Sala Gómez  
**Módulo:** Implantación de Aplicaciones Web (IAW) — 2º ASIX  
**Repositorio:** `https://github.com/XxSergio06xX/proyecto-wordpress-stack` (Rama: `ra3-admin`)  

---

## 1. Gestión mediante WP-CLI y Administración de Usuarios
Se ha utilizado el wrapper `./wp` conectado al contenedor Docker de WordPress para administrar la instancia desde línea de comandos sin depender exclusivamente de la interfaz gráfica:
* **Gestión de usuarios y perfiles:** Creación y asignación de roles diferenciados (como el perfil de pruebas `alumna.fct`), aplicando el principio de mínimo privilegio para separar las tareas de administración del sistema de las de edición de contenido.
* **Automatización de contenidos:** Creación de páginas base mediante comandos (`./wp post create --post_type=page...`).

---

## 2. Integración de Módulos Funcionales (Requisitos R1, R2 y R3)

### R1 — Formulario de contacto con almacenamiento en base de datos
* **Plugins utilizados:** `contact-form-7` y `flamingo` (instalados y activados vía WP-CLI).
* **Configuración:** 
  * Se ha editado el formulario añadiendo un campo desplegable personalizado (`[select ciclo "ASIR" "DAW" "SMR"]`).
  * En la pestaña de **Ajustes adicionales** se ha añadido la directiva `skip_mail: on` para evitar errores de envío SMTP al carecer el contenedor de servidor de correo saliente, delegando el almacenamiento de los envíos directamente en la base de datos mediante **Flamingo**.
* **Verificación:** Publicación del bloque en la página **Contacto** y comprobación del registro en **Flamingo → Mensajes entrantes**.

### R2 — Cumplimiento RGPD y Aviso de Cookies
* **Plugin utilizado:** `complianz-gdpr` (Complianz | GDPR/CCPA Cookie Consent), instalado desde el repositorio oficial de plugins del panel web.
* **Configuración:** 
  * Creación de la página **Política de cookies** y enlace dentro del asistente de configuración para la región **Unión Europea (RGPD)** en idioma español.
  * Configuración del banner de consentimiento con los botones **Aceptar** y **Rechazar** con el mismo peso visual.
* **Verificación:** Prueba de navegación en ventana privada limpiando caché y cookies, comprobando que el banner salta al acceder por primera vez y desaparece tras registrar el consentimiento.

### R3 — Auditoría y Registro de Actividad
* **Plugin utilizado:** `simple-history` (`./wp plugin install simple-history --activate`).
* **Verificación:** Se ha realizado una prueba de acceso fallido con el usuario `alumna.fct` seguida de un inicio de sesión válido, verificando en **Escritorio → Historial** que el sistema registra tanto los intentos fallidos de autenticación como los cambios realizados en plugins y contenidos.

---

## 3. Limpieza de Plugins Inactivos y Control de Versiones
* **Endurecimiento (*Hardening*):** Se han desactivado y eliminado completamente los plugins preinstalados sin uso (`akismet` y `hello`) mediante `./wp plugin delete akismet hello` para reducir la superficie de exposición ante posibles vulnerabilidades.
* **Control de versiones en Git:** Se ha configurado `.gitignore` para excluir datos sensibles (`.env`) y volúmenes persistentes (`wp-content/`, `mysql/`, `db_data/`), subiendo únicamente la infraestructura como código (`docker-compose.yml`), el script `./wp` y la documentación a la rama `ra3-admin`.
