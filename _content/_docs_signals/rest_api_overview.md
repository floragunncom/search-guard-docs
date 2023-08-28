---
title: REST API Overview
html_title:  REST API
permalink: elasticsearch-alerting-rest-api-overview
category: signals-rest
order: 0
layout: docs
edition: community
description: Overview of the Alerting for Elasticsearch REST API for configuring watches, alerts and accounts.
---

<!--- Copyright 2022 floragunn GmbH -->

# REST API
{: .no_toc}

{% include toc.md %}

Signals can be configured by using the Signals REST API. To use the API, make sure that the user has [sufficient permissions](security_permissions.md). 

For a quick start, you can either use the Search Guard [admin demo user](demo-users-roles#demo-users), or assign the `SGS_SIGNALS_ALL` action group on cluster- and tenant-level to a Search Guard role, e.g.:

```
sg_signals_all:
  cluster_permissions:
    - 'GS_SIGNALS_ALL
  index_permissions:
    - index_patterns:
        - 'signal*'
      allowed_actions:
        - '*'
  tenant_permissions:
    - tenant_patterns:
        - '*'
      allowed_actions:
        - 'SGS_SIGNALS_ALL'
```

This will give this role complete access to all Signals features and indices.

## Watches APIs

* [Get Watch](rest_api_watch_get.md)
* [Search Watch](rest_api_watch_search.md)
* [Put Watch](rest_api_watch_put.md)
* [Delete Watch](rest_api_watch_delete.md)
* [Activate and Deactivate Watch](rest_api_watch_activate.md)
* [Execute Watch](rest_api_watch_execute.md)
* [Acknowledge Watch](rest_api_watch_acknowledge.md)
* [Un-Acknowledge Watch](rest_api_watch_unacknowledge.md)
* [Acknowledge And Get Watch](rest_api_watch_acknowledge_and_get.md)
* [Un-Acknowledge And Get Watch](./rest_api_watch_unacknowledge_and_get.md)
* [Convert Watch](rest_api_convert_es.md)

## Watch State APIs

* [Get Watch State](rest_api_watch_state.md)
* [Search Watch State](rest_api_watch_state_search.md)


## Accounts APIs

* [Get Account](rest_api_watch_get.md)
* [Search Account](rest_api_account_search.md)
* [Put Account](rest_api_account_put.md)
* [Delete Account](rest_api_account_delete.md)

## Settings APIs

* [Get Settings](rest_api_settings_get.md)
* [Put Settings](rest_api_settings_put.md)

## Trust Stores API

* [Get one trust store](./rest_api_trust_store_get_one.md)
* [Get all trust stores](./rest_api_trust_store_get_all.md)
* [Create or replace a trust store](./rest_api_trust_store_create_or_replace.md)
* [Delete truststore](./rest_api_trust_store_delete.md)

