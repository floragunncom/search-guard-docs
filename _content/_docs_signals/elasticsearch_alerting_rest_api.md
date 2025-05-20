---
title: REST API
html_title: REST API
permalink: elasticsearch-alerting-rest-api
layout: docs
edition: community
canonical: elasticsearch-alerting-rest-api-overview
description: Overview of the Elasticsearch Alerting REST API
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

## Watch State APIs

* [Get Watch State](elasticsearch-alerting-rest-api-watch-state)
* [Search Watch State](elasticsearch-alerting-rest-api-watch-state-search)


## Accounts APIs

* [Get Account](elasticsearch-alerting-rest-api-account-get)
* [Search Account](elasticsearch-alerting-rest-api-account-search)
* [Put Account](elasticsearch-alerting-rest-api-account-put)
* [Delete Account](elasticsearch-alerting-rest-api-account-delete)

## Settings APIs

* [Get Settings](elasticsearch-alerting-rest-api-settings-get)
* [Put Settings](elasticsearch-alerting-rest-api-settings-put)

## Administration APIs

* [Activate and Deactivate Execution for Tenant](elasticsearch-alerting-rest-api-tenant-activate)
* [Activate and Deactivate Execution Globally](elasticsearch-alerting-rest-api-admin-activate)

## Other APIs

* [Convert Watch](elasticsearch-alerting-rest-api-convert-es)