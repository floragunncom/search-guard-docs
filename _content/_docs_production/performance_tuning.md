---
title: Performance Tuning
html_title: Performance Tuning
permalink: performance-tuning
layout: docs
section: security
description: Performance tuning and optimization for Search Guard in production environments
---

<!--- Copyright 2025 floragunn GmbH --->

# Performance Tuning

Search Guard adds security layers to Elasticsearch which introduce some performance overhead. This guide helps you optimize Search Guard configuration to minimize impact on cluster performance while maintaining security.

## Understanding Performance Impact

Search Guard performance overhead comes from:

| Feature | Impact | Mitigation |
|---------|--------|------------|
| **TLS Encryption** | Low (1-5%) | Use modern CPUs with AES-NI, TLS 1.3 |
| **Authentication** | Low-Medium | Enable caching, use efficient auth backend |
| **Authorization** | Low | Use simple role definitions, avoid wildcards |
| **Document-Level Security (DLS)** | Medium-High | Optimize DLS queries, use efficient filters |
| **Field-Level Security (FLS)** | Low-Medium | Limit number of excluded fields |
| **Field Masking** | Medium | Use selectively, not on all fields |
| **Audit Logging** | Low-High | Use async logging, filter unnecessary events |
{: .config-table}

## TLS Performance

### Hardware Acceleration

**Use CPUs with AES-NI:**
Modern CPUs have hardware acceleration for AES encryption, dramatically improving TLS performance.

**Verify AES-NI support:**
```bash
# Linux
grep aes /proc/cpuinfo

# If AES-NI is available, you'll see 'aes' in the flags
```

### TLS 1.3

**Use TLS 1.3 for better performance:**

TLS 1.3 has fewer round trips and improved cipher suites:

**elasticsearch.yml:**
```yaml
searchguard.ssl.http.enabled_protocols:
  - "TLSv1.3"
  - "TLSv1.2"  # Fallback for older clients

searchguard.ssl.transport.enabled_protocols:
  - "TLSv1.3"
  - "TLSv1.2"
```

### Cipher Suite Selection

**Choose performant cipher suites:**

ECDHE with AES-GCM provides good balance of security and performance:

```yaml
searchguard.ssl.http.enabled_ciphers:
  - "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
  - "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
```

Avoid older cipher suites (CBC mode, 3DES) which are slower.

## Authentication Performance

### Enable Authentication Caching

**Cache authentication results to reduce backend load:**

**sg_config.yml:**
```yaml
auth_domains:
  - type: basic
    authentication_backend:
      type: ldap
      config:
        cache:
          enable: true
          ttl_minutes: 60  # Cache for 1 hour
          max_size: 1000   # Maximum cached users
```

**Cache considerations:**
- **TTL**: Longer cache = better performance, but slower to reflect user changes
- **Size**: Set based on active user count
- **Invalidation**: Changes to users require cache clear or waiting for TTL

### Choose Efficient Authentication Backend

**Performance ranking (fastest to slowest):**

1. **Client Certificates** - No external lookups, very fast
2. **JWT** - Self-contained, no backend required
3. **Internal Users Database** - Local to Elasticsearch
4. **LDAP/Active Directory** - Network latency, consider caching
5. **Kerberos** - Additional protocol overhead

**Recommendation:** For high-throughput applications, prefer JWT or client certificates.

### Optimize LDAP Configuration

**If using LDAP:**

**1. Use connection pooling:**
```yaml
authentication_backend:
  type: ldap
  config:
    connection_pool:
      initial_size: 5
      max_size: 20
    connection_timeout: 5000
```

**2. Minimize LDAP queries:**
```yaml
authentication_backend:
  type: ldap
  config:
    # Use specific search base (not root DN)
    userbase: 'ou=people,dc=example,dc=com'

    # Cache user-to-role mappings
    cache:
      enable: true
      ttl_minutes: 120
```

**3. Enable LDAP connection reuse:**
```yaml
authentication_backend:
  type: ldap
  config:
    enable_connection_reuse: true
```

## Authorization Performance

### Optimize Role Definitions

**Avoid wildcard permissions:**

