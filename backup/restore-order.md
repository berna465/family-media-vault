# Family Media Vault – Restore Order

Sequenza corretta per tornare online senza corruzioni.

## 1) Stop di TUTTI i container
- Se usi gli stack del repo:
```bash
cd deploy
./restore.sh
```
Oppure `docker compose down` su ogni stack (SENZA `-v`).

## 2) Restore GOLD
```bash
cd backup
./restore-gold.sh <timestamp>
```

## 3) Avvia DB prima delle app (se gestisci stack separati)
- Immich Postgres
- BookStack MariaDB

## 4) Avvia servizi applicativi
```bash
cd ../deploy
./deploy.sh
```

## 5) Verifica
```bash
./healthcheck.sh
```

Se qualcosa non sale:
```bash
docker ps
docker logs <container>
```
