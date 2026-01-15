#!/usr/bin/env bash
set -euo pipefail

DEPLOY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$DEPLOY_DIR/paths.env"
DOMAINS="${VAULT_DOMAINS:-}"

if [[ -z "$DOMAINS" ]]; then
  echo "WARN: VAULT_DOMAINS is empty. Set it in deploy/paths.env"
  exit 0
fi

echo "== Healthcheck =="
fail=0
for d in $DOMAINS; do
  code="$(curl -k -s -o /dev/null -w "%{http_code}" "https://$d/" || true)"
  if [[ "$code" == "200" || "$code" == "302" || "$code" == "401" || "$code" == "403" ]]; then
    echo "✅ $d  -> HTTP $code"
  else
    echo "❌ $d  -> HTTP $code"
    fail=1
  fi
done

exit "$fail"