**Slow:**
```yaml
sg_role:
  index_permissions:
    - index_patterns:
        - '*'  # Matches all indices on every request
      allowed_actions:
        - '*'
```

**Fast:**
```yaml
sg_role:
  index_permissions:
    - index_patterns:
        - 'logs-2024-*'  # Specific pattern
      allowed_actions:
        - SGS_READ  # Specific action group
```

### Use Action Groups

**Prefer action groups over listing individual permissions:**

**Slow (many individual permissions):**
```yaml
allowed_actions:
  - indices:data/read/search
  - indices:data/read/get
  - indices:data/read/mget
  - indices:data/read/msearch
  - indices:admin/mappings/get
  - indices:admin/get
```

**Fast (single action group):**
```yaml
allowed_actions:
  - SGS_READ  # Expands to all read permissions
```

### Minimize Role Mappings

**Reduce number of role mappings per user:**

**Slow (user has 20+ roles):**
Each request must evaluate permissions from all 20 roles.

**Fast (user has 2-3 roles):**
Fewer roles = faster permission evaluation.

**Best practice:** Consolidate related permissions into fewer, comprehensive roles.

## Document-Level Security (DLS) Performance

DLS has the highest performance impact because it adds a filter to every query.

### Optimize DLS Queries

**Use efficient query types:**

**Fast DLS queries:**
```yaml
# Term query (fastest - uses inverted index)
dls: '{"term": {"department": "engineering"}}'

# Terms query (fast - multiple values)
dls: '{"terms": {"status": ["active", "pending"]}}'

# Range query (fast with indexed fields)
dls: '{"range": {"created": {"gte": "2024-01-01"}}}'
```

**Slow DLS queries:**
```yaml
# Wildcard query (slow - no index optimization)
dls: '{"wildcard": {"name": "*smith*"}}'

# Regexp query (slow)
dls: '{"regexp": {"email": ".*@example\\.com"}}'

# Script query (very slow)
dls: '{"script": {"script": "doc[\"value\"].value > 100"}}'
```

### Use Indexed Fields for DLS

**Ensure DLS fields are indexed and not analyzed:**

**Index mapping:**
```json
{
  "mappings": {
    "properties": {
      "department": {
        "type": "keyword"  // Keyword for exact match (fast)
      },
      "user_id": {
        "type": "keyword"  // Don't use 'text' for DLS fields
      }
    }
  }
}
```

### Combine DLS with Index Patterns

**Limit DLS scope with specific index patterns:**

**Less efficient:**
```yaml
index_permissions:
  - index_patterns:
      - '*'  # DLS applied to all indices
    dls: '{"term": {"department": "engineering"}}'
```

**More efficient:**
```yaml
index_permissions:
  - index_patterns:
      - 'sensitive-*'  # DLS only on sensitive indices
    dls: '{"term": {"department": "engineering"}}'
  - index_patterns:
      - 'public-*'  # No DLS on public indices
    allowed_actions:
      - SGS_READ
```

### Avoid Complex DLS Queries

**Simple is faster:**

**Slow (complex nested query):**
```yaml
dls: '{
  "bool": {
    "must": [
      {"terms": {"tags": ["a", "b", "c"]}},
      {"range": {"date": {"gte": "now-30d"}}},
      {"wildcard": {"name": "*test*"}}
    ],
    "should": [
      {"match": {"description": "important"}},
      {"term": {"priority": "high"}}
    ],
    "minimum_should_match": 1
  }
}'
```

**Fast (simple term filter):**
```yaml
dls: '{"term": {"department": "${user.department}"}}'
```

### DLS Performance Testing

**Benchmark DLS impact:**

```bash
# Without DLS
curl -XGET "https://localhost:9200/myindex/_search" -d '{
  "query": {"match_all": {}}
}' -w "\nTime: %{time_total}s\n"

# With DLS
# Login as user with DLS, run same query
# Compare times
```

**Target:** DLS overhead should be < 20% for well-optimized queries.

## Field-Level Security (FLS) Performance

### Minimize Excluded Fields

**Prefer whitelist (include) over blacklist (exclude):**

