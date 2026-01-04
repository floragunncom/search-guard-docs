---
title: Production Monitoring
html_title: Production Monitoring
permalink: production-monitoring
layout: docs
section: security
description: Monitoring and alerting for Search Guard in production environments
---

<!--- Copyright 2025 floragunn GmbH --->

# Production Monitoring

Effective monitoring is critical for maintaining a secure and performant Search Guard deployment. This guide covers what to monitor, how to set up alerts, and how to respond to common issues.

## What to Monitor

### Security Events

**Critical security events requiring immediate attention:**

| Event | Severity | Action |
|-------|----------|--------|
| Multiple failed login attempts | High | Investigate potential brute force attack |
| Authorization failures | Medium | Check for misconfigured permissions |
| TLS handshake failures | High | Possible MITM attack or certificate issue |
| Admin configuration changes | Medium | Verify authorized changes |
| Unusual data access patterns | High | Potential data exfiltration |
| Certificate expiration warnings | High | Renew certificates immediately |
{: .config-table}

### Performance Metrics

**Search Guard performance indicators:**

| Metric | Threshold | Issue |
|--------|-----------|-------|
| Authentication latency | > 100ms | Cache miss rate too high, slow auth backend |
| Authorization latency | > 50ms | Complex role definitions, too many roles |
| DLS query overhead | > 20% slower | Inefficient DLS queries |
| Audit log queue size | > 80% full | Audit processing bottleneck |
| Authentication cache hit rate | < 80% | TTL too short, cache too small |
{: .config-table}

### System Health

**Elasticsearch cluster health:**
- Cluster status (green/yellow/red)
- Node availability
- Shard allocation
- JVM heap usage
- GC pause times
- Thread pool rejections
- Disk space usage

## Monitoring Tools

### Elasticsearch APIs

**Built-in monitoring endpoints:**

**1. Cluster health:**
```bash
curl -XGET "https://localhost:9200/_cluster/health?pretty" \
  -u admin:password
```

**Response:**
```json
{
  "cluster_name": "production",
  "status": "green",
  "number_of_nodes": 5,
  "active_shards": 1000
}
```

**Alert if:** `status` is `yellow` or `red`

**2. Node stats:**
```bash
curl -XGET "https://localhost:9200/_nodes/stats?pretty" \
  -u admin:password
```

**Monitor:**
- `jvm.mem.heap_used_percent` (alert if > 75%)
- `jvm.gc.collectors.*.collection_time_in_millis` (alert if increasing rapidly)
- `thread_pool.*.rejected` (alert if > 0)

**3. Search Guard health:**
```bash
curl -XGET "https://localhost:9200/_searchguard/health?pretty" \
  -u admin:password
```

**4. Search Guard authentication info:**
```bash
curl -XGET "https://localhost:9200/_searchguard/authinfo?pretty" \
  -u admin:password
```

### Audit Log Monitoring

**Query audit logs for security events:**

**Failed logins in last hour:**
```bash
curl -XGET "https://localhost:9200/sg_auditlog-*/_search?pretty" \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "must": [
        {"term": {"audit_category": "FAILED_LOGIN"}},
        {"range": {"@timestamp": {"gte": "now-1h"}}}
      ]
    }
  },
  "aggs": {
    "by_user": {
      "terms": {
        "field": "audit_request_effective_user",
        "size": 10
      }
    }
  }
}'
```

**Authorization failures:**
```bash
curl -XGET "https://localhost:9200/sg_auditlog-*/_search?pretty" \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "must": [
        {"term": {"audit_category": "MISSING_PRIVILEGES"}},
        {"range": {"@timestamp": {"gte": "now-1h"}}}
      ]
    }
  }
}'
```

**Configuration changes:**
```bash
curl -XGET "https://localhost:9200/sg_auditlog-*/_search?pretty" \
  -H 'Content-Type: application/json' -d '{
  "query": {
    "bool": {
      "must": [
        {"term": {"audit_category": "SG_INDEX_ATTEMPT"}},
        {"range": {"@timestamp": {"gte": "now-24h"}}}
      ]
    }
  }
}'
```

### Metrics Collection

**Popular monitoring stacks:**

**1. Elastic Stack (Metricbeat + Kibana):**
```yaml
# metricbeat.yml
metricbeat.modules:
  - module: elasticsearch
    metricsets:
      - node
      - node_stats
      - cluster_stats
    period: 10s
    hosts: ["https://localhost:9200"]
    username: "monitoring_user"
    password: "${MONITORING_PASSWORD}"
    ssl.verification_mode: "full"
    ssl.certificate_authorities: ["/path/to/ca.pem"]
```

**2. Prometheus + Grafana:**

