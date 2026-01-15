#!/usr/bin/env bash
set -euo pipefail

VAULT_ROOT="/srv/family-vault"
BACKUP_ROOT="/mnt/backup/family-vault-gold"

if [[ -z "${1:-}" ]]; then
  echo "Uso: $0 <timestamp_backup>"
  echo "Esempio: $0 2026-01-15_2130"
  exit 1
fi

SRC="$BACKUP_ROOT/$1/runtime"
if [[ ! -d "$SRC" ]]; then
  echo "ERRORE: backup $SRC non trovato."
  exit 1
fi

echo "== Family Media Vault :: GOLD Restore =="
echo "From: $SRC"
echo "To:   $VAULT_ROOT/runtime"
read -p "Confermi restore? (yes) " CONFIRM
[[ "$CONFIRM" == "yes" ]] || exit 1

rsync -aHAX --delete "$SRC/" "$VAULT_ROOT/runtime/"

echo "Restore completato."
echo "Ora segui backup/restore-order.md"
