# sso_authorization_strategy.md

## Scope

This document defines a coherent strategy for **SSO (Authelia)** and **authorization**
in the *FamilyVault / Home-Lab*, balancing:

- compatibility with clients (web, mobile, TV)
- operational simplicity
- security (MFA, centralized policies, reduced attack surface)
- resilience (break-glass access and service continuity)

Guiding principle:
**If a service supports native OIDC, authentication should remain application-managed.**
Forward-auth at the proxy is reserved for services without strong native auth.

---

## Service Classification

### Class A — Native OIDC (NO forward-auth)
Examples:
- Immich

Rules:
- Reverse proxy pass-through only
- Authelia used purely as OIDC Identity Provider
- No proxy-level authentication

Rationale:
- Best client compatibility
- Avoids double sessions and redirect loops

---

### Class A2 — OIDC via Plugin (NO forward-auth, cautious)
Examples:
- Jellyfin with SSO-Auth plugin

Rules:
- Same as Class A
- Keep a local break-glass admin account
- Update carefully (plugin dependency)

---

### Class B — Tools / Admin / No OIDC (YES forward-auth)
Examples:
- Grafana, Portainer, internal dashboards

Rules:
- Authelia forward-auth at proxy level
- Centralized MFA and access policies

---

### Class C — LAN/VPN Only
Examples:
- CasaOS admin
- Proxmox
- NAS administration

Rules:
- No public exposure
- Access via LAN or VPN only

---

## Reverse Proxy Baseline

Recommended headers:

```
proxy_set_header Host $host;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-Port $server_port;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Real-IP $remote_addr;
```

Notes:
- Enable websockets where required
- Do not set Base URL for subdomain deployments

---

## Authorization Strategy

Group naming convention:
- <service>_users
- <service>_admin

Examples:
- movies_users, movies_admin
- photos_users, photos_admin

Groups are provided by Authelia using the `groups` claim.

---

## Break-glass Access

Maintain at least one emergency access path:
- Local admin account (strong password)
- Restricted to LAN or VPN
- Documented recovery procedure

---

## Hardening Guidelines

- HTTPS everywhere
- Minimal rate limiting (avoid breaking streaming)
- IP allowlists for admin endpoints
- Audit and alerting via Authelia

---

## Onboarding Checklist

1. Classify service (A / A2 / B / C)
2. Configure DNS and TLS
3. Apply proxy baseline headers
4. Configure Authelia (OIDC or forward-auth)
5. Define and assign groups
6. Test web and client access
7. Document ownership and recovery steps
