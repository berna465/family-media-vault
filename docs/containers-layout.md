# Containers layout v1 (/srv/family-vault)

## Root
- VAULT_ROOT=/srv/family-vault
- Runtime: /srv/family-vault/runtime/<svc>/...

## Standard directory tree (recommended)
```
/srv/family-vault/
  runtime/
    landing/html/
    uptime-kuma/data/
    authelia/{config,secrets,data}/
    bookstack/{app,uploads,db}/
    immich/{library,db,redis,thumbs,cache}/
    navidrome/{config,data}/
    jellyfin/{config,cache,transcodes}/
  backups/
  logs/
```

## GOLD vs REBUILD
**GOLD (backup):**
- authelia/secrets, authelia/config, authelia/data (if sqlite/state)
- bookstack/db + bookstack/uploads (+ app if contains config)
- immich/db + immich/library (if local source of truth)
- navidrome/data + config
- jellyfin/config
- uptime-kuma/data
- landing/html
- media libraries (if stored locally)

**REBUILD (exclude to speed backup):**
- */cache
- */transcodes
- immich/thumbs (optional; rigenerabile)
- logs
