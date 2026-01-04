---
title: Production Backup and Recovery
html_title: Production Backup and Recovery
permalink: production-backup
layout: docs
section: security
description: Backup and disaster recovery procedures for Search Guard production deployments
---

<!--- Copyright 2025 floragunn GmbH --->

# Production Backup and Recovery

A comprehensive backup and recovery strategy is essential for production Search Guard deployments. This guide covers what to back up, how to restore, and how to test your disaster recovery procedures.

## What to Back Up

### Search Guard Configuration Files

**Critical configuration files requiring regular backups:**

| File | Location | Frequency | Priority |
|------|----------|-----------|----------|
| sg_config.yml | /etc/elasticsearch/ | After each change | Critical |
| sg_roles.yml | /etc/elasticsearch/ | After each change | Critical |
| sg_roles_mapping.yml | /etc/elasticsearch/ | After each change | Critical |
| sg_internal_users.yml | /etc/elasticsearch/ | After each change | Critical |
| sg_action_groups.yml | /etc/elasticsearch/ | After each change | High |
| sg_tenants.yml | /etc/elasticsearch/ | After each change | High |
| sg_blocks.yml | /etc/elasticsearch/ | After each change | Medium |
{: .config-table}

**Additional files:**
- TLS certificates and keys
- elasticsearch.yml (Search Guard TLS config)
- jvm.options
- Kibana configuration (kibana.yml)

### Elasticsearch Data

**Back up all Elasticsearch indices:**
- Application data indices
- Search Guard internal indices (.searchguard, sg_auditlog-*, etc.)
- Kibana indices (.kibana*)
- Signals indices (.signals*)

**Use Elasticsearch snapshots for data backups.**

## Configuration Backup Strategy

### Manual Backup

**Script to backup Search Guard configuration:**

```bash
#!/bin/bash
# sg-config-backup.sh

BACKUP_DIR="/backup/searchguard/$(date +%Y%m%d_%H%M%S)"
CONFIG_DIR="/etc/elasticsearch"

mkdir -p "$BACKUP_DIR"

# Backup configuration files
cp $CONFIG_DIR/sg_*.yml "$BACKUP_DIR/"

# Backup TLS certificates
cp -r $CONFIG_DIR/certs/ "$BACKUP_DIR/certs/"

# Backup elasticsearch.yml
cp $CONFIG_DIR/elasticsearch.yml "$BACKUP_DIR/"

# Create archive
cd /backup/searchguard
tar -czf "sg_config_$(date +%Y%m%d_%H%M%S).tar.gz" "$(basename $BACKUP_DIR)"

# Keep only last 30 days of backups
find /backup/searchguard/ -name "sg_config_*.tar.gz" -mtime +30 -delete

echo "Backup completed: $BACKUP_DIR"
```

**Schedule with cron:**
```bash
# Daily at 2 AM
0 2 * * * /usr/local/bin/sg-config-backup.sh
```

### Automated Configuration Backup

**Use sgctl to export configuration:**

```bash
#!/bin/bash
# sg-export-config.sh

BACKUP_DIR="/backup/searchguard/exports/$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

# Export all Search Guard configuration
sgctl get-config -h localhost:9200 \
  --ca-cert /etc/elasticsearch/certs/ca.pem \
  --cert /etc/elasticsearch/certs/admin.pem \
  --key /etc/elasticsearch/certs/admin-key.pem \
  -o "$BACKUP_DIR"

# Create git commit (version control for config)
cd /backup/searchguard/exports
git add "$BACKUP_DIR"
git commit -m "Automated backup $(date +%Y-%m-%d)"
git push origin main

echo "Configuration exported to $BACKUP_DIR"
```

### Version Control Integration

**Best practice: Store configuration in Git:**

```bash
# Initialize git repository for configs
cd /etc/elasticsearch
git init
git add sg_*.yml elasticsearch.yml
git commit -m "Initial Search Guard configuration"

# Push to remote repository (private!)
git remote add origin git@gitlab.example.com:ops/sg-config.git
git push -u origin main
```

**Benefits:**
- Version history and change tracking
- Easy rollback to previous configurations
- Change review via pull requests
- Automated backups via git hooks