Use Elasticsearch exporter:
```yaml
# elasticsearch_exporter
./elasticsearch_exporter \
  --es.uri=https://localhost:9200 \
  --es.all \
  --es.cluster_settings \
  --es.ssl-skip-verify=false \
  --es.ca=/path/to/ca.pem
```

**3. Datadog, New Relic, or other APM:**

Configure using agent and Elasticsearch integration.

### Log Aggregation

**Centralize Elasticsearch logs:**

**1. Filebeat to ship logs:**
```yaml
# filebeat.yml
filebeat.inputs:
  - type: log
    paths:
      - /var/log/elasticsearch/*.log
    fields:
      cluster: production
      node: ${NODE_NAME}

output.elasticsearch:
  hosts: ["https://logs-cluster:9200"]
  username: "filebeat"
  password: "${FILEBEAT_PASSWORD}"
```

**2. Parse logs for errors:**
```
[WARN].*authentication failed
[ERROR].*TLS.*handshake
[ERROR].*certificate.*expired
```

## Alerting with Search Guard Signals

### Failed Login Alert

**Detect brute force attacks:**

**sg_signals/watch/failed-logins.json:**
```json
{
  "trigger": {
    "schedule": {
      "interval": ["5m"]
    }
  },
  "checks": [
    {
      "type": "search",
      "name": "failed_logins",
      "target": "sg_auditlog-*",
      "request": {
        "query": {
          "bool": {
            "must": [
              {"term": {"audit_category": "FAILED_LOGIN"}},
              {"range": {"@timestamp": {"gte": "now-5m"}}}
            ]
          }
        },
        "aggs": {
          "by_user": {
            "terms": {
              "field": "audit_request_effective_user",
              "size": 10,
              "min_doc_count": 5
            }
          }
        }
      }
    }
  ],
  "checks.0.severity": "warning",
  "actions": [
    {
      "type": "email",
      "name": "security_team",
      "throttle_period": "1h",
      "account": "default",
      "to": ["security@example.com"],
      "subject": "Alert: Multiple Failed Login Attempts Detected",
      "body": "User(s) with failed login attempts:\n{{#data.failed_logins.aggregations.by_user.buckets}}\n- {{key}}: {{doc_count}} failures\n{{/data.failed_logins.aggregations.by_user.buckets}}"
    }
  ]
}
```

### Certificate Expiration Alert

**Monitor certificate validity:**

**sg_signals/watch/cert-expiration.json:**
```json
{
  "trigger": {
    "schedule": {
      "daily": {"at": ["09:00"]}
    }
  },
  "checks": [
    {
      "type": "static",
      "name": "check_cert",
      "severity": "error",
      "target": "cert_expiry_days",
      "value": "{{data.cert_expiry_days}}"
    }
  ],
  "actions": [
    {
      "type": "email",
      "name": "ops_team",
      "account": "default",
      "to": ["ops@example.com"],
      "subject": "URGENT: SSL Certificate Expiring Soon",
      "body": "Certificate expires in {{data.cert_expiry_days}} days. Renew immediately!",
      "checks": {
        "check_cert": {
          "severity": ["error", "critical"]
        }
      }
    }
  ]
}
```

**Script to check certificate:**
```bash
#!/bin/bash
# cert-check.sh

CERT_FILE="/etc/elasticsearch/certs/node.pem"
EXPIRY_DATE=$(openssl x509 -enddate -noout -in "$CERT_FILE" | cut -d= -f2)
EXPIRY_EPOCH=$(date -d "$EXPIRY_DATE" +%s)
NOW_EPOCH=$(date +%s)
DAYS_UNTIL_EXPIRY=$(( ($EXPIRY_EPOCH - $NOW_EPOCH) / 86400 ))

# Index result for Signals to monitor
curl -XPOST "https://localhost:9200/cert-monitoring/_doc" \
  -H 'Content-Type: application/json' -d "{
  \"@timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",
  \"cert_expiry_days\": $DAYS_UNTIL_EXPIRY,
  \"cert_file\": \"$CERT_FILE\"
}"

# Exit with error if < 30 days
if [ $DAYS_UNTIL_EXPIRY -lt 30 ]; then
  echo "WARNING: Certificate expires in $DAYS_UNTIL_EXPIRY days!"
  exit 1
fi
```

### Cluster Health Alert

**Alert on cluster status changes:**

