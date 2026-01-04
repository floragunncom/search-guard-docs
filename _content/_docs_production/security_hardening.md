---
title: Security Hardening
html_title: Security Hardening
permalink: security-hardening
layout: docs
section: security
description: Security hardening best practices for production Search Guard deployments
---

<!--- Copyright 2025 floragunn GmbH --->

# Security Hardening

This guide covers security hardening best practices for production Search Guard deployments. Implement these recommendations to minimize attack surface and protect your Elasticsearch cluster from security threats.

## Network Security

### Network Isolation

**Isolate Elasticsearch nodes:**
- Deploy Elasticsearch in a private network/VLAN
- Restrict network access to authorized clients only
- Use security groups or firewall rules to limit ports
- Never expose Elasticsearch directly to the internet

**Firewall configuration:**
```bash
# Allow only specific IPs to access Elasticsearch
iptables -A INPUT -p tcp --dport 9200 -s 10.0.0.0/8 -j ACCEPT
iptables -A INPUT -p tcp --dport 9200 -j DROP

# Allow cluster communication between nodes
iptables -A INPUT -p tcp --dport 9300 -s <node-1-ip> -j ACCEPT
iptables -A INPUT -p tcp --dport 9300 -s <node-2-ip> -j ACCEPT
```

### Reverse Proxy

Use a reverse proxy (Nginx, Apache, HAProxy) for additional security:

**Benefits:**
- Additional authentication layer
- Rate limiting
- IP whitelisting
- DDoS protection
- SSL/TLS termination

**Example Nginx configuration:**
```nginx
server {
    listen 443 ssl;
    server_name elasticsearch.example.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=es:10m rate=10r/s;
    limit_req zone=es burst=20;

    # IP whitelisting
    allow 10.0.0.0/8;
    deny all;

    location / {
        proxy_pass https://localhost:9200;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## TLS Hardening

### Strong Cipher Suites

Configure strong cipher suites and disable weak protocols:

**elasticsearch.yml:**
```yaml
searchguard.ssl.http.enabled_protocols:
  - "TLSv1.2"
  - "TLSv1.3"

searchguard.ssl.http.enabled_ciphers:
  - "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
  - "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
  - "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
  - "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"

# Disable SSLv3, TLSv1.0, TLSv1.1
searchguard.ssl.http.enabled_protocols:
  - "TLSv1.2"
  - "TLSv1.3"