## Data Backup Strategy

### Snapshot Repository Setup

**Configure snapshot repository:**

**1. Create repository directory (on all nodes):**
```bash
mkdir -p /backup/elasticsearch
chown elasticsearch:elasticsearch /backup/elasticsearch
```

**2. Configure in elasticsearch.yml:**
```yaml
path.repo: ["/backup/elasticsearch"]
```

**3. Restart Elasticsearch**

**4. Create snapshot repository:**
```bash
curl -XPUT "https://localhost:9200/_snapshot/backup_repo" \
  -u admin:password \
  -H 'Content-Type: application/json' -d '{
  "type": "fs",
  "settings": {
    "location": "/backup/elasticsearch",
    "compress": true,
    "max_snapshot_bytes_per_sec": "100mb",
    "max_restore_bytes_per_sec": "100mb"
  }
}'
```

### Snapshot Best Practices

**Snapshot naming convention:**
```
snapshot-{environment}-{type}-{date}

Examples:
- snapshot-prod-daily-20250115
- snapshot-prod-weekly-20250112
- snapshot-prod-monthly-202501
```

**Retention policy:**
| Type | Frequency | Retention |
|------|-----------|-----------|
| Hourly | Every hour | 24 hours |
| Daily | Every day at 1 AM | 7 days |
| Weekly | Sunday at 1 AM | 4 weeks |
| Monthly | 1st of month at 1 AM | 12 months |
{: .config-table}

### Automated Snapshots

**Script for automated snapshots:**

```bash
#!/bin/bash
# elasticsearch-snapshot.sh

ES_HOST="https://localhost:9200"
ES_USER="admin"
ES_PASS="${ES_ADMIN_PASSWORD}"
REPO="backup_repo"
SNAPSHOT_NAME="snapshot-prod-daily-$(date +%Y%m%d)"

# Create snapshot
curl -XPUT "$ES_HOST/_snapshot/$REPO/$SNAPSHOT_NAME?wait_for_completion=false" \
  -u $ES_USER:$ES_PASS \
  -H 'Content-Type: application/json' -d '{
  "indices": "*",
  "ignore_unavailable": true,
  "include_global_state": true,
  "metadata": {
    "taken_by": "automated_backup",
    "taken_at": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
  }
}'

# Check snapshot status
sleep 5
curl -XGET "$ES_HOST/_snapshot/$REPO/$SNAPSHOT_NAME" \
  -u $ES_USER:$ES_PASS | jq

# Delete old snapshots (keep last 7 daily backups)
curl -XGET "$ES_HOST/_snapshot/$REPO/_all" \
  -u $ES_USER:$ES_PASS | jq -r '.snapshots[] | select(.snapshot | startswith("snapshot-prod-daily")) | .snapshot' | sort -r | tail -n +8 | while read snapshot; do
  echo "Deleting old snapshot: $snapshot"
  curl -XDELETE "$ES_HOST/_snapshot/$REPO/$snapshot" -u $ES_USER:$ES_PASS
done
```

**Schedule with cron:**
```bash
# Daily at 1 AM
0 1 * * * /usr/local/bin/elasticsearch-snapshot.sh >> /var/log/elasticsearch-snapshot.log 2>&1

# Weekly on Sunday at 2 AM
0 2 * * 0 /usr/local/bin/elasticsearch-snapshot-weekly.sh

# Monthly on 1st at 3 AM
0 3 1 * * /usr/local/bin/elasticsearch-snapshot-monthly.sh
```

### Remote Snapshot Repository

**For disaster recovery, use remote repositories:**

**AWS S3:**
```bash
# Install repository-s3 plugin
bin/elasticsearch-plugin install repository-s3

# Configure AWS credentials
bin/elasticsearch-keystore add s3.client.default.access_key
bin/elasticsearch-keystore add s3.client.default.secret_key

# Create S3 repository
curl -XPUT "https://localhost:9200/_snapshot/s3_backup" \
  -u admin:password \
  -H 'Content-Type: application/json' -d '{
  "type": "s3",
  "settings": {
    "bucket": "my-elasticsearch-backups",
    "region": "us-east-1",
    "base_path": "production/snapshots",
    "compress": true
  }
}'
```

