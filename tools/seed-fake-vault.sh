#!/usr/bin/env bash
set -euo pipefail

VAULT_ROOT="/srv/family-vault/runtime"

echo "== Family Media Vault :: Fake Seed =="

echo "-- Authelia"
mkdir -p \
  "$VAULT_ROOT/authelia/config" \
  "$VAULT_ROOT/authelia/secrets" \
  "$VAULT_ROOT/authelia/data"

cat > "$VAULT_ROOT/authelia/config/configuration.yml" <<'EOF'
log:
  level: info
authentication_backend:
  file:
    path: /config/users_database.yml
session:
  name: authelia_session
  expiration: 1h
storage:
  local:
    path: /var/lib/authelia/db.sqlite3
notifier:
  filesystem:
    filename: /var/lib/authelia/notification.txt
EOF

cat > "$VAULT_ROOT/authelia/config/users_database.yml" <<'EOF'
users:
  test:
    displayname: "Test User"
    password: "$argon2id$v=19$m=65536,t=3,p=4$ZmFrZXNhbHQ$ZmFrZXBhc3M="
    email: test@example.com
    groups:
      - admins
EOF

echo "fake-secret" > "$VAULT_ROOT/authelia/secrets/jwt.key"
echo "authelia-db" > "$VAULT_ROOT/authelia/data/db.sqlite3"

echo "-- BookStack"
mkdir -p \
  "$VAULT_ROOT/bookstack/uploads" \
  "$VAULT_ROOT/bookstack/db"

echo "hello wiki" > "$VAULT_ROOT/bookstack/uploads/welcome.txt"
echo "bookstack-db" > "$VAULT_ROOT/bookstack/db/bookstack.sql"

echo "-- Immich"
mkdir -p \
  "$VAULT_ROOT/immich/library" \
  "$VAULT_ROOT/immich/db" \
  "$VAULT_ROOT/immich/redis" \
  "$VAULT_ROOT/immich/cache" \
  "$VAULT_ROOT/immich/thumbs"

echo "fake-photo" > "$VAULT_ROOT/immich/library/photo1.jpg"
echo "immich-db" > "$VAULT_ROOT/immich/db/pg.data"
echo "redis" > "$VAULT_ROOT/immich/redis/redis.data"

echo "-- Navidrome"
mkdir -p \
  "$VAULT_ROOT/navidrome/config" \
  "$VAULT_ROOT/navidrome/data"

echo "navidrome-config" > "$VAULT_ROOT/navidrome/config/navidrome.toml"
echo "navidrome-db" > "$VAULT_ROOT/navidrome/data/navidrome.db"

echo "-- Jellyfin"
mkdir -p \
  "$VAULT_ROOT/jellyfin/config" \
  "$VAULT_ROOT/jellyfin/cache" \
  "$VAULT_ROOT/jellyfin/transcodes"

echo "jellyfin-config" > "$VAULT_ROOT/jellyfin/config/system.xml"

echo "-- Uptime Kuma"
mkdir -p "$VAULT_ROOT/uptime-kuma/data"
echo "kuma-state" > "$VAULT_ROOT/uptime-kuma/data/kuma.db"

echo "-- Landing"
mkdir -p "$VAULT_ROOT/landing/html"
echo "<h1>Fake Landing</h1>" > "$VAULT_ROOT/landing/html/index.html"

echo
echo "✅ Fake data seeded in $VAULT_ROOT"
echo "Ora puoi eseguire backup-gold.sh / restore-gold.sh in sicurezza."
