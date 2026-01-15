#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DEPLOY_DIR="$ROOT_DIR/deploy"
STACKS_DIR="$ROOT_DIR/stacks"

source "$DEPLOY_DIR/paths.env"
if [[ -f "$DEPLOY_DIR/.env" ]]; then
  set -a; source "$DEPLOY_DIR/.env"; set +a
fi

echo "== Family Media Vault v1 :: deploy =="

echo "-- Ensure runtime dirs"
mkdir -p "$AUTHELIA_CONFIG_DIR" "$LANDING_HTML_DIR"

echo "-- Sync versioned configs to runtime"
if [[ -d "$STACKS_DIR/authelia/config" ]]; then
  rsync -a --delete "$STACKS_DIR/authelia/config/" "$AUTHELIA_CONFIG_DIR/"
fi
if [[ -d "$STACKS_DIR/landing/html" ]]; then
  rsync -a --delete "$STACKS_DIR/landing/html/" "$LANDING_HTML_DIR/"
fi

echo "-- Pull images (best-effort)"
for s in "$STACKS_DIR"/*; do
  [[ -d "$s" && -f "$s/docker-compose.yml" ]] || continue
  (cd "$s" && docker compose pull || true)
done

echo "-- Bring stacks up"
for s in "$STACKS_DIR"/*; do
  [[ -d "$s" && -f "$s/docker-compose.yml" ]] || continue
  echo "   -> $(basename "$s")"
  (cd "$s" && docker compose up -d)
done

echo "-- Healthcheck"
"$DEPLOY_DIR/healthcheck.sh"

echo "✅ Deploy completed."
