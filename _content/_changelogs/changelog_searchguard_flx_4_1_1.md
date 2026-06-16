---
title: Search Guard FLX 4.1.1
permalink: changelog-searchguard-flx-4_1_1
layout: docs
section: security
description: Changelog for Search Guard FLX 4.1.1
---
<!--- Copyright 2026 floragunn GmbH -->
# Search Guard FLX 4.1.1

**Release Date: 2026-06-16**

## Kibana: Known issues

The following issues affect Kibana 9.4.0 and later releases.

### Requests with an `Authorization: Basic` header fail

Requests authenticated with `Authorization: Basic` headers fail with a 500 error response, preventing Kibana from loading. Bearer-token authentication is not affected. The issue will be fixed in an upcoming Kibana release, most likely 9.4.3.

### Entity Store repeatedly logs error messages about fake requests

To avoid repeated `No fake request found` error messages from Entity Store v2 in the Kibana log, add the following to `kibana.yml` before starting Kibana:

```yaml
uiSettings:
  overrides:
    "securitySolution:entityStoreEnableV2": false
```

Entity Store v2 became opt-out in Kibana 9.4 — Kibana installs it automatically, and its background tasks produce these error messages on every run.

**If errors are already in your logs.**
If the Kibana log already contains lines like:

```
[ERROR][plugins.entityStore.entity_store:v2:extract_entity_task:user:default] No fake request found, skipping extract entity task
```

call the uninstall API **before** applying the `kibana.yml` override above:

```bash
curl -ksS -u admin:admin \
  -H 'kbn-xsrf: true' \
  -X POST 'https://localhost:5601/api/security/entity_store/uninstall' -d '{}'
```

Adjust the credentials and Kibana URL to match your environment.

Once the override is in place, the uninstall API also returns 403, so leftover tasks must be removed first.
