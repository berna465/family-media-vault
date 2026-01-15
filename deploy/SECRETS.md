# Secrets (NON committare)

Metti i segreti sul server, fuori dal repo:
- /srv/family-vault/runtime/<svc>/secrets/
  oppure
- /srv/family-vault/secrets/ (globale)

Consiglio backup (cifrato) su:
- QNAP (share privata)
- WD Archivio Freddo

Authelia: preserva sempre
- JWT secret
- session secret
- storage encryption key
- OIDC private key (se usata)