**Less efficient (exclude many fields):**
```yaml
fls:
  - '~ssn'
  - '~salary'
  - '~dob'
  - '~address.*'
  - '~phone'
  # ... 20 more excluded fields
```

**More efficient (include specific fields):**
```yaml
fls:
  - 'name'
  - 'email'
  - 'department'
  - 'title'
```

**Why:** Including specific fields is faster than excluding many fields.

### Avoid FLS on Large Documents

FLS processes documents after retrieval, so large documents with FLS are slower.

**If possible:**
- Store sensitive fields in separate index
- Use DLS instead of FLS when appropriate
- Limit document size

## Field Masking Performance

### Selective Masking

**Only mask truly sensitive fields:**

**Avoid:**
```yaml
masked_fields:
  - '*ssn*'
  - '*credit*'
  - '*password*'
  - '*salary*'
  # Masking too many fields
```

**Prefer:**
```yaml
masked_fields:
  - 'ssn'
  - 'credit_card_number'
  # Only specific sensitive fields
```

### Hashing Algorithm

**Default SHA-256 is performant for most use cases.**

If extreme performance is needed, consider:
- Field masking only on specific indices
- Client-side hashing before indexing
- Separate "masked" index with pre-computed hashes

## Audit Logging Performance

Audit logging can significantly impact performance if not configured carefully.

### Use Asynchronous Logging

**Enable async logging:**

**sg_config.yml:**
```yaml
audit:
  type: internal_elasticsearch
  config:
    enable_transport_audit: false  # High overhead, disable unless needed
    enable_rest_audit: true

    # Async settings
    threadpool:
      size: 10
      max_queue_len: 100000
```

### Filter Audit Events

**Only log necessary events:**

**Slow (log everything):**
```yaml
audit:
  config:
    disabled_categories: []  # Logs all events
```

**Fast (selective logging):**
```yaml
audit:
  config:
    disabled_categories:
      - GRANTED_PRIVILEGES  # Don't log successful auth
      - AUTHENTICATED        # Don't log every authentication

    # Only log security-relevant events
    enabled_categories:
      - FAILED_LOGIN
      - MISSING_PRIVILEGES
      - SG_INDEX_ATTEMPT
```

### External Audit Storage

**Send audit logs to external system:**

**Benefits:**
- Reduces load on Elasticsearch cluster
- Prevents audit logs from affecting cluster performance
- Dedicated storage for compliance

**Options:**
- External Elasticsearch cluster (dedicated for audit logs)
- Log aggregation system (Splunk, Datadog, etc.)
- File-based logging with log shipping

**sg_config.yml:**
```yaml
audit:
  type: external_elasticsearch
  config:
    http_endpoints:
      - 'https://audit-cluster:9200'
    username: 'audit_user'
    password: '${env.AUDIT_PASSWORD}'
```

### Exclude High-Volume Endpoints

**Don't audit monitoring/health checks:**

```yaml
audit:
  config:
    ignore_requests:
      - '/_cluster/health'
      - '/_nodes/stats'
      - '/_cat/*'
      - '/metricbeat-*/_search'  # Exclude monitoring queries
```

## Caching Strategies

### Authentication Cache

**Already covered above - critical for performance.**

**Quick reference:**
```yaml
cache:
  enable: true
  ttl_minutes: 60
  max_size: 1000
```

### Elasticsearch Query Cache

**Ensure query cache is enabled:**

**elasticsearch.yml:**
```yaml
indices.queries.cache.size: 10%  # 10% of heap for query cache
```

**DLS queries can benefit from query cache.**

### Request Cache

**Enable request cache for read-heavy workloads:**

**elasticsearch.yml:**
```yaml
indices.requests.cache.size: 2%  # Default is 1%
```

**Use in queries:**
```json
{
  "query": {...},
  "request_cache": true
}
```

## JVM and Elasticsearch Tuning

### Heap Size

**Set appropriate heap size:**

```bash
# In jvm.options
-Xms16g
-Xmx16g
```

**Rules:**
- Set Xms = Xmx (avoid heap resizing)
- Don't exceed 50% of system RAM
- Don't exceed 31GB (compressed pointers limit)

