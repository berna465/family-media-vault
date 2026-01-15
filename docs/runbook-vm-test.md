
# Family Media Vault – Runbook VM Test (Restore-First)

Questo runbook descrive come validare l’intero sistema Family Media Vault
partendo da una VM nuova, **senza toccare la produzione** e senza importare
ancora dati reali.

## 1. Creazione VM
| Parametro | Valore |
| OS | Debian 12 minimal |
| CPU | 2 vCPU |
| RAM | 4–6 GB |
| Disco | 80 GB |
| Rete | Bridge LAN |
| IP | es. `192.168.178.60` |
| Hostname | `vault-test` |

## 2. Setup base OS
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg git rsync tree htop
```

### Install Docker
```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
newgrp docker
```

## 3. Filesystem Vault
```bash
sudo mkdir -p /srv/family-vault/runtime
sudo chown -R $USER:$USER /srv/family-vault
```

## 4. Clona repository
```bash
git clone https://github.com/berna465/family-media-vault.git
cd family-media-vault
```

## 5. Bootstrap ambiente
```bash
cd deploy
cp .env.example .env
nano paths.env
nano .env
./deploy.sh
```

## 6. Test Backup / Restore
```bash
mkdir -p /srv/family-vault/runtime/immich/library
echo testfile > /srv/family-vault/runtime/immich/library/a.jpg

cd backup
./backup-gold.sh
rm -rf /srv/family-vault/runtime/*
./restore-gold.sh <timestamp>
tree /srv/family-vault/runtime
```

## 7. Verifica protezione mount NAS
```bash
sudo mount -t tmpfs tmpfs /srv/family-vault/runtime/immich/library
echo should_not_copy > /srv/family-vault/runtime/immich/library/bad.txt
./backup-gold.sh
find /mnt/backup -name bad.txt
```

## 8. Stato finale
Se tutti i test sono OK, il Vault è pronto per la migrazione reale.
