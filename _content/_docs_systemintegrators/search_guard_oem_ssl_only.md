---
title: SSL only mode
html_title: SSL only mode
permalink: search-guard-oem-ssl-only
layout: docs
edition: community
description: How to enable Search Guard SSL only mode. This adds TLS encryption to
  Elasticsearch, but skips authentication and authorization.
---
<!---
Copyright 2022 floragunn GmbH
-->

# SSL only mode

Search Guard can be operated in "SSL only mode". If this is enabled, Search Guard behaves as if only the SSL functionality was deployed:

* The authentication / authorization modules are not loaded
* The DLS/FLS, Audit Logging and Compliance features are not loaded

Effectively this is identical with only deploying the Search Guard SSL plugin. The TLS only mode can be activated by the following setting in elasticsearch.yml:

```
searchguard.ssl_only: true
```

