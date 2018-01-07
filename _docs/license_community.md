---
title: Community Edition
slug: search-guard-community-edition
category: installation
order: 300
layout: docs
description: The Search Guard Community Edition provides TLS encryption and index-level permissions on REST and transport for free.
---
<!---
Copryight 2017 floragunn GmbH
-->
# Search Guard Community Edition

The Community Edition of Search Guard is free, and you can use it for production and non-production systems. It includes TLS encryption on REST and on transport layer, HTTP Basic Authentication, the Internal User Database authentication backend and Kibana session management.

The Community Edition does not require a license. To use it, simply disable all enterprise features by adding the following line to `elasticsearch.yml` and restart the node:

```yaml
searchguard.enterprise_modules_enabled: false
```

Setting this flag will disable any Enterprise module or custom authentication domain and will run only the Community features of Search Guard.

## Checking your version

### HTTP License endpoint

If you are unsure whether you are running the free Community Edition or not, you can visit the HTTP license endpoint of Search Guard like:

```
https://<Elasticsearch Host>:<HTTP Port>/_searchguard/license
```

For example:

```
https://example.com:9200/_searchguard/license
```

This will return license information in JSON format. If you are running the Community Edition, the following information is displayed:

```JSON
...
sg_license: {
  msgs: [
    "No license required because enterprise modules are not enabled."
  ],
  license_required: false
}
...
```


### Logfile

On startup, Search Guard will print license information to the Elasticsearch logfile on `INFO` level. If you are running the Community Edition you will find the following entry:

```
Search Guard License Info: No license needed because enterprise modules are not enabled
```
