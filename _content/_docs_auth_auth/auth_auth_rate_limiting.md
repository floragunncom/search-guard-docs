---
title: Preventing brute force attacks
slug: elasticsearch-brute-force-attacks
category: authauth
order: 1200
layout: docs
edition: community
description: By using the Search Guard login limit feature you can secure your Elasticsearch cluster against brute force attacks.
---

<!--- Copyright 2020 floragunn GmbH -->


# Preventing brute force attacks
{: .no_toc}

{% include toc.md %}

In order to secure your cluster against brute force attacks, Search Guard can limit the number of login attempts by IP or by username. 

After Search Guards detects more than `n` failed login attempts withing a specific timeframe on a node, no more login attempts are possible for the client IP or the username.

## Limit login attempts by IP

To limit the number of allowed login attempts by client IP, configure rate limiting in `sg_config.yml`like:

```
sg_config:
  dynamic:
    http:
      ...
    authc:
      ...
    authz:
      ...
    auth_failure_listeners:
      ip_rate_limiting:
        type: ip
        allowed_tries: 10
        time_window_seconds: 3600
        block_expiry_seconds: 600
        max_blocked_clients: 100000
        max_tracked_clients: 100000
```

These setting limit failed authentication requests by client IP. The limiting is independed of the used authentication backend.  

| Name | Description |
|---|---|
| type | ip, limit failed authentication requests by client IP |
| allowed\_tries | After the number of `allowed tries` within the time window specified by `time_window_seconds`, the client IP will be blocked for the time specified by `block_expiry_seconds`. Note that increasing this number increases heap usage. |
| time\_window\_seconds | The time window to consider for `allowed_tries`. |
| block\_expiry\_second | Blocks will be released again after this time.  |
| max\_blocked\_clients | Maximum number of blocked clients. Limits heap usage to avoid DOS.  |
| max\_tracked\_clients| Maximum number of tracked clients with login failures. Limits heap usage to avoid DOS.  |
{: .config-table}

## Limit login attempts by username and authentication backend

To limit login attempts by username and authentication backend, configure rate limiting in `sg_config.yml`like:

```
internal_authentication_backend_limiting:
  type: username
  authentication_backend: internal        
  allowed_tries: 10
  time_window_seconds: 3600
  block_expiry_seconds: 600
  max_blocked_clients: 100000
  max_tracked_clients: 100000
```

These setting limit failed authentication requests by username and authentication backend.

| Name | Description |
|---|---|
| type | username, limit failed authentication requests by username and authentication backends |
| authentication_backend | the authentication backend to apply limiting to. |
| allowed\_tries | After the number of `allowed tries` within the time window specified by `time_window_seconds`, the client IP will be blocked for the time specified by `block_expiry_seconds`. Note that increasing this number increases heap usage. |
| time\_window\_seconds | The time window to consider for `allowed_tries`. |
| block\_expiry\_second | Blocks will be released again after this time.  |
| max\_blocked\_clients | Maximum number of blocked clients. Limits heap usage to avoid DOS.  |
| max\_tracked\_clients| Maximum number of tracked clients with login failures. Limits heap usage to avoid DOS.  |
{: .config-table}

### Supporte authentication backends

| Backend | Description |
|---|---|
| internal | The internal user database |
| ldap | LDAP /  Active Directoy |
{: .config-table}

## Limitations

Failed login attempts are tracked on each node separately and are not synchronized across the cluster.