**Azure Blob Storage:**
```bash
# Install repository-azure plugin
bin/elasticsearch-plugin install repository-azure

# Configure Azure credentials
bin/elasticsearch-keystore add azure.client.default.account
bin/elasticsearch-keystore add azure.client.default.key

# Create Azure repository
curl -XPUT "https://localhost:9200/_snapshot/azure_backup" \
  -u admin:password \
  -H 'Content-Type: application/json' -d '{
  "type": "azure",
  "settings": {
    "container": "elasticsearch-backups",
    "base_path": "production",
    "compress": true
  }
}'
```

**Google Cloud Storage:**
```bash
# Install repository-gcs plugin
bin/elasticsearch-plugin install repository-gcs

# Configure GCS credentials
# Place service account key in /etc/elasticsearch/gcs-credentials.json

# Create GCS repository
curl -XPUT "https://localhost:9200/_snapshot/gcs_backup" \
  -u admin:password \
  -H 'Content-Type: application/json' -d '{
  "type": "gcs",
  "settings": {
    "bucket": "my-elasticsearch-backups",
    "base_path": "production/snapshots",
    "compress": true
  }
}'
```

## Disaster Recovery Procedures

### Configuration Recovery

**Restore Search Guard configuration:**

**1. Stop Elasticsearch on all nodes**

**2. Restore configuration files:**
```bash
# Extract backup
cd /backup/searchguard
tar -xzf sg_config_20250115_020000.tar.gz

# Copy configuration files
cp sg_config_20250115_020000/sg_*.yml /etc/elasticsearch/

# Restore TLS certificates if needed
cp -r sg_config_20250115_020000/certs/* /etc/elasticsearch/certs/

# Set permissions
chown elasticsearch:elasticsearch /etc/elasticsearch/sg_*.yml
chmod 640 /etc/elasticsearch/sg_*.yml
```

**3. Start Elasticsearch on all nodes**

**4. Verify configuration loaded:**
```bash
curl -XGET "https://localhost:9200/_searchguard/health" -u admin:password
```

**Alternative: Use sgctl to restore:**
```bash
# Upload configuration from backup
sgctl update-config /backup/searchguard/exports/20250115/ \
  -h localhost:9200 \
  --ca-cert /etc/elasticsearch/certs/ca.pem \
  --cert /etc/elasticsearch/certs/admin.pem \
  --key /etc/elasticsearch/certs/admin-key.pem
```

### Data Recovery

**Restore from snapshot:**

**1. Close indices (optional but recommended):**
```bash
curl -XPOST "https://localhost:9200/myindex/_close" -u admin:password
```

**2. Restore snapshot:**
```bash
curl -XPOST "https://localhost:9200/_snapshot/backup_repo/snapshot-prod-daily-20250115/_restore" \
  -u admin:password \
  -H 'Content-Type: application/json' -d '{
  "indices": "*",
  "ignore_unavailable": true,
  "include_global_state": false,
  "rename_pattern": "(.+)",
  "rename_replacement": "$1_restored"
}'
```

**3. Monitor restore progress:**
```bash
curl -XGET "https://localhost:9200/_snapshot/backup_repo/snapshot-prod-daily-20250115/_status" \
  -u admin:password | jq
```

**4. Reopen indices:**
```bash
curl -XPOST "https://localhost:9200/myindex/_open" -u admin:password
```

### Partial Recovery

**Restore specific indices:**

```bash
curl -XPOST "https://localhost:9200/_snapshot/backup_repo/snapshot-prod-daily-20250115/_restore" \
  -u admin:password \
  -H 'Content-Type: application/json' -d '{
  "indices": "logs-2025.01.15,users",
  "ignore_unavailable": true,
  "include_global_state": false
}'
```

**Restore to different index:**

```bash
curl -XPOST "https://localhost:9200/_snapshot/backup_repo/snapshot-prod-daily-20250115/_restore" \
  -u admin:password \
  -H 'Content-Type: application/json' -d '{
  "indices": "users",
  "rename_pattern": "users",
  "rename_replacement": "users_backup_20250115"
}'
```

