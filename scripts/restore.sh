#!/usr/bin/env bash
# ==============================================================================
# restore.sh — Restauración de copias de seguridad del stack WordPress (RA3)
# Uso:
#   ./scripts/restore.sh                  -> lista las copias disponibles
#   ./scripts/restore.sh AAAAMMDD-HHMMSS  -> restaura esa copia (pide SI)
# ==============================================================================
set -euo pipefail

cd "$(dirname "$0")/.."
ORIGEN="backups"

if [ $# -eq 0 ]; then
  echo "Copias disponibles en $ORIGEN/:"
  ls -1 "$ORIGEN"/db_*.sql.gz 2>/dev/null \
    | sed -E 's|^.*/db_([0-9]{8}-[0-9]{6})\.sql\.gz$|  \1|' \
    || echo "  (No hay copias disponibles)"
  echo ""
  echo "Uso: $0 AAAAMMDD-HHMMSS"
  exit 0
fi

FECHA="$1"
F_DB="$ORIGEN/db_$FECHA.sql.gz"
F_WP="$ORIGEN/wp-content_$FECHA.tar.gz"

if [ ! -f "$F_DB" ] || [ ! -f "$F_WP" ]; then
  echo "ERROR: no se encuentran ambos ficheros para la fecha '$FECHA':" >&2
  echo "  - $F_DB" >&2
  echo "  - $F_WP" >&2
  exit 1
fi

# Verificar integridad antes de tocar nada
gzip -t "$F_DB" "$F_WP"

# Comprobar que los servicios están en marcha
for servicio in db wordpress; do
  if ! docker compose ps --status running --services | grep -qx "$servicio"; then
    echo "ERROR: el servicio '$servicio' no está en marcha. Ejecuta: docker compose up -d" >&2
    exit 1
  fi
done

echo "ATENCIÓN: Se va a sobrescribir la base de datos y wp-content con la copia $FECHA."
read -r -p "Escribe SI para continuar: " CONFIRMACION
if [ "$CONFIRMACION" != "SI" ]; then
  echo "Restauración cancelada."
  exit 1
fi

echo "-> Restaurando base de datos desde $F_DB..."
gunzip -c "$F_DB" | docker compose exec -T db sh -c '
  : "${WP_DB_USER:?falta WP_DB_USER en .env}" "${WP_DB_NAME:?falta WP_DB_NAME en .env}"
  exec mariadb -u"$WP_DB_USER" -p"$WP_DB_PASSWORD" "$WP_DB_NAME"'

echo "-> Restaurando wp-content desde $F_WP..."
docker compose exec -T wordpress sh -c 'rm -rf /var/www/html/wp-content/*'
docker compose exec -T wordpress tar -xzf - -C /var/www/html < "$F_WP"
docker compose exec -T wordpress chown -R www-data:www-data /var/www/html/wp-content

echo "OK. Restauración completada ($FECHA)."
