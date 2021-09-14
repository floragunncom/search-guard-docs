---
title: Multitenancy Troubleshooting
html_title: Multitenancy help
slug: troubleshooting-multitenancy
category: troubleshooting
order: 600
layout: troubleshooting
description: Step-by-step instructions on how to troubleshoot Multi Tenancy issues.
---

<!--- Copyright 2020 floragunn GmbH -->

# Troubleshooting Multitenancy

## Headers not whitelisted

During Dashboards/Kibana startup, Search Guard checks whether the `sgtenant` header has been added to the `elasticsearch.requestHeadersWhitelist` condiguration key in `openearch_dashboards.yml`/`kibana.yml`. If this is not the case, the state of the pluin will be red, and you will see an error page when trying to access Dashboards/Kibana. Make sure you have whitelisted this header:

```yaml
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant", ... ]
```

## OpenSearch/Elasticsearch: Multi tenancy not enabled

If the Search Guard multitenancy module is not installed or is disabled, you will see an error message on the "Tenants" page, like:

<p align="center">
<img src="kibana_mt_disabled.png" style="width: 80%" class="md_image"/>
</p>

Make sure the enterprise module is installed, and also check that `searchguard.dynamic.kibana.multitenancy_enabled` is not set to `false` in `sg_config.yml`.

## Dashboards/Kibana and OpenSearch/Elasticsearch: Configuration mismatch

If either the configured Dashboards/Kibana server username or the configured Dashboards/Kibana index name do not match on OpenSearch/Elasticsearch and Dashboards/Kibana, an error will be displayed on the "Tenants" page, like:

<p align="center">
<img src="kibana_config_mismatch.png" style="width: 80%" class="md_image"/>
</p>

Make sure the respective settings match in `sg_config.yml` (OpenSearch/Elasticsearch) and `openearch_dashboards.yml`/`kibana.yml` (Dashboards/Kibana).


