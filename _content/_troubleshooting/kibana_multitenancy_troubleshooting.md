---
title: Multitenancy Troubleshooting
html_title: Multitenancy help
permalink: troubleshooting-multitenancy
category: troubleshooting
order: 600
layout: troubleshooting
description: Step-by-step instructions on how to troubleshoot Multi Tenancy issues.
---

<!--- Copyright 2022 floragunn GmbH -->

# Troubleshooting Multitenancy

## Headers not whitelisted

During Kibana startup, Search Guard checks whether the `sgtenant` header has been added to the `elasticsearch.requestHeadersWhitelist` configuration key in `kibana.yml`. If this is not the case, the state of the plugin will be red, and you will see an error page when trying to access Kibana. Make sure you have whitelisted this header:

```yaml
elasticsearch.requestHeadersWhitelist: [ "Authorization", "sgtenant", ... ]
```

## Elasticsearch: Multi tenancy not enabled

If the Search Guard multitenancy module is not installed or is disabled, you will see an error message on the "Tenants" page, like:

<p align="center">
<img src="kibana_mt_disabled.png" style="width: 80%" class="md_image"/>
</p>

Make sure the enterprise module is installed, and also check that `searchguard.dynamic.kibana.multitenancy_enabled` is not set to `false` in `sg_config.yml`.

## Kibana and Elasticsearch: Configuration mismatch

If either the configured Kibana server username or the configured Kibana index name do not match on Elasticsearch and Kibana, an error will be displayed on the "Tenants" page, like:

<p align="center">
<img src="kibana_config_mismatch.png" style="width: 80%" class="md_image"/>
</p>

Make sure the respective settings match in `sg_config.yml` (Elasticsearch) and `kibana.yml` (Kibana).


