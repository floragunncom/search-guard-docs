---
title: Security Integration Overview
html_title: Security Overview
slug: elasticsearch-alerting-security-overview
category: security
order: 0
layout: docs
edition: community
description: Signals is integrated with all security related features of Search Guard. This means that access to watches and also the underlying OpenSearch/Elasticsearch indices is governed by Search Guard roles.
---

<!--- Copyright 2020 floragunn GmbH -->

# Security Integration Overview
{: .no_toc}

{% include toc.md %}

Signals is integrated with all security related features of Search Guard. This means that access to watches and also the underlying OpenSearch/Elasticsearch indices is governed by Search Guard roles.


## Signals Indices

The [Signals configuration index](security_indices.md) may store sensitive data and is only accessible by using the Signals API. Direct access is not possible.

Information about the previous execution of watches is written to the `.signals_log_*` index. You should use Search Guard configuration to configure index access rights that match your organisation's requirements.

## API Access

Access to the API to create, update, execute and delete watches and accounts is controlled by a user's Search Guard roles and permissions.

Signals ships with [pre-defined action groups](security_permissions.md) that you can use when defining Signals roles. 

## Security execution context

Each watch is executed in a security context that governs access to the OpenSearch/Elasticsearch indices. A watch is always executed with the set of permissions the user that created or updated the watch has at the time of creation / update.

## Multi tenancy

Signals is multi-tenancy aware. If you are using Search Guard multi tenancy, you can separate access to watches based on a user's available tenants.

If you do not use multi tenancy, all watches are stored in the `SGS_GLOBAL_TENANT` and available for all Signals users that have at least READ permission for watches.

