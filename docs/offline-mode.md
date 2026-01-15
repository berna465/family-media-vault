# Offline mode (LAN)

Per funzionare offline in LAN serve DNS locale (split DNS) che risolva i domini verso l’IP del reverse proxy (NPM).
Suggerimento: Pi-hole/AdGuard Home con DHCP+DNS, FritzBox come router.

Domini tipici:
- home.bernardolab.it (landing)
- auth.bernardolab.it (Authelia)
- wiki.bernardolab.it (BookStack)
- foto.bernardolab.it (Immich)
- music.bernardolab.it (Navidrome)
- movies.bernardolab.it (Jellyfin)
- status.bernardolab.it (Uptime Kuma)
