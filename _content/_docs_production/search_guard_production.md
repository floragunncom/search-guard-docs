---
title: Production Deployment
html_title: Production Deployment
permalink: search-guard-production
layout: docs
section: security
description: Production deployment guide for Search Guard - checklist, hardening, performance, monitoring, and backup
---

<!--- Copyright 2025 floragunn GmbH --->

# Production Deployment

This section provides comprehensive guidance for deploying and operating Search Guard in production environments. Follow these best practices to ensure your deployment is secure, performant, reliable, and maintainable.

## Production Readiness Topics

### Pre-Deployment

- **[Production Checklist](production-checklist)** - Complete pre-deployment verification checklist
  - TLS configuration verification
  - Authentication and authorization setup
  - Audit logging configuration
  - Security hardening review
  - Performance baseline establishment
  - Backup and recovery procedures
  - Documentation requirements

### Security

- **[TLS for Production](tls-in-production)** - Production TLS configuration best practices
  - Certificate management
  - Strong cipher suites
  - Certificate rotation procedures
  - TLS monitoring

- **[Security Hardening](security-hardening)** - Security best practices and hardening guidelines
  - Network isolation
  - OS-level security
  - Elasticsearch hardening
  - Secrets management
  - Access control
  - Incident response planning

### Performance

- **[Performance Tuning](performance-tuning)** - Optimize Search Guard for production workloads
  - TLS performance optimization
  - Authentication caching strategies
  - DLS/FLS query optimization
  - Audit logging performance
  - JVM tuning
  - Benchmarking methodology

### Operations

- **[Monitoring and Maintenance](production-monitoring)** - Production monitoring and alerting
  - Security event monitoring
  - Performance metrics
  - Health checks
  - Alert configuration
  - Log analysis
  - Incident response runbooks

- **[Backup and Recovery](production-backup)** - Backup strategies and disaster recovery
  - Configuration backups
  - Data snapshots
  - Recovery procedures
  - DR testing
  - Backup encryption

## Production Deployment Workflow

### Phase 1: Pre-Deployment Preparation

**1. Review Production Checklist**
- Complete all items in the [Production Checklist](production-checklist)
- Verify all security configurations
- Test authentication and authorization
- Validate TLS configuration
- Confirm backup procedures

**2. Security Hardening**
- Implement [Security Hardening](security-hardening) recommendations
- Network isolation and firewalls
- Remove demo configurations
- Configure strong authentication
- Enable audit logging
- Secure secrets management

**3. Performance Optimization**
- Review [Performance Tuning](performance-tuning) guidelines
- Establish performance baselines
- Optimize DLS/FLS queries
- Configure caching
- Test with production-like load

### Phase 2: Deployment

**1. Deploy Infrastructure**
- Provision production servers
- Configure network and security groups
- Install Elasticsearch and Search Guard
- Configure TLS certificates

**2. Configure Search Guard**
- Upload production configuration (roles, users, role mappings)
- Verify authentication works
- Test authorization policies
- Enable audit logging
- Configure monitoring

**3. Load Data**
- Restore from snapshots OR
- Begin indexing production data
- Verify data access controls
- Test search functionality

### Phase 3: Post-Deployment

**1. Monitoring Setup**
- Configure [Production Monitoring](production-monitoring)
- Set up alerts for security events
- Configure performance monitoring
- Enable health checks
- Verify audit logs flowing

**2. Backup Validation**
- Test [Backup and Recovery](production-backup) procedures
- Verify configuration backups
- Test snapshot restore
- Document recovery procedures
- Schedule regular DR drills

**3. Operational Readiness**
- Train operations team
- Document runbooks
- Define escalation procedures
- Establish maintenance windows
- Plan for certificate rotation

## Production Architecture Considerations

### High Availability

**Cluster Configuration:**
- Minimum 3 master-eligible nodes
- Replica shards for all indices
- Cross-availability zone deployment
- Load balancer for client connections

**Fault Tolerance:**
- Node failure recovery
- Split-brain prevention
- Automated failover
- Rolling restart capability

### Scalability

