#!/usr/bin/env bash
set -euo pipefail

VAULT_ROOT="/srv/family-vault"
BACKUP_ROOT="/mnt/backup/family-vault-gold"   # cambia con QNAP/WD mount
DATE="$(date +%Y-%m-%d_%H%M)"
DEST="$BACKUP_ROOT/$DATE"

echo "== Family Media Vault :: GOLD Backup =="
echo "Source: $VAULT_ROOT/runtime"
echo "Dest:   $DEST"

mkdir -p "$DEST"

rsync -aHAX --delete   --info=progress2   --exclude="**/cache/"   --exclude="**/transcodes/"   --exclude="runtime/immich/thumbs/"   --exclude="logs/"   "$VAULT_ROOT/runtime/"   "$DEST/runtime/"

echo
echo "Backup completato in: $DEST"
