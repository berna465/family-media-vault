
# Logging – Centralized Syslog Collector + Promtail (v1)

Obiettivo: centralizzare i log di host e container in un unico punto, senza installare agent invasivi sui nodi applicativi.

Approccio:
1) Un Log Collector Host riceve syslog in TCP e salva i messaggi su file per host/program.
2) Promtail (sul Log Collector Host) scrapa questi file e li invia a Loki.
3) I nodi applicativi inviano:
   - log host via rsyslog (opzionale)
   - log container Docker via logging driver syslog (consigliato)

## Componenti
- Log Collector Host: rsyslog server + promtail (+ Loki opzionale)
- Application Hosts: Docker con logging driver syslog

## Rsyslog – lato Collector
```bash
sudo apt install -y rsyslog
```

`/etc/rsyslog.d/10-remote-tcp.conf`
```
module(load="imtcp")
input(type="imtcp" port="514")
```

`/etc/rsyslog.d/20-remote-files.conf`
```
template(name="RemotePerHost" type="string"
  string="/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log")

*.* ?RemotePerHost
& stop
```

```bash
sudo mkdir -p /var/log/remote
sudo systemctl restart rsyslog
```

## Promtail – scraping syslog files
```yaml
scrape_configs:
  - job_name: syslog-remote
    static_configs:
      - targets: [localhost]
        labels:
          job: syslog
          __path__: /var/log/remote/*/*.log
```

## Docker – logging driver syslog (Application Hosts)
```yaml
logging:
  driver: syslog
  options:
    syslog-address: "tcp://<log-collector-host>:514"
    tag: "{{.Name}}"
```

## Validazione
I file devono apparire in:
```
/var/log/remote/<hostname>/<program>.log
```

Query base:
```logql
{job="syslog"} |= "authelia"
```

## Pro / Contro
Pro:
- un solo Promtail
- niente accesso ai file Docker sui nodi applicativi
- pattern standard enterprise

Contro:
- dipendenza dal Log Collector Host
- parsing/labeling da affinare

Scelta consigliata v1:
- syslog TCP
- docker logging driver syslog per servizi core
- buffering rsyslog client (step successivo)
