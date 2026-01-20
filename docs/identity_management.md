# identity_management.md

## Scope

This document defines **identity, authentication, and authorization management**
for FamilyVault / Home-Lab.

Goals:
- Single source of truth for identities
- Strong authentication with minimal friction
- Consistent authorization model across services

---

## Identity Provider

Authelia is the central Identity Provider (IdP):

Responsibilities:
- User authentication
- MFA enforcement
- Group and role management
- Session and token lifecycle

All identities originate here.

---

## Authentication Methods

### Primary
- Username + password
- MFA (TOTP / WebAuthn where supported)

### Secondary / Emergency
- Local break-glass accounts (service-specific)
- Restricted to LAN/VPN

---

## OIDC Strategy

- Prefer native OIDC support in applications
- Use Authelia as OIDC issuer
- Avoid proxy-level auth for OIDC-native apps

Standard OIDC scopes:
- openid
- profile
- email
- groups

---

## Authorization Model (RBAC)

Authorization is group-based.

Naming convention:
- <service>_users
- <service>_admin

Groups are delivered via OIDC claim:
- claim name: groups

---

## Service Classes

- Class A: Native OIDC (Immich)
- Class A2: OIDC via plugin (Jellyfin)
- Class B: Forward-auth protected tools
- Class C: LAN/VPN only

(See sso_authorization_strategy.md)

---

## Provisioning & Deprovisioning

### User Onboarding
1. Create user in IdP
2. Assign service groups
3. Verify MFA enrollment

### User Offboarding
1. Disable user in IdP
2. Revoke sessions
3. Audit service access

---

## Session & Token Management

- Short-lived access tokens
- Refresh tokens handled by applications
- Immediate revocation via IdP when needed

---

## Recovery & Resilience

- At least one break-glass admin per critical service
- Documented recovery procedure
- Regular access reviews

---

## Audit & Compliance

- Authentication logs centralized
- Group membership changes tracked
- Periodic review of:
  - Admin users
  - Publicly exposed services

---
