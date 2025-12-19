---
title: REST API Overview
html_title: REST API
permalink: elasticsearch-alerting-rest-api-overview
layout: docs
section: alerting
edition: community
description: Overview of the Alerting for Elasticsearch REST API for configuring watches,
  alerts and accounts.
---
<!--- Copyright 2022 floragunn GmbH -->

# REST API
{: .no_toc}

{% include toc.md %}

Signals can be configured by using the Signals REST API. To use the API, make sure that the user has [sufficient permissions](elasticsearch-alerting-security-permissions). 

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

* [Get Watch](elasticsearch-alerting-rest-api-watch-get)
* [Search Watch](elasticsearch-alerting-rest-api-watch-search)
* [Put Watch](elasticsearch-alerting-rest-api-watch-put)
* [Delete Watch](elasticsearch-alerting-rest-api-watch-delete)
* [Activate and Deactivate Watch](elasticsearch-alerting-rest-api-watch-activate)
* [Execute Watch](elasticsearch-alerting-rest-api-watch-execute)
* [Acknowledge Watch](elasticsearch-alerting-rest-api-watch-acknowledge)
* [Un-Acknowledge Watch](elasticsearch-alerting-rest-api-watch-unacknowledge)
* [Acknowledge And Get Watch](elasticsearch-alerting-rest-api-watch-acknowledge-and-get)
* [Un-Acknowledge And Get Watch](elasticsearch-alerting-rest-api-watch-un-acknowledge-and-get)
* [Convert Watch](elasticsearch-alerting-rest-api-convert-es)

## Watch State APIs

* [Get Watch State](elasticsearch-alerting-rest-api-watch-state)
* [Search Watch State](elasticsearch-alerting-rest-api-watch-state-search)


## Accounts APIs

* [Get Account](elasticsearch-alerting-rest-api-watch-get)
* [Search Account](elasticsearch-alerting-rest-api-account-search)
* [Put Account](elasticsearch-alerting-rest-api-account-put)
* [Delete Account](elasticsearch-alerting-rest-api-account-delete)

## Settings APIs

* [Get Settings](elasticsearch-alerting-rest-api-settings-get)
* [Put Settings](elasticsearch-alerting-rest-api-settings-put)

## Trust Stores API

* [Get one trust store](elasticsearch-alerting-rest-api-trust-store-get-one)
* [Get all trust stores](elasticsearch-alerting-rest-api-trust-store-get-all)
* [Create or replace a trust store](elasticsearch-alerting-rest-api-trust-store-create-or-replace)
* [Delete truststore](elasticsearch-alerting-rest-api-trust-store-delete)

## Proxies API

* [Get one proxy](elasticsearch-alerting-rest-api-proxy-get-one)
* [Get all proxies](elasticsearch-alerting-rest-api-proxy-get-all)
* [Create or replace a proxy](elasticsearch-alerting-rest-api-proxy-create-or-replace)
* [Delete proxy](elasticsearch-alerting-rest-api-proxy-delete)

