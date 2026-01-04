---
title: Audit and Compliance
html_title: Audit and Compliance
permalink: search-guard-audit-compliance
layout: docs
section: security
description: Comprehensive audit logging and compliance features for tracking all security-relevant events
---

<!--- Copyright 2025 floragunn GmbH --->

# Audit and Compliance

Search Guard provides comprehensive audit logging and compliance features to track all security-relevant events in your Elasticsearch cluster. This enables you to meet regulatory requirements, investigate security incidents, and maintain detailed records of data access and modifications.

## What is Audit Logging?

Audit logging records detailed information about:
- **Authentication events** - Login attempts, failures, successful authentications
- **Authorization events** - Permission checks, access grants, access denials
- **Document access** - Read, write, update, delete operations
- **Administrative actions** - Configuration changes, user management
- **Compliance events** - Data access patterns for regulatory requirements

## Topics in This Section

### Audit Logging

- **[Audit Logging Overview](audit-logging-compliance)** - Comprehensive guide to audit logging features
- **[Audit Configuration](audit-configuration)** - Configure audit event types and storage
- **[Audit Log Storage](audit-logging-storage)** - Where and how audit logs are stored

### Compliance and Monitoring

- **[Compliance Features](compliance-features)** - GDPR, HIPAA, and other regulatory compliance

## Common Use Cases

### Regulatory Compliance

Meet requirements for data protection regulations:
- **GDPR** - Track personal data access and modifications
- **HIPAA** - Monitor healthcare data access
- **PCI DSS** - Audit payment card data handling
- **SOX** - Financial data access tracking

### Security Monitoring

Track security-relevant events:
- **Failed login attempts** - Detect brute force attacks
- **Privilege escalation** - Monitor unauthorized access attempts
- **Data exfiltration** - Track unusual data access patterns
- **Configuration changes** - Audit security policy modifications

### Forensics and Investigation

Investigate security incidents:
- **Access trails** - Who accessed what data and when
- **Modification history** - Track document changes
- **Authentication history** - Trace user activity
- **Timeline reconstruction** - Build complete event timelines

## Audit Event Categories

Search Guard categorizes audit events into different layers:

| Category | Events Tracked | Use Case |
|----------|----------------|----------|
| **Authentication** | Login attempts, failures, success | Monitor authentication attacks |
| **Authorization** | Permission checks, grants, denials | Track access control decisions |
| **Transport Layer** | Node-to-node communication | Monitor cluster communication |
| **REST Layer** | HTTP requests, responses | Track API access |
| **Index Events** | Document CRUD operations | Audit data modifications |
| **Compliance** | Read/write access to sensitive fields | Regulatory requirements |
{: .config-table}

## Audit Log Destinations

Store audit logs in multiple destinations:

- **Internal Elasticsearch Index** - Store logs in separate audit indices
- **External Elasticsearch Cluster** - Send logs to dedicated audit cluster
- **External Log Storage** - Forward to log4j, syslog, or file systems
- **Webhook** - Send events to external monitoring systems

**Learn more:** [Audit Log Storage](audit-logging-storage)

## Performance Considerations

Audit logging can impact cluster performance:

- **Selective logging** - Enable only necessary audit categories
- **Async processing** - Audit events processed asynchronously
- **Dedicated storage** - Use separate cluster for audit logs
- **Filtering** - Exclude low-value events (monitoring queries, etc.)

**Best practices:**
- Start with minimal logging, expand as needed
- Use external storage for high-volume environments
- Filter out noisy events (health checks, monitoring)
- Monitor audit log storage capacity

## Compliance Features

### Field-Level Audit Logging

Track access to specific sensitive fields:
```yaml
compliance:
  enabled: true
  write_log_diffs: true
  read_watched_fields:
    - index: 'employee-data'
      fields: ['ssn', 'salary']
```

### Access Pattern Analysis

Identify unusual access patterns:
- Bulk data exports
- Off-hours access
- Geographic anomalies
- Role-inappropriate queries

### Immutable Audit Logs

Ensure audit logs cannot be tampered with:
- Store in append-only indices
- Use external storage with write-once guarantees
- Implement log signing for verification

## Next Steps

1. **[Review Audit Logging Overview](audit-logging-compliance)** - Understand audit logging architecture
2. **[Configure Audit Logging](audit-configuration)** - Enable and configure audit events
3. **[Choose Storage Destination](audit-logging-storage)** - Select where to store audit logs
4. **[Implement Compliance Features](compliance-features)** - Set up regulatory compliance monitoring
