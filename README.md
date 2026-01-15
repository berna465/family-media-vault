# Family Media Vault – v1 (offline-first)

Sistema self-hosted “memoria digitale di famiglia” **riproducibile** e **ripristinabile** in pochi minuti.

## Principi v1
- **Offline-first (LAN)**: deve funzionare anche senza Internet.
- **Single host**: tutti i servizi sullo stesso host.
- **Standard paths**: tutto sotto `/srv/family-vault` (indipendente dai mount point).
- **Source of truth**: configurazioni in Git; segreti fuori da Git.
- **Reconcile**: ripristino con script idempotenti (`deploy/` + `backup/`).

## Standard path
- Vault root: `/srv/family-vault`
- Runtime: `/srv/family-vault/runtime/<service>/...`

## Quick start (VM / test)
1) Copia `deploy/.env.example` → `deploy/.env`
2) Verifica `deploy/paths.env` (default ok)
3) Deploy:
```bash
cd deploy
./deploy.sh
```

## Backup GOLD
```bash
cd backup
./backup-gold.sh
```

## Restore GOLD + redeploy
```bash
cd backup
./restore-gold.sh <timestamp>
cd ../deploy
./deploy.sh
```

Vedi `docs/containers-layout.md` per mapping volumi e “GOLD vs REBUILD”.
