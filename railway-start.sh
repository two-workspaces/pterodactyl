#!/bin/ash
# Runs after upstream's entrypoint has migrated the database. Creates the first admin once, so the
# panel is usable without a shell (upstream expects `php artisan p:user:make` by hand), then hands
# over to upstream's supervisord.
set -e
cd /app

marker=/app/var/.railway-admin-created
if [ ! -f "$marker" ] && [ -n "$ADMIN_EMAIL" ] && [ -n "$ADMIN_PASSWORD" ]; then
  echo "railway: creating admin ${ADMIN_USERNAME:-admin} <$ADMIN_EMAIL>"
  if out=$(php artisan p:user:make --admin=1 --email="$ADMIN_EMAIL" --username="${ADMIN_USERNAME:-admin}" \
      --name-first=Admin --name-last=User --password="$ADMIN_PASSWORD" --no-interaction 2>&1); then
    touch "$marker"
  elif echo "$out" | grep -qi "already been taken"; then
    echo "railway: admin already exists"
    touch "$marker"
  else
    # Leave the marker off so the next boot tries again; the panel still starts.
    echo "railway: could not create the admin:"
    echo "$out"
  fi
fi

exec supervisord -n -c /etc/supervisord.conf
