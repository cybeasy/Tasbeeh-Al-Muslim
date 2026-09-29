# Skill: Security & Data Protection (/security)

## Purpose
Guide agents in writing secure code, preventing vulnerabilities, and adhering to universal OWASP security principles across any technology stack.

## Directives & Audit Checklist

### 1. Input Validation & Boundaries
- Validate all incoming user data against strict type definitions, schemas, or framework validators before processing.
- Never trust client-side data or assumptions. Enforce server-side checks.

### 2. Authorization & Tenant Isolation
- Check user identity and permissions explicitly before executing any sensitive action.
- In multi-tenant environments, verify that every query filters data by tenant ID to prevent cross-tenant data leaks.

### 3. Vulnerability Evasion
- **SQL / Query Injection:** Always use parameterized queries or ORM bindings. Never concatenate un-sanitized strings into raw database queries.
- **XSS (Cross-Site Scripting):** Escape output rendered in templates or UI views. Sanitize user-generated content.
- **CSRF & Rate Limiting:** Enforce CSRF tokens on state-changing requests and apply rate limits to sensitive routes.