**Horizontal Scaling:**
- Add data nodes for capacity
- Distribute load across nodes
- Use dedicated master nodes
- Separate roles (master, data, coordinating)

**Vertical Scaling:**
- Appropriate heap size (30GB max recommended)
- Sufficient CPU for encryption overhead
- Fast disks (SSD) for performance
- Network bandwidth for cluster communication

### Security Layers

**Defense in Depth:**
1. **Network Layer** - Firewalls, VPNs, security groups
2. **Transport Layer** - TLS encryption, client certificates
3. **Authentication Layer** - Multi-factor authentication, strong passwords
4. **Authorization Layer** - Role-based access control, least privilege
5. **Data Layer** - Document/field-level security, field masking
6. **Audit Layer** - Comprehensive logging, immutable audit trails

## Production Monitoring Dashboards

**Key Metrics to Track:**

| Metric | Target | Alert Threshold |
|--------|--------|-----------------|
| Cluster status | Green | Yellow or Red |
| Failed login attempts | < 5 per user/hour | > 5 in 5 minutes |
| Certificate expiration | > 30 days | < 30 days |
| JVM heap usage | < 75% | > 85% |
| Search latency (p99) | < 100ms | > 200ms |
| Audit log queue | < 50% full | > 80% full |
| Disk space | > 20% free | < 15% free |
{: .config-table}

## Common Production Challenges

### Challenge 1: Performance Degradation

**Symptoms:**
- Slow search queries
- High JVM heap usage
- Increased GC time

**Solutions:**
- Review [Performance Tuning](performance-tuning)
- Optimize DLS/FLS queries
- Increase authentication cache size
- Add nodes to cluster
- Review audit logging overhead

### Challenge 2: Security Events

**Symptoms:**
- Multiple failed logins
- Unauthorized access attempts
- TLS errors

**Solutions:**
- Review audit logs
- Check [Production Monitoring](production-monitoring) alerts
- Follow incident response procedures
- Review [Security Hardening](security-hardening) configuration
- Update firewall rules if needed

### Challenge 3: Certificate Management

**Symptoms:**
- Certificate expiration warnings
- TLS handshake failures
- Client connection errors

**Solutions:**
- Use [TLS Hot Reload](hot-reload-tls) for rotation
- Automate certificate renewal
- Monitor certificate expiration (30-day warning)
- Maintain certificate inventory
- Test certificate rotation in staging

### Challenge 4: Configuration Drift

**Symptoms:**
- Inconsistent behavior across environments
- Undocumented changes
- Configuration conflicts

**Solutions:**
- Use version control for configuration files
- Implement change management process
- Regular configuration backups
- Use [Configuration Change Tracking](configuration-integrity)
- Automated configuration validation

## Production Support Checklist

**Daily Tasks:**
- [ ] Review security alerts
- [ ] Check cluster health
- [ ] Monitor audit logs
- [ ] Verify backup completion
- [ ] Review performance metrics

**Weekly Tasks:**
- [ ] Check certificate expiration dates
- [ ] Review failed login patterns
- [ ] Analyze slow queries
- [ ] Update security patches
- [ ] Test monitoring alerts

**Monthly Tasks:**
- [ ] Review user access and permissions
- [ ] Audit role assignments
- [ ] Update documentation
- [ ] Review capacity planning
- [ ] Security assessment

**Quarterly Tasks:**
- [ ] Disaster recovery drill
- [ ] Security penetration testing
- [ ] Performance benchmarking
- [ ] Architecture review
- [ ] Training updates

## Next Steps

**Start with the Production Checklist:**
1. **[Production Checklist](production-checklist)** - Complete all pre-deployment items
2. **[Security Hardening](security-hardening)** - Implement security best practices
3. **[Performance Tuning](performance-tuning)** - Optimize for production workloads
4. **[Production Monitoring](production-monitoring)** - Set up monitoring and alerting
5. **[Backup and Recovery](production-backup)** - Establish backup procedures

**Additional Resources:**
- **[TLS for Production](tls-in-production)** - Production TLS configuration
- **[Configuration Tools](search-guard-configuration-tools)** - Manage production configuration
- **[Audit and Compliance](search-guard-audit-compliance)** - Compliance requirements