### Complete Cluster Recovery

**Rebuild cluster from scratch:**

**1. Provision new Elasticsearch nodes**

**2. Install Elasticsearch and Search Guard plugin**

**3. Restore TLS certificates:**
```bash
scp backup-server:/backup/searchguard/certs/* /etc/elasticsearch/certs/
```

**4. Configure elasticsearch.yml with Search Guard TLS settings**

**5. Start Elasticsearch cluster**

**6. Restore Search Guard configuration:**
```bash
sgctl update-config /backup/searchguard/exports/latest/ \
  -h new-cluster:9200 \
  --ca-cert /etc/elasticsearch/certs/ca.pem \
  --cert /etc/elasticsearch/certs/admin.pem \
  --key /etc/elasticsearch/certs/admin-key.pem
```

**7. Create snapshot repository (same config as original)**

**8. Restore all data from snapshot:**
```bash
curl -XPOST "https://new-cluster:9200/_snapshot/backup_repo/latest_snapshot/_restore" \
  -u admin:password \
  -H 'Content-Type: application/json' -d '{
  "indices": "*",
  "include_global_state": true
}'
```

**9. Verify cluster health and data**

## Backup Encryption

### Encrypt Backups at Rest

**Encrypt filesystem backups:**

```bash
#!/bin/bash
# sg-config-backup-encrypted.sh

BACKUP_DIR="/backup/searchguard/$(date +%Y%m%d_%H%M%S)"
CONFIG_DIR="/etc/elasticsearch"
ENCRYPTION_KEY="/etc/elasticsearch/backup-encryption-key"

mkdir -p "$BACKUP_DIR"

# Backup and encrypt configuration
tar -czf - $CONFIG_DIR/sg_*.yml $CONFIG_DIR/certs/ | \
  openssl enc -aes-256-cbc -salt -pass file:$ENCRYPTION_KEY > \
  "$BACKUP_DIR/sg_config_encrypted.tar.gz.enc"

echo "Encrypted backup completed: $BACKUP_DIR"
```

**Decrypt for restore:**
```bash
openssl enc -d -aes-256-cbc -pass file:/etc/elasticsearch/backup-encryption-key \
  -in sg_config_encrypted.tar.gz.enc | tar -xzf -
```

### Cloud Storage Encryption

**Enable server-side encryption:**

**AWS S3:**
```json
{
  "type": "s3",
  "settings": {
    "bucket": "my-elasticsearch-backups",
    "server_side_encryption": true
  }
}
```

**Azure:**
```json
{
  "type": "azure",
  "settings": {
    "container": "elasticsearch-backups",
    "encryption": true
  }
}
```

## Testing Recovery Procedures

### Regular DR Drills

**Schedule quarterly disaster recovery tests:**

**DR Test Checklist:**
- [ ] Provision test environment (separate from production)
- [ ] Restore configuration files from backup
- [ ] Restore TLS certificates
- [ ] Start Elasticsearch cluster
- [ ] Verify Search Guard health
- [ ] Restore data from snapshot
- [ ] Verify data integrity
- [ ] Test authentication and authorization
- [ ] Measure recovery time (RTO)
- [ ] Document any issues encountered
- [ ] Update recovery procedures

### Automated Restore Validation

**Script to validate snapshot integrity:**

```bash
#!/bin/bash
# validate-snapshot.sh

ES_HOST="https://localhost:9200"
ES_USER="admin"
ES_PASS="${ES_ADMIN_PASSWORD}"
REPO="backup_repo"
SNAPSHOT="$1"

echo "Validating snapshot: $SNAPSHOT"

# Check snapshot status
STATUS=$(curl -s -XGET "$ES_HOST/_snapshot/$REPO/$SNAPSHOT" \
  -u $ES_USER:$ES_PASS | jq -r '.snapshots[0].state')

if [ "$STATUS" != "SUCCESS" ]; then
  echo "ERROR: Snapshot state is $STATUS (expected SUCCESS)"
  exit 1
fi

# Verify snapshot
curl -XPOST "$ES_HOST/_snapshot/$REPO/$SNAPSHOT/_verify" \
  -u $ES_USER:$ES_PASS

# Check shard counts
SHARDS=$(curl -s -XGET "$ES_HOST/_snapshot/$REPO/$SNAPSHOT" \
  -u $ES_USER:$ES_PASS | jq -r '.snapshots[0].shards')

echo "Snapshot validation complete"
echo "Shards: $SHARDS"
```

