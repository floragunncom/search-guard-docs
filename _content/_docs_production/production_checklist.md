---
title: Production Checklist
html_title: Production Checklist
permalink: production-checklist
layout: docs
section: security
description: Pre-production checklist for deploying Search Guard in production environments
---

<!--- Copyright 2025 floragunn GmbH --->

# Production Checklist

This checklist ensures your Search Guard deployment is properly configured and secured before going to production. Review each section and verify all items are addressed.

## Pre-Deployment Checklist

### TLS Configuration

- [ ] **TLS enabled** on both transport and REST layer
- [ ] **Valid certificates** from trusted CA (not self-signed for production)
- [ ] **Certificate expiration** monitored with alerts
- [ ] **TLS 1.2 or higher** enforced (TLS 1.0/1.1 disabled)
- [ ] **Strong cipher suites** configured (no weak ciphers)
- [ ] **Client certificate authentication** configured for node-to-node communication
- [ ] **Certificate revocation** configured (CRL or OCSP)
- [ ] **TLS hot reload** configured for certificate rotation

**References:**
- [Configuring TLS](configuring-tls)
- [Certificate Revocation](elasticsearch-certificate-revocation)
- [TLS Hot Reload](hot-reload-tls)

### Authentication Configuration

- [ ] **Demo installation removed** - Default admin user deleted
- [ ] **Production authentication** configured (LDAP, JWT, Kerberos, etc.)
- [ ] **Password policies** enforced (complexity, expiration, history)
- [ ] **Multi-factor authentication** enabled for administrative access
- [ ] **Service accounts** created with minimal privileges
- [ ] **Anonymous access** disabled (unless explicitly required)
- [ ] **Session timeouts** configured appropriately
- [ ] **Failed login lockout** enabled to prevent brute force attacks

**References:**
- [Authentication Methods](authentication-methods)
- [Internal Users Database](internal-users-database)
- [Password-Based Authentication](password-based-auth)

### Authorization Configuration

- [ ] **Role-based access control** implemented
- [ ] **Principle of least privilege** applied to all roles
- [ ] **Admin access** restricted to specific users/groups
- [ ] **Index-level permissions** configured per team/department
- [ ] **Document-level security** configured for sensitive data
- [ ] **Field-level security** configured to hide sensitive fields
- [ ] **Field masking** enabled for PII fields
- [ ] **Action groups** used instead of wildcard permissions
- [ ] **Role mappings** reviewed and documented

**References:**
- [Authorization Overview](authorization-overview)
- [Defining Roles](roles-permissions)
- [Fine-Grained Access Control](search-guard-fine-grained-access)

### Audit Logging

- [ ] **Audit logging enabled** for all security-relevant events
- [ ] **Audit categories** configured (authentication, authorization, compliance)
- [ ] **External audit storage** configured (separate cluster or log system)
- [ ] **Audit log retention** policy defined
- [ ] **Audit log monitoring** and alerting configured
- [ ] **Compliance fields** tracked (PII access, GDPR requirements)
- [ ] **Log tampering protection** enabled (immutable storage)

**References:**
- [Audit and Compliance](search-guard-audit-compliance)
- [Audit Configuration](audit-configuration)

### Security Hardening

- [ ] **Network security** - Firewall rules restrict Elasticsearch ports
- [ ] **Elasticsearch security** - `script.allowed_types` restricted
- [ ] **REST API access** - Only authorized IPs can access
- [ ] **Kibana security** - Encrypted cookies, HTTPS only
- [ ] **Operating system** - Security patches applied
- [ ] **Java security** - Latest supported Java version
- [ ] **File permissions** - Configuration files readable only by ES user
- [ ] **Environment variables** - Secrets not in plaintext

**References:**
- [Security Hardening](security-hardening)
- [REST API Access Control](rest-api-access-control)

### Performance and Monitoring

