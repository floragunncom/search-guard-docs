---
title: SSL only mode
html_title: SSL only mode
slug: search-guard-oem-ssl-only
category: oem
order: 100
layout: docs
edition: community
description: How to enable Search Guard SSL only mode.
---
<!---
Copyright 2018 floragunn GmbH
-->

# SSL only mode

Search Guard can be operated in "SSL only mode". If this is enabled, Search Guard behaves as if only the SSL functionality was deployed:

* The authentication / authorization modules are not loaded
* The DLS/FLS, Audit Logging and Compliance features are not loaded

Effectively this is identical with only deploying the Search Guard SSL plugin. The TLS only mode can be activated by the following setting in elasticsearch.yml:

```
searchguard.ssl_only: true
```

