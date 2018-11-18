---
title: Search Guard index restore
html_title: Search Guard index restore
slug: search-guard-oem-index-restore
category: oem
order: 300
layout: docs
edition: community
description: How to enable snapshot and restore of the Search Guard index for regular users.
---

<!---
Copyright 2018 floragunn GmbH
-->

## Snapshot and restore access to the Search Guard index

By default, Search Guard does not allow to take a snapshot and restore the Search Guard index. This limitation can be lifted by explicitly allowing access to the Search Guard index in elasticsearch.yml:

```
searchguard.unsupported.restore.sgindex.enabled: true
``` 

Note: This setting must be configured **in addition** to

```
searchguard.enable_snapshot_restore_privilege: true
```

Please also refer to the [snapshot and restore configuration](configuration_snapshots.md) documentation.

