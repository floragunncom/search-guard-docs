---
title: Cache settings
slug: cache-settings
category: configuration
order: 1000
layout: docs
edition: community
description: Configure the Search Guard internal caches and adapt them to your needs.
---
<!---
Copyright 2017 floragunn GmbH
-->
# User cache settings
{: .no_toc}

Search Guard uses a cache to store the roles of authenticated users. The default time to live (TTL) is one hour. This will for example speed up LDAP based authorisation, since the roles are fetched only once per hour.

The TTL of the cache can be adjusted by setting `searchguard.cache.ttl_minutes` `in elasticsearch.yml`:

```
searchguard.cache.ttl_minutes: <integer, ttl in minutes>`
```

Setting the value to `0` will completely disable the cache.

**It is recommended to leave the cache settings untouched for LDAP and Internal User Database. Disabling the cache can severely reduce the performance of these authentication domains.**

The cache can be flushed manually by `sgadmin` in conjunction with the `-rl/--reload` switch, or by using the Kibana Config Gui.

Example:

```
./sgadmin.sh \
   -ks /path/to/keystore.jks \
   -kspass <keystore password> \
   -ts /path/to/truststore.jks \
   -tspass <truststore password>
   -rl
```