**sg_signals/watch/cluster-health.json:**
```json
{
  "trigger": {
    "schedule": {
      "interval": ["1m"]
    }
  },
  "checks": [
    {
      "type": "condition",
      "name": "cluster_status",
      "source": "data.cluster_health.status != 'green'",
      "severity": {
        "mapping": {
          "data.cluster_health.status == 'yellow'": "warning",
          "data.cluster_health.status == 'red'": "error"
        }
      }
    }
  ],
  "actions": [
    {
      "type": "slack",
      "name": "ops_channel",
      "account": "default",
      "channel": "#elasticsearch-alerts",
      "text": "⚠️ Cluster status is {{data.cluster_health.status}}!\n{{data.cluster_health.unassigned_shards}} unassigned shards.",
      "checks": {
        "cluster_status": {
          "severity": ["warning", "error"]
        }
      }
    }
  ]
}
```

### High JVM Heap Usage Alert

```json
{
  "trigger": {
    "schedule": {
      "interval": ["5m"]
    }
  },
  "checks": [
    {
      "type": "condition",
      "name": "high_heap",
      "source": "data.nodes_stats.nodes.any(node -> node.jvm.mem.heap_used_percent > 85)",
      "severity": "warning"
    }
  ],
  "actions": [
    {
      "type": "pagerduty",
      "name": "oncall",
      "account": "default",
      "routing_key": "${env.PAGERDUTY_KEY}",
      "event_action": "trigger",
      "summary": "High JVM heap usage detected",
      "severity": "warning"
    }
  ]
}
```

### Unusual Data Access Pattern Alert

**Detect potential data exfiltration:**

```json
{
  "trigger": {
    "schedule": {
      "interval": ["10m"]
    }
  },
  "checks": [
    {
      "type": "search",
      "name": "bulk_reads",
      "target": "sg_auditlog-*",
      "request": {
        "query": {
          "bool": {
            "must": [
              {"term": {"audit_category": "GRANTED_PRIVILEGES"}},
              {"term": {"audit_request_privilege": "indices:data/read/*"}},
              {"range": {"@timestamp": {"gte": "now-10m"}}}
            ]
          }
        },
        "aggs": {
          "by_user": {
            "terms": {
              "field": "audit_request_effective_user",
              "size": 10
            },
            "aggs": {
              "doc_count": {
                "sum": {
                  "field": "audit_request_body.size"
                }
              }
            }
          }
        }
      }
    }
  ],
  "checks.0.severity": {
    "mapping": {
      "data.bulk_reads.aggregations.by_user.buckets.any(b -> b.doc_count.value > 100000)": "error"
    }
  },
  "actions": [
    {
      "type": "email",
      "name": "security_team",
      "account": "default",
      "to": ["security@example.com"],
      "subject": "SECURITY ALERT: Unusual bulk data access detected",
      "body": "Large data access detected:\n{{#data.bulk_reads.aggregations.by_user.buckets}}\n- User: {{key}}, Documents: {{doc_count.value}}\n{{/data.bulk_reads.aggregations.by_user.buckets}}"
    }
  ]
}
```

## Monitoring Dashboards

### Kibana Dashboards

**Create monitoring dashboards in Kibana:**

**1. Security Overview Dashboard:**
- Failed login attempts (last 24h)
- Authorization failures by user
- Recent configuration changes
- Active sessions count

**2. Performance Dashboard:**
- Search latency (p50, p95, p99)
- Authentication cache hit rate
- Audit log processing rate
- JVM heap usage
- GC pause times

**3. Cluster Health Dashboard:**
- Cluster status
- Node count
- Shard allocation
- Disk space usage
- CPU and memory usage

**Example visualization (Vega):**
```json
{
  "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
  "data": {
    "url": {
      "index": "sg_auditlog-*",
      "body": {
        "query": {
          "range": {"@timestamp": {"gte": "now-24h"}}
        },
        "aggs": {
          "over_time": {
            "date_histogram": {
              "field": "@timestamp",
              "interval": "1h"
            },
            "aggs": {
              "by_category": {
                "terms": {"field": "audit_category"}
              }
            }
          }
        }
      }
    }
  },
  "mark": "bar",
  "encoding": {
    "x": {"field": "@timestamp", "type": "temporal"},
    "y": {"field": "count", "type": "quantitative"},
    "color": {"field": "audit_category", "type": "nominal"}
  }
}
```

### Grafana Dashboards

**Example Prometheus queries:**

**Authentication latency:**
```promql
histogram_quantile(0.99,
  rate(searchguard_authentication_duration_seconds_bucket[5m])
)
```

**Failed logins per minute:**
```promql
rate(searchguard_failed_login_total[1m])
```

**JVM heap usage:**
```promql
elasticsearch_jvm_memory_used_bytes{area="heap"}
/
elasticsearch_jvm_memory_max_bytes{area="heap"} * 100
```

## Log Analysis

### Common Log Patterns

**1. Failed authentication:**
```
[WARN ][c.f.s.a.BackendRegistry] Authentication finally failed for user1 from 192.168.1.100
```