```

### Certificate Management

**Best practices:**
- Use certificates from trusted Certificate Authority
- Implement certificate rotation before expiration
- Use separate certificates for different environments
- Enable certificate revocation checking (CRL/OCSP)
- Store private keys securely (encrypted, restricted permissions)

**File permissions:**
```bash
# Restrict certificate file permissions
chmod 600 /path/to/private-key.pem
chmod 644 /path/to/certificate.pem
chown elasticsearch:elasticsearch /path/to/*.pem
```

## Authentication Hardening

### Remove Demo Configuration

**Critical:** Always remove demo configuration in production:

```bash
# Remove demo admin user
curl -XDELETE "https://localhost:9200/_searchguard/api/internalusers/admin" \
  -u admin:admin --insecure

# Remove other demo users
curl -XDELETE "https://localhost:9200/_searchguard/api/internalusers/kibanaserver" \
  -u admin:admin --insecure
```

Then reconfigure with production authentication method.

### Strong Password Policies

Enforce strong passwords for internal users:

**sg_config.yml:**
```yaml
auth_domains:
  - type: basic
    authentication_backend:
      type: internal
      config:
        password_policy:
          min_length: 12
          min_uppercase: 1
          min_lowercase: 1
          min_digits: 1
          min_special: 1
          password_history: 10
          password_expiry_days: 90
```

### Multi-Factor Authentication

Implement MFA for administrative access:

**Options:**
- Use LDAP/Active Directory with MFA
- Implement JWT with MFA-enabled identity provider
- Use client certificates for administrator access

### Account Lockout

Enable account lockout after failed login attempts:

**sg_config.yml:**
```yaml
auth_domains:
  - type: basic
    authentication_backend:
      type: internal
      config:
        account_lockout:
          enabled: true
          max_attempts: 5
          lockout_duration_minutes: 30
```

## Authorization Hardening

### Principle of Least Privilege

Grant only the minimum necessary permissions:

**Bad practice:**
```yaml
sg_user:
  cluster_permissions:
    - '*'  # Too broad!
  index_permissions:
    - index_patterns:
        - '*'
      allowed_actions:
        - '*'  # Too permissive!
```

**Good practice:**
```yaml
sg_user:
  cluster_permissions:
    - SGS_CLUSTER_MONITOR  # Specific permission
  index_permissions:
    - index_patterns:
        - 'logs-*'  # Specific indices only
      allowed_actions:
        - SGS_READ  # Read-only access
```

### Separate Admin Accounts

**Never use admin accounts for regular operations:**
- Create separate service accounts with minimal privileges
- Use admin accounts only for configuration changes
- Enable audit logging for all admin actions
- Require MFA for admin access

### Restrict REST API Access

Limit access to Search Guard REST API:

**sg_config.yml:**
```yaml
searchguard:
  restapi:
    roles_enabled:
      - "SGS_ALL_ACCESS"
    endpoints_disabled:
      - "CACHE"  # Disable cache clearing via API
    allowed_ips:
      - "10.0.0.0/8"  # Restrict to internal network
```

## Elasticsearch Hardening

### Disable Dangerous Features

**elasticsearch.yml:**
```yaml
# Disable dynamic scripting in production
script.allowed_types: none

# Or allow only specific contexts
script.allowed_contexts:
  - search
  - update

# Disable HTTP if only using transport client
http.enabled: false  # Only if you don't need REST API

# Disable automatic index creation
action.auto_create_index: false
```

### Restrict Cross-Origin Requests

```yaml
http.cors.enabled: false  # Disable CORS in production

# If CORS is required, whitelist specific origins
http.cors.enabled: true
http.cors.allow-origin: "https://kibana.example.com"
http.cors.allow-credentials: true
```

### JVM Security

**Configure JVM security manager:**
```bash
# In jvm.options or elasticsearch.yml
-Djava.security.manager
-Djava.security.policy=/path/to/security.policy
```

## Operating System Hardening

### User Isolation

**Run Elasticsearch as non-root user:**
```bash
# Create dedicated user
useradd -r -s /bin/false elasticsearch

# Set ownership
chown -R elasticsearch:elasticsearch /usr/share/elasticsearch
```

### File Permissions

**Restrict configuration file access:**
```bash
# Elasticsearch config
chmod 750 /etc/elasticsearch
chmod 640 /etc/elasticsearch/elasticsearch.yml

# Search Guard config
chmod 640 /etc/elasticsearch/sg_*.yml

# Logs (should be readable for monitoring)
chmod 750 /var/log/elasticsearch
```

### System Updates

**Keep system patched:**
- Enable automatic security updates
- Subscribe to security mailing lists
- Test updates in staging before production
- Monitor CVE databases for Elasticsearch vulnerabilities

**Ubuntu/Debian example:**
```bash
# Enable automatic security updates
apt-get install unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
```

## Kibana Hardening

### Secure Cookie Configuration

**kibana.yml:**
```yaml
# Encrypt cookies
xpack.security.encryptionKey: "<32-character-random-string>"
xpack.reporting.encryptionKey: "<32-character-random-string>"
xpack.encryptedSavedObjects.encryptionKey: "<32-character-random-string>"

# Secure cookie settings
server.ssl.enabled: true
server.ssl.certificate: /path/to/cert.pem
server.ssl.key: /path/to/key.pem

# Session configuration
searchguard.session.ttl: 3600000  # 1 hour
searchguard.session.keepalive: false  # Force re-authentication
```

### Disable Unnecessary Features

```yaml
# Disable Kibana features not in use
kibana.index: ".kibana_production"
telemetry.enabled: false
newsfeed.enabled: false
```

## Secrets Management

### Avoid Plaintext Secrets

**Never store secrets in plaintext configuration files:**

**Bad practice:**
```yaml
# Don't do this!
authentication_backend:
  type: ldap
  config:
    bind_dn: "cn=admin,dc=example,dc=com"
    password: "SuperSecret123"  # Plaintext password!
```

**Good practices:**

**1. Environment variables:**
```yaml
authentication_backend:
  type: ldap
  config:
    bind_dn: "cn=admin,dc=example,dc=com"
    password: "${env.LDAP_BIND_PASSWORD}"
```

**2. Elasticsearch keystore:**
```bash
# Store secret in keystore
bin/elasticsearch-keystore add searchguard.ssl.http.keystore_password

# Reference in elasticsearch.yml
searchguard.ssl.http.keystore_filepath: cert.jks
searchguard.ssl.http.keystore_password: ${searchguard.ssl.http.keystore_password}
```

**3. External secrets management:**
- HashiCorp Vault
- AWS Secrets Manager
- Azure Key Vault
- Kubernetes Secrets

## Monitoring and Alerting

### Security Event Monitoring

**Monitor these security events:**
- Failed authentication attempts (potential brute force)
- Authorization failures (potential privilege escalation)
- Configuration changes (audit trail)
- TLS errors (potential MITM attacks)
- Unusual access patterns (potential data exfiltration)

**Example Signals alert for failed logins:**
```yaml
checks:
  - type: search
    target: sg_auditlog-*
    request:
      query:
        bool:
          must:
            - term:
                audit_category: FAILED_LOGIN
      aggs:
        user_failures:
          terms:
            field: audit_request_effective_user
            min_doc_count: 5
```

### Health Monitoring

**Regular health checks:**
```bash
# Cluster health
curl -XGET "https://localhost:9200/_cluster/health"

# Node stats
curl -XGET "https://localhost:9200/_nodes/stats"

# Search Guard health
curl -XGET "https://localhost:9200/_searchguard/health"
```

## Incident Response

### Preparation

**Create incident response plan:**
1. Detection - How to identify security incidents
2. Containment - Steps to limit damage
3. Investigation - Forensic analysis procedures
4. Recovery - How to restore normal operations
5. Lessons learned - Post-incident review

### Emergency Procedures

**In case of security breach:**

**1. Isolate affected nodes:**
```bash
# Block network access
iptables -A INPUT -p tcp --dport 9200 -j DROP
iptables -A INPUT -p tcp --dport 9300 -j DROP
```

**2. Review audit logs:**
```bash
# Search for suspicious activity
curl -XGET "https://localhost:9200/sg_auditlog-*/_search" -d '{
  "query": {
    "range": {
      "@timestamp": {
        "gte": "now-1h"
      }
    }
  }
}'
```

**3. Reset compromised credentials:**
```bash
# Disable compromised user
curl -XPUT "https://localhost:9200/_searchguard/api/internalusers/compromised_user" -d '{
  "enabled": false
}'
```

**4. Create forensic snapshots:**
```bash
# Snapshot for analysis
curl -XPUT "https://localhost:9200/_snapshot/incident_backup/incident_$(date +%Y%m%d)"
```

## Compliance Considerations

### Data Protection

**GDPR compliance:**
- Implement field-level security for personal data
- Enable audit logging for data access
- Configure data retention policies
- Implement right to erasure (data deletion)

**HIPAA compliance:**
- Encrypt data at rest and in transit
- Implement access controls for PHI
- Enable comprehensive audit logging
- Ensure data backup and recovery

### Security Certifications

**Consider obtaining:**
- SOC 2 Type II
- ISO 27001
- PCI DSS (if handling payment data)

## Security Checklist

- [ ] Network isolated and firewalled
- [ ] TLS 1.2+ with strong ciphers
- [ ] Certificates from trusted CA
- [ ] Demo configuration removed
- [ ] Strong password policies enforced
- [ ] MFA enabled for admin access
- [ ] Least privilege principle applied
- [ ] REST API access restricted
- [ ] Dangerous Elasticsearch features disabled
- [ ] Running as non-root user
- [ ] Secrets stored securely (not plaintext)
- [ ] Security event monitoring enabled
- [ ] Incident response plan documented
- [ ] Regular security audits scheduled

## Next Steps

- **[Performance Tuning](performance-tuning)** - Optimize security without sacrificing performance
- **[Production Monitoring](production-monitoring)** - Set up security monitoring and alerting
- **[Audit and Compliance](search-guard-audit-compliance)** - Configure audit logging
- **[Production Checklist](production-checklist)** - Complete pre-deployment verification
