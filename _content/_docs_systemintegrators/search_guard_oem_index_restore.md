---
title: Search Guard index restore
html_title: Index restore
permalink: search-guard-oem-index-restore
layout: docs
section: security
edition: community
description: How to enable snapshot and restore of the Search Guard index for regular
  users.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Snapshot and restore access to the Search Guard index

By default, Search Guard does not allow to take a snapshot and restore the Search Guard index. This limitation can be lifted by explicitly allowing access to the Search Guard index in elasticsearch.yml:

```
searchguard.unsupported.restore.sgindex.enabled: true
```

Please also refer to the [snapshot and restore configuration](snapshot-restore) documentation.

