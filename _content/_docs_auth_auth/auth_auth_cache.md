---
title: Cache settings
permalink: cache-settings
category: sg_authc
order: 1000
layout: docs
edition: community
description: Configure the Search Guard internal caches and adapt them to your needs.
---
<!---
Copyright 2020 floragunn GmbH
-->
# User cache settings
{: .no_toc}

Search Guard uses a cache to store the user information of authenticated users. This way, it avoids having to query authentication backends for each request, which might be costly.

By default, the cache contents expire two minutes after they have been written.

The settings of the cache can be adjusted by using the following configuration properties in `sg_authc.yml` and `sg_authc_transport.yml`:

**user_cache.enabled:** Controls whether a cache shall be used or not. Default: true

**user_cache.expire_after_write:** Specifies that entries shall be removed from the cache a certain time after these were written. Use a duration expression in the format *duration* `h|m|s`. Defaults to `2m`, which means 2 minutes.

**user_cache.expire_after_access:** Specifies that entries shall be removed from the cache if they have not been accessed for a certain time. Use a duration expression in the format *duration* `h|m|s`. By default, there is no access-based expiry.

**user_cache.max_size:** The maximum number of entries in the cache. Defaults to 1000 entries.


The cache can be flushed manually by `sgadmin` in conjunction with the `-rl/--reload` switch, or by using the Search Guard Config GUI.

Example:

```
./sgadmin.sh \
   -ks /path/to/keystore.jks \
   -kspass <keystore password> \
   -ts /path/to/truststore.jks \
   -tspass <truststore password>
   -rl
```