- [ ] **Performance baseline** established
- [ ] **DLS/FLS queries** optimized and tested
- [ ] **Authentication cache** configured appropriately
- [ ] **Resource monitoring** - CPU, memory, disk for security overhead
- [ ] **Slow query logging** enabled to detect inefficient DLS queries
- [ ] **Health checks** configured for all nodes
- [ ] **Alerting** configured for security events and failures

**References:**
- [Performance Tuning](performance-tuning)
- [Production Monitoring](production-monitoring)

### Backup and Recovery

- [ ] **Backup strategy** defined and tested
- [ ] **Configuration backups** - Regular backups of sg_*.yml files
- [ ] **Snapshot repository** configured and accessible
- [ ] **Recovery procedures** documented and tested
- [ ] **Disaster recovery plan** in place
- [ ] **Backup encryption** enabled for sensitive data
- [ ] **Off-site backups** configured

**References:**
- [Production Backup and Recovery](production-backup)
- [Elasticsearch Snapshot and Restore](https://www.elastic.co/guide/en/elasticsearch/reference/{{ site.elasticsearch.minorversion }}/snapshot-restore.html)

### High Availability

- [ ] **Multi-node cluster** - Minimum 3 master-eligible nodes
- [ ] **Replica shards** configured for all indices
- [ ] **Cross-zone deployment** for disaster recovery
- [ ] **Load balancer** configured for Elasticsearch clients
- [ ] **Split-brain prevention** - `discovery.zen.minimum_master_nodes` configured
- [ ] **Node failure testing** performed
- [ ] **Rolling restart procedures** documented

### Configuration Management

- [ ] **Configuration as code** - sg_*.yml files in version control
- [ ] **Change management** - All changes reviewed and approved
- [ ] **Environment separation** - Dev/staging/production configurations separate
- [ ] **Automated deployment** - CI/CD pipeline for configuration changes
- [ ] **Configuration validation** - Tested in staging before production
- [ ] **Rollback procedures** documented

**References:**
- [Configuration Tools](search-guard-configuration-tools)
- [sgctl](sgctl)

### Documentation

- [ ] **Architecture diagram** created and up-to-date
- [ ] **Network topology** documented
- [ ] **User roles and permissions** documented
- [ ] **Runbooks** created for common operations
- [ ] **Incident response plan** documented
- [ ] **Contact information** for security team
- [ ] **Escalation procedures** defined

### Legal and Compliance

- [ ] **Data protection** requirements identified (GDPR, HIPAA, etc.)
- [ ] **Data retention** policies configured
- [ ] **Privacy impact assessment** completed
- [ ] **Compliance logging** enabled
- [ ] **Data sovereignty** requirements met
- [ ] **Security certifications** obtained if required
- [ ] **Terms of service** and privacy policies updated

## Post-Deployment Verification

After deployment, verify:

1. **Authentication works** - Test with production credentials
2. **Authorization correct** - Verify users see only permitted data
3. **TLS functioning** - Verify all connections encrypted
4. **Audit logs flowing** - Check audit events being logged
5. **Monitoring active** - Verify alerts and dashboards working
6. **Backups running** - Confirm automated backups executing
7. **Performance acceptable** - Compare to baseline metrics

## Regular Maintenance Tasks

Schedule these recurring tasks:

| Task | Frequency | Owner |
|------|-----------|-------|
| Review audit logs | Daily | Security team |
| Check certificate expiration | Weekly | Operations |
| Review user access | Monthly | Security team |
| Update security patches | Monthly | Operations |
| Test backup restoration | Quarterly | Operations |
| Security assessment | Annually | Security team |
| Disaster recovery drill | Annually | Operations |
{: .config-table}

## Next Steps

- **[Security Hardening](security-hardening)** - Implement security best practices
- **[Performance Tuning](performance-tuning)** - Optimize for production workloads
- **[Production Monitoring](production-monitoring)** - Set up monitoring and alerting
- **[Production Backup](production-backup)** - Configure backup and recovery
