# network_security.md

## Scope

This document defines the **network and perimeter security strategy** for the FamilyVault / Home-Lab.
The goal is to protect exposed services while preserving usability for apps, media streaming,
and remote access.

Principles:
- Minimize exposed surface
- Prefer encryption over obscurity
- Separate access layers (network vs identity)
- Assume breach, design for containment

---

## Network Zones

### 1. Public Zone
Services exposed on the Internet behind reverse proxy:
- Media services (Immich, Jellyfin)
- Web tools protected by SSO

Controls:
- TLS termination at reverse proxy
- Rate limiting
- WAF / basic exploit blocking
- No direct exposure of backend services

---

### 2. Trusted Zone (LAN)
Services accessible only inside the local network:
- NAS admin
- CasaOS admin
- Hypervisor management

Controls:
- No public DNS exposure
- Firewall allow LAN subnets only

---

### 3. Secure Remote Zone (VPN)
Remote access equivalent to LAN:
- WireGuard / Tailscale

Controls:
- Strong cryptography
- Device-based authentication
- Optional MFA

---

## Reverse Proxy Security

Baseline configuration:
- HTTPS enforced (TLS 1.2+)
- HSTS enabled where applicable
- WebSockets explicitly enabled only where needed

Recommended headers:
```
X-Content-Type-Options: nosniff
Referrer-Policy: no-referrer-when-downgrade
```

---

## Firewall Strategy

- Default deny inbound
- Explicit allow for:
  - 80/443 → reverse proxy
  - VPN ports
- Block lateral movement where possible

---

## Rate Limiting & Abuse Prevention

Applied selectively:
- Authentication endpoints
- Admin panels

Avoid aggressive limits on:
- Media streaming
- File upload APIs

---

## Logging & Monitoring

- Reverse proxy access logs retained
- Authentication events centralized in IdP (Authelia)
- Alerting on:
  - Repeated auth failures
  - Geo anomalies
  - VPN abuse

---

## Incident Response (Network)

1. Block affected IPs at proxy/firewall
2. Revoke compromised sessions
3. Rotate secrets if needed
4. Review logs and harden rules

---
