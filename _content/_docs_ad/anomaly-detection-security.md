---
title: Anomaly Detection Security
html_title: Anomaly Detection Security
permalink: anomaly-detection-security
layout: docs
section: anomaly_detection
edition: enterprise
description: Security configuration for Anomaly Detection
---

<!---
Copyright (c) 2025 floragunn GmbH

This file contains content originally licensed under Apache-2.0.
Original license header and notices preserved below.

Additional modifications by floragunn GmbH, 2025.
Modifications Copyright floragunn GmbH

---

SPDX-License-Identifier: Apache-2.0
http://www.apache.org/licenses/LICENSE-2.0

The OpenSearch Contributors require contributions made to
this file be licensed under the Apache-2.0 license or a
compatible open source license.

Modifications Copyright OpenSearch Contributors. See
GitHub history for details.
-->

# Anomaly Detection Security

{: .no_toc}

{% include toc.md %}

You can use the Search Guard Security plugin to control access to anomaly detection features. This lets you limit which users can create, update, delete, or view detectors.

All anomaly detection indices are protected as system indices. Only super admin users or admin users with TLS certificates can access system indices directly.

## Basic Permissions

As an admin, you assign specific permissions to users based on which APIs they need. This follows the principle of least privilege—give users only the access they require to do their work.

### Required Permissions for Detector Management

Users who create and manage detectors need both cluster-level and index-level permissions. The following tables describe each permission.

**Cluster-level permissions:**

Permission | Description
:--- | :---
`cluster:admin/searchguard/ad/detector/search` | Search for detectors.
`cluster:admin/searchguard/ad/detector/info` | Get detector information.
`cluster:admin/searchguard/ad/detector/preview` | Preview detector results.
`cluster:admin/searchguard/ad/detector/validate` | Validate detector configuration.
`cluster:admin/searchguard/ad/detector/write` | Create and update detectors.
`cluster:admin/searchguard/ad/detectors/get` | Retrieve detector details.
`cluster:admin/searchguard/ad/tasks/search` | Search detector tasks.
`cluster:admin/searchguard/ad/result/search` | Search anomaly results.
`cluster:admin/searchguard/ad/detector/delete` | Delete detectors.
`cluster:admin/searchguard/ad/detector/jobmanagement` | Start and stop detector jobs.
`cluster:monitor/state` | Monitor cluster state.
{: .config-table}

**Index-level permissions:**

Permission | Description
:--- | :---
`indices:monitor/settings/get` | Get index settings.
`indices:monitor/stats` | Get index statistics.
`indices:admin/mappings/get` | Get index mappings.
{: .config-table}

Together, these permissions let users perform complete detector lifecycle management.

{% comment %}
## Pre-Configured Roles

The Security plugin includes two built-in roles for common anomaly detection scenarios:

**anomaly_full_access**: Full permissions to create, read, update, and delete detectors.

**anomaly_read_access**: Read-only access to view detectors and results.

See the Search Guard documentation for descriptions of all predefined roles.

### Additional Permissions for Kibana

If you use Kibana to create detectors, you may need additional permissions beyond the built-in roles. Search Guard 2.17+ includes these automatically, but earlier versions require manual configuration.

**Required additional permissions:**

`indices:data/read/search`: Search data sources to validate sufficient data for model training.

`indices:admin/mappings/fields/get` and `indices:admin/mappings/fields/get*`: Validate timestamp fields and categorical fields for high-cardinality detectors.

Without these permissions, detector creation in Kibana may fail.

### Custom Permission Combinations

Mix and match individual permissions to create custom roles for your specific use cases. Each permission corresponds to a REST API operation.

**Example**: The `cluster:admin/searchguard/ad/detector/delete` permission lets users delete detectors but nothing else.

## Security Considerations for Alerts

When triggers generate alerts, metadata about the queried index may be included in:

**Detector configurations**

**Monitor configurations**

**Alert contents**

**Notification messages**

By design, the plugin extracts data and stores it as metadata outside the index. Document-level security (DLS) and field-level security (FLS) protect data inside indices. However, once extracted as metadata, these controls no longer apply.

Users with access to detector configurations, alerts, or notifications can view this metadata. This might reveal information about index contents that would otherwise be concealed by DLS and FLS.

### Mitigation Strategy