## Recovery Time and Point Objectives

### Define Recovery Targets

**Recovery Time Objective (RTO):**
- How long can you afford to be down?
- Target: < 4 hours for complete cluster recovery

**Recovery Point Objective (RPO):**
- How much data can you afford to lose?
- Target: < 1 hour (hourly snapshots)

### Measure Recovery Metrics

**Track during DR drills:**

| Metric | Target | Actual |
|--------|--------|--------|
| Time to restore config | < 5 min | _______ |
| Time to restore 100GB data | < 30 min | _______ |
| Time to restore 1TB data | < 2 hours | _______ |
| Time to verify cluster health | < 5 min | _______ |
| Total recovery time (RTO) | < 4 hours | _______ |
{: .config-table}

## Backup Monitoring

### Monitor Backup Success

**Alert on failed snapshots:**

```bash
#!/bin/bash
# check-latest-snapshot.sh

ES_HOST="https://localhost:9200"
ES_USER="admin"
ES_PASS="${ES_ADMIN_PASSWORD}"
REPO="backup_repo"

# Get latest snapshot
LATEST=$(curl -s -XGET "$ES_HOST/_snapshot/$REPO/_all" \
  -u $ES_USER:$ES_PASS | jq -r '.snapshots | sort_by(.start_time) | last | .snapshot')

# Check status
STATUS=$(curl -s -XGET "$ES_HOST/_snapshot/$REPO/$LATEST" \
  -u $ES_USER:$ES_PASS | jq -r '.snapshots[0].state')

if [ "$STATUS" != "SUCCESS" ]; then
  echo "ALERT: Latest snapshot $LATEST failed with status: $STATUS"
  # Send alert
  curl -X POST "https://alerts.example.com/api/alert" \
    -d "{\"message\": \"Snapshot $LATEST failed: $STATUS\"}"
  exit 1
fi

echo "Latest snapshot $LATEST: $STATUS"
```

### Verify Backup Integrity

**Monthly validation:**
- Restore random snapshot to test environment
- Verify data integrity
- Test Search Guard functionality
- Document results

## Backup Security

### Access Control

**Restrict backup access:**

```bash
# File permissions
chmod 700 /backup/elasticsearch
chown elasticsearch:elasticsearch /backup/elasticsearch

# Only backup admin can restore
chmod 600 /backup/searchguard/*.tar.gz
```

**Create dedicated backup role:**

```yaml
sg_snapshot_restore:
  cluster_permissions:
    - SGS_CLUSTER_MANAGE_SNAPSHOTS
  index_permissions:
    - index_patterns:
        - '*'
      allowed_actions:
        - SGS_INDICES_ADMIN_SNAPSHOTS
```

### Secure Backup Storage

**Best practices:**
- Encrypt backups at rest
- Use private cloud storage (not public)
- Enable access logging for backup storage
- Implement least-privilege access
- Regularly rotate backup encryption keys
- Store backups in different geographic region than production

## Backup Checklist

- [ ] Configuration files backed up daily
- [ ] Configuration stored in version control
- [ ] Data snapshots running hourly/daily/weekly
- [ ] Remote snapshot repository configured
- [ ] Backups encrypted at rest
- [ ] Backup success monitored and alerted
- [ ] Recovery procedures documented
- [ ] DR drills performed quarterly
- [ ] RTO/RPO targets defined and measured
- [ ] Backup access restricted to authorized users
- [ ] Old backups pruned according to retention policy

## Next Steps

- **[Production Checklist](production-checklist)** - Complete pre-deployment verification
- **[Production Monitoring](production-monitoring)** - Monitor backup success
- **[Security Hardening](security-hardening)** - Secure backup storage
- **[Configuration Tools](search-guard-configuration-tools)** - Use sgctl for config backups