**Action:** Investigate source IP, check for brute force.

**2. TLS handshake failure:**
```
[WARN ][o.e.h.n.Netty4HttpServerTransport] caught exception while handling client http traffic, closing connection
io.netty.handler.ssl.NotSslRecordException: not an SSL/TLS record
```

**Action:** Check client TLS configuration, verify certificate validity.

**3. Missing privileges:**
```
[WARN ][c.f.s.p.PrivilegesEvaluator] No index-level permission match for user1 [indices:data/write/index] on index logs-2024
```

**Action:** Review user roles and permissions.

**4. Certificate expiration:**
```
[ERROR][c.f.s.s.DefaultSearchGuardKeyStore] Certificate expired: CN=node-1
```

**Action:** Renew certificate immediately.

### Log Retention

**Configure log rotation:**

**logrotate config (/etc/logrotate.d/elasticsearch):**
```
/var/log/elasticsearch/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 644 elasticsearch elasticsearch
    postrotate
        /usr/bin/systemctl reload elasticsearch > /dev/null 2>&1 || true
    endscript
}
```

## Incident Response Runbooks

### High Failed Login Rate

**Detection:** > 5 failed logins per user in 5 minutes

**Response:**
1. Identify affected user(s) from audit logs
2. Check source IPs - single IP or distributed?
3. If single IP: Block at firewall level
4. If distributed: Enable account lockout
5. Contact user to verify if legitimate activity
6. Reset password if account compromised

### Cluster Status Yellow/Red

**Detection:** Cluster health API returns non-green status

**Response:**
1. Check unassigned shards: `GET /_cat/shards?v&h=index,shard,prirep,state,unassigned.reason`
2. Check node status: `GET /_cat/nodes?v`
3. Review Elasticsearch logs for errors
4. If node failure: Restart failed node
5. If disk space: Free up disk or add nodes
6. If shard allocation issue: Review allocation settings

### Certificate Expiration

**Detection:** Certificate expires in < 30 days

**Response:**
1. Generate new certificates
2. Test new certificates in staging environment
3. Schedule maintenance window
4. Perform rolling certificate update using hot reload
5. Verify TLS connectivity after update
6. Update monitoring with new expiration date

### Unusual Data Access

**Detection:** User accessed > 100,000 documents in 10 minutes

**Response:**
1. Identify user from audit logs
2. Review query patterns - legitimate or suspicious?
3. Check source IP and time of day
4. If suspicious: Disable user account immediately
5. Contact user to verify if legitimate
6. Review data accessed - any sensitive data?
7. File security incident report
8. Reset user credentials if compromised

## Health Checks

### Automated Health Checks

**Script to run every 5 minutes:**

```bash
#!/bin/bash
# es-health-check.sh

ES_HOST="https://localhost:9200"
ES_USER="monitoring"
ES_PASS="${MONITORING_PASSWORD}"

# Cluster health
CLUSTER_STATUS=$(curl -s -u $ES_USER:$ES_PASS "$ES_HOST/_cluster/health" | jq -r '.status')

if [ "$CLUSTER_STATUS" != "green" ]; then
  echo "ALERT: Cluster status is $CLUSTER_STATUS"
  # Send alert
  curl -X POST "https://alerts.example.com/api/alert" \
    -d "{\"message\": \"Cluster status: $CLUSTER_STATUS\"}"
fi

# Check nodes
NODE_COUNT=$(curl -s -u $ES_USER:$ES_PASS "$ES_HOST/_cat/nodes" | wc -l)
if [ $NODE_COUNT -lt 5 ]; then
  echo "ALERT: Only $NODE_COUNT nodes active (expected 5)"
fi

# Check disk space
DISK_USAGE=$(curl -s -u $ES_USER:$ES_PASS "$ES_HOST/_cat/allocation?v&h=disk.percent" | tail -n +2 | sort -rn | head -1)
if [ ${DISK_USAGE%\%} -gt 80 ]; then
  echo "ALERT: Disk usage is $DISK_USAGE"
fi
```

### Manual Health Checks

**Weekly checklist:**
- [ ] Review audit logs for security anomalies
- [ ] Check certificate expiration dates
- [ ] Review failed login patterns
- [ ] Verify backup completion
- [ ] Check cluster performance metrics
- [ ] Review recent configuration changes

## Next Steps

- **[Production Checklist](production-checklist)** - Complete pre-deployment verification
- **[Security Hardening](security-hardening)** - Implement security best practices
- **[Performance Tuning](performance-tuning)** - Optimize performance
- **[Audit and Compliance](search-guard-audit-compliance)** - Configure audit logging
