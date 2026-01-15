
# Family Media Vault – VM INFRA Runbook (Pi-hole DNS+DHCP + Nginx Proxy Manager)

Questa VM ospita l’infrastruttura di rete locale:
- Pi-hole come DNS + DHCP
- Nginx Proxy Manager (NPM) come reverse proxy

## 1. Specifiche VM
| Parametro | Valore |
| Hostname | infra |
| IP | 192.168.178.10 |
| OS | Debian 12 minimal |
| CPU | 1–2 vCPU |
| RAM | 2–4 GB |
| Disco | 20–30 GB |

## 2. Setup base
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg docker.io docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker
```

## 3. Layout filesystem
```bash
sudo mkdir -p /srv/infra/{pihole,etc-dnsmasq.d,npm/{data,letsencrypt}}
sudo chown -R $USER:$USER /srv/infra
```

## 4. docker-compose.yml
```yaml
services:
  pihole:
    image: pihole/pihole:latest
    container_name: pihole
    hostname: pihole
    network_mode: "host"
    environment:
      TZ: Europe/Rome
      WEBPASSWORD: changeme
      DNSMASQ_LISTENING: all
    volumes:
      - /srv/infra/pihole:/etc/pihole
      - /srv/infra/etc-dnsmasq.d:/etc/dnsmasq.d
    cap_add:
      - NET_ADMIN
    restart: unless-stopped

  npm:
    image: jc21/nginx-proxy-manager:latest
    container_name: npm
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "81:81"
    volumes:
      - /srv/infra/npm/data:/data
      - /srv/infra/npm/letsencrypt:/etc/letsencrypt
```