Use role-based access control to limit who can access detector configurations and alerts. Consider these design principles:

**Assign permissions carefully**: Only give users the minimum access they need.

**Use backend role filtering**: Limit detector access to users with matching backend roles. See [Limit Access by Backend Role](#advanced-limit-access-by-backend-role) below.

**Educate users**: Inform users that anomaly detection results may contain metadata from protected indices.

## Selecting Remote Indices

To use a remote index as a data source for a detector, you need to configure cross-cluster authentication properly.

### Setup Requirements

**Same role on both clusters**: Use a role that exists in both remote and local clusters.

**Username mapping**: The remote cluster must map the chosen role to the same username as the local cluster.

See the Search Guard cross-cluster search documentation for detailed setup steps.

### Example: Create a User for Remote Access

This example creates a user on both local and remote clusters.

**Step 1: Create user on local cluster**

```bash
curl -XPUT -k -u 'admin:<custom-admin-password>' 'https://localhost:9200/_plugins/_security/api/internalusers/anomalyuser' -H 'Content-Type: application/json' -d '{"password":"password"}'
```

**Step 2: Map user to role on local cluster**

```bash
curl -XPUT -k -u 'admin:<custom-admin-password>' -H 'Content-Type: application/json' 'https://localhost:9200/_plugins/_security/api/rolesmapping/anomaly_full_access' -d '{"users" : ["anomalyuser"]}'
```

**Step 3: Create same user on remote cluster**

```bash
curl -XPUT -k -u 'admin:<custom-admin-password>' 'https://localhost:9250/_plugins/_security/api/internalusers/anomalyuser' -H 'Content-Type: application/json' -d '{"password":"password"}'
```

**Step 4: Map user to role on remote cluster**

```bash
curl -XPUT -k -u 'admin:<custom-admin-password>' -H 'Content-Type: application/json' 'https://localhost:9250/_plugins/_security/api/rolesmapping/anomaly_full_access' -d '{"users" : ["anomalyuser"]}'
```

Replace `<custom-admin-password>` with your actual admin password. Adjust port `9250` to match your remote cluster's port.

## Custom Results Indices

To use custom results indices, you need additional permissions beyond the default roles.

See [Advanced Configuration](anomaly-detection-advanced-config#custom-result-indices) for required permissions and setup details.

## (Advanced) Limit Access by Backend Role

Use backend roles to configure fine-grained access to individual detectors. Users only see detectors created by users who share at least one backend role.

This is useful when different departments need to manage their own detectors separately.

### Prerequisites

Users must have appropriate backend roles configured. Backend roles typically come from:

**LDAP servers**: See Search Guard LDAP documentation.

**SAML providers**: See Search Guard SAML documentation.

**Internal user database**: Use the REST API to add backend roles manually.

### Enable Backend Role Filtering

Enable the setting to activate backend role filtering:

```json
PUT _cluster/settings
{
  "transient": {
    "plugins.anomaly_detection.filter_by_backend_roles": "true"
  }
}
```

Once enabled, users only see detectors created by users with shared backend roles.

### Example Scenario

Consider two users: `alice` and `bob`.

**Alice's configuration:**

```json
PUT _plugins/_security/api/internalusers/alice
{
  "password": "alice",
  "backend_roles": [
    "analyst"
  ],
  "attributes": {}
}
```

Alice has the `analyst` backend role.

**Bob's configuration:**

```json
PUT _plugins/_security/api/internalusers/bob
{
  "password": "bob",
  "backend_roles": [
    "human-resources"
  ],
  "attributes": {}
}
```

Bob has the `human-resources` backend role.

**Both users have full anomaly detection access:**

```json
PUT _plugins/_security/api/rolesmapping/anomaly_full_access
{
  "backend_roles": [],
  "hosts": [],
  "users": [
    "alice",
    "bob"
  ]
}
```

Because alice and bob have different backend roles, they cannot view each other's detectors or results.

### Users Without Backend Roles

Users without backend roles can still view other users' anomaly detection results if they have read access permissions. This applies to both read-only and full-access roles.

**Important**: Administrators should inform users that read access allows viewing results from any detector in the cluster. This includes data not directly accessible through other means.

**Best practice**: Use backend role filters when creating detectors. This ensures only users with matching backend roles can access results from those detectors.

{% endcomment %}