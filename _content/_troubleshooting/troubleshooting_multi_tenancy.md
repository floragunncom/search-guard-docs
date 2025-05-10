---
title: Multi-Tenancy Troubleshooting
html_title: Multi-Tenancy help
permalink: troubleshooting-multi-tenancy
layout: docs
description: Step-by-step instructions on how to troubleshoot Multi-Tenancy issues.
---
<!--- Copyright 2022 floragunn GmbH -->

# Troubleshooting Multi-Tenancy

## Headers not whitelisted

During Kibana startup, Search Guard checks whether the `sgtenant` header has been added to the `elasticsearch.requestHeadersWhitelist` configuration key in `kibana.yml`. If this is not the case, the state of the plugin will be red, and you will see an error page when trying to access Kibana. Make sure you have whitelisted this header:

```yaml
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant", ... ]
```

## Readonly tenants and write operations
In some cases, Kibana tries to perform write operations even though the user is currently in a tenant for which they only have read access, which will result in errors.

One such case may be Kibana's prompt for the user to opt in to telemetry. If the user accepts or rejects, an error may be thrown when Kibana tries to save the user action.
For this particular case, it may be helpful to disable telemetry in `kibana.yml`:

```yml
telemetry:
  enabled: false
  optIn: false
  allowChangingOptInStatus: false
```

## Elasticsearch: Multi-Tenancy not enabled

If the Search Guard Multi-Tenancy module is not installed or is disabled, you will see an error message in the tenants menu.
Make sure the enterprise module is installed, and also check that `enabled` is set to `true` in `sg_frontend_multi_tenancy.yml`.



