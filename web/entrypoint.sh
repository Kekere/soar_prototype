#!/bin/bash
set -e

# Wait for DB to be ready
echo "⏳ Waiting for database..."
until mysql -h"$ROUNDCUBE_DB_HOST" -u"$ROUNDCUBE_DB_USER" -p"$ROUNDCUBE_DB_PASSWORD" -e "SELECT 1;" "$ROUNDCUBE_DB_NAME" >/dev/null 2>&1; do
  sleep 2
done
echo "✅ Database is up."

# Check if schema is already initialized
TABLE_COUNT=$(mysql -h"$ROUNDCUBE_DB_HOST" -u"$ROUNDCUBE_DB_USER" -p"$ROUNDCUBE_DB_PASSWORD" -Nse "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$ROUNDCUBE_DB_NAME';")

if [ "$TABLE_COUNT" -eq 0 ]; then
  echo "📥 Initializing Roundcube DB schema..."
  mysql -h"$ROUNDCUBE_DB_HOST" -u"$ROUNDCUBE_DB_USER" -p"$ROUNDCUBE_DB_PASSWORD" "$ROUNDCUBE_DB_NAME" < /var/www/html/roundcube/SQL/mysql.initial.sql
else
  echo "📦 Roundcube schema already initialized."
fi

# Start Apache
exec apachectl -D FOREGROUND