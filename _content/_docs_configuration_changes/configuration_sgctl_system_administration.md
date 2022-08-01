---
title: System Administration
permalink: sgctl-system-administration
category: sgctl
order: 300
layout: docs
edition: community
description: sgctl offers some handy and powerful tools for administering a Search Guard secured Elasticsearch custer
---

<!---
Copyright 2020 floragunn GmbH
-->

# System administration
{: .no_toc}

{% include toc.md %}

sgctl offers some handy and powerful switches for administering a Search Guard secured Elasticsearch custer.

## Cache invalidation 

Search Guard by default caches authenticated users and their roles and permissions for one hour. You can invalidate the cache by reloading the Search Guard configuration:

```bash
./sgctl.sh rest DELETE /_searchguard/api/cache
```

## Rescue tools

Enable shard allocation and exit. May be useful if you disabled shard allocation while performing a full cluster restart, and you need to recreate the Search Guard index.
```bash
./sgctl.sh rest PUT _cluster/settings --json='{"persistent": { "cluster.routing.allocation.enable": null}}'
```