### Garbage Collection

**Use G1GC for large heaps:**

```bash
# In jvm.options
-XX:+UseG1GC
-XX:MaxGCPauseMillis=200
```

**Monitor GC overhead:** High GC time indicates heap pressure.

### Thread Pools

**Increase search thread pool if needed:**

**elasticsearch.yml:**
```yaml
thread_pool:
  search:
    size: 30  # Default formula: (cores * 3) / 2 + 1
    queue_size: 1000
```

**Monitor thread pool stats:**
```bash
curl -XGET "https://localhost:9200/_nodes/stats/thread_pool"
```

Look for `rejected` counter - if increasing, thread pool is saturated.

## Monitoring Performance

### Key Metrics to Monitor

**Search Guard metrics:**
- Authentication cache hit rate
- Authorization time
- DLS query execution time
- Audit log queue size

**Elasticsearch metrics:**
- Search latency (p50, p99)
- Indexing rate
- JVM heap usage
- GC time
- Thread pool queue/rejections

### Search Guard Statistics

**Get Search Guard stats:**
```bash
curl -XGET "https://localhost:9200/_searchguard/authinfo"
curl -XGET "https://localhost:9200/_searchguard/health"
```

### Slow Query Logging

**Enable slow query logging:**

**elasticsearch.yml:**
```yaml
index.search.slowlog.threshold.query.warn: 10s
index.search.slowlog.threshold.query.info: 5s
index.search.slowlog.threshold.query.debug: 2s
index.search.slowlog.threshold.query.trace: 500ms
```

**DLS queries appear in slow logs** - investigate slow DLS filters.

## Performance Testing

### Benchmark Methodology

**1. Establish baseline (no security):**
```bash
# Measure without Search Guard (not recommended for production!)
```

**2. Enable Search Guard with minimal config:**
```bash
# TLS only, no DLS/FLS, minimal audit logging
# Measure performance
```

**3. Add features incrementally:**
```bash
# Add authentication → measure
# Add DLS → measure
# Add FLS → measure
# Add audit logging → measure
```

### Load Testing Tools

**Use realistic load testing:**

**Tools:**
- **Rally** - Elasticsearch benchmarking tool
- **JMeter** - HTTP load testing
- **Gatling** - Scala-based load testing
- **Locust** - Python load testing

**Example Rally test:**
```bash
esrally race \
  --track=http_logs \
  --target-hosts=localhost:9200 \
  --client-options="use_ssl:true,verify_certs:true,basic_auth_user:'user',basic_auth_password:'pass'"
```

### Performance Budget

**Set performance targets:**

| Operation | Target Latency | Notes |
|-----------|----------------|-------|
| Simple search (no DLS) | < 50ms | p99 |
| Search with DLS | < 100ms | p99 |
| Authentication | < 10ms | Cached |
| Authorization check | < 5ms | No DLS |
| Bulk indexing | > 10,000 docs/sec | With audit logging |
{: .config-table}

## Optimization Checklist

- [ ] TLS 1.3 enabled with modern ciphers
- [ ] AES-NI hardware acceleration available
- [ ] Authentication caching enabled
- [ ] LDAP connection pooling configured (if applicable)
- [ ] Role definitions use action groups
- [ ] Wildcard permissions minimized
- [ ] DLS uses simple term/terms queries
- [ ] DLS fields are keyword type (indexed)
- [ ] FLS uses whitelist (include) approach
- [ ] Field masking limited to sensitive fields only
- [ ] Audit logging is asynchronous
- [ ] Audit events filtered (exclude high-volume events)
- [ ] Monitoring/health checks excluded from audit
- [ ] Elasticsearch query cache enabled
- [ ] Heap size appropriately configured
- [ ] Performance baseline established
- [ ] Load testing performed with realistic data

## Next Steps

- **[Production Monitoring](production-monitoring)** - Set up performance monitoring
- **[Security Hardening](security-hardening)** - Ensure security while optimizing
- **[Production Checklist](production-checklist)** - Complete deployment verification
- **[Fine-Grained Access Control](search-guard-fine-grained-access)** - DLS/FLS optimization techniques
