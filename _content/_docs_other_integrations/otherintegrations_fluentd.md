---
title: Fluentd
html_title: Fluentd
slug: elasticsearch-fluentd-search-guard
category: otherintegrations
order: 500
layout: docs
edition: community
description: How to configure and use fluentd with a Search Guard secured Elasticsearch cluster. Protect your data from any unauthorized access.
---
<!---
Copyright floragunn GmbH
-->

# Using fluentd with Search Guard
{: .no_toc}

{% include toc.md %}

Fluentd connects to Elasticsearch on the REST layer, just like a browser or curl. To use fluentd with a Search Guard secured cluster:

* set up a fluentd user with permissions to read and write to the fluentd index
* configure fluentd to use HTTPS instead of HTTP (optional, only applicable if you enabled HTTPS on the REST layer)
* configure fluentd to provide HTTP Basic Authentication credentials when connecting to Elasticsearch / Search Guard

## Setting up the fluentd user and role

For fluentd being able to write to Elasticsearch, set up a role first that has full access to the fluentd index. Let's assume you use a daily rolling index in fluentd like:

```
index_name fluentd-%Y%m%d
```

You then would set up a Search Guard role that has access to all indices starting with `fluentd-`.

**sg\_roles.yml:**

```
sg_fluentd:
  cluster:
    - CLUSTER_MONITOR  
    - CLUSTER_COMPOSITE_OPS_RO
  indices:
    'fluentd-*':
      '*':
        - UNLIMITED
```

If you use the Search Guard internal user database, set up a fluentd user.

**sg\_internal\_users.yml:**

```
fluentd:
  hash: $2y$12$pcoEhYWjbiMqQldLgK/dnezy9DXzi/wahiADmiYVPvNmzoGWiKoVi
```

Last, map the `fluentd` user to the `sg_fluentd` Search Guard role:


**sg\_roles\_mapping.yml:**

```
sg_fluentd:
  users:
    - fluentd
```
    
## Configuring the Elasticsearch output

In your `td-agent.conf` make sure you provide the username and password of the fluentd user you have configured above.

If you configured Search Guard to use `HTTPS` instead of `HTTP`, make sure you set the `scheme` to `https`.

If you use self-signed certificates, set `ssl_verify` to `none`.

```
<match apache.access>
 @type             elasticsearch
 host              sgssl-0.example.com
 scheme            https
 ssl_verify        false
 user              fluentd
 password          fluentd
 port              9200
 index_name        fluentd-%Y%m%d
 type_name         _doc 
 include_timestamp true
 utc_index         true
 flush_interval 1s
 buffer_chunk_limit 1M
 buffer_queue_limit 512
 <buffer>
   flush_interval 1s
   buffer_chunk_limit 1M
   buffer_queue_limit 512
 </buffer>
</match>
```