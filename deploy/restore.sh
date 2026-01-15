#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STACKS_DIR="$ROOT_DIR/stacks"
DEPLOY_DIR="$ROOT_DIR/deploy"

echo "== Family Media Vault v1 :: restore (no data loss) =="

echo "-- Stopping stacks (keeping volumes)"
for s in "$STACKS_DIR"/*; do
  [[ -d "$s" && -f "$s/docker-compose.yml" ]] || continue
  echo "   -> $(basename "$s")"
  (cd "$s" && docker compose down --remove-orphans)  # NO -v !!!
done

echo "-- Pruning dangling images"
docker image prune -f || true

echo "-- Re-deploy"
"$DEPLOY_DIR/deploy.sh"

echo "✅ Restore completed."
