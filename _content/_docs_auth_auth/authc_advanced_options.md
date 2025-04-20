---
title: Other advanced options
permalink: authc-advanced-options
layout: docs
edition: community
---
<!---
Copyright 2022 floragunn GmbH
-->
# Advanced options
{: .no_toc}

{% include toc.md %}

## Allowed client IPs

In some cases it might be necessary to only allow certain IP subnets to authenticate at your Elasticsearch cluster. For this purpose, you can define global accept and deny rules for IP addresses in `sg_authc.yml` and `sg_authc_transport.yml`. 

**Note:** By default, all IPs are allowed to connect. However, if you specify any of the `accept` options, all IPs not covered by the `accept` options will be denied.

**network.accept.ips:** Specifies the IPs which are allowed to authenticate using a list of CIDR expressions. The addresses tested here are the IPs of the directly connecting peers. If you have configured `network.trusted_proxies`, you can also use `network.accept.originating_ips` to check the IP addresses of the client where the request actually originated from.

**network.accept.originating_ips:** Specifies the IPs which are allowed to authenticate using a list of CIDR expressions. The addresses tested here are the IPs of the clients where the request actually originated from. This requires that `network.trusted_proxies` is configured.

**network.accept.trusted_ips:** Set this to `true` to accept only direct connections from IPs configured in `network.trusted_proxies`.

**network.deny.ips:** Specifies the IPs which are not allowed to authenticate using a list of CIDR expressions. The addresses tested here are the IPs of the directly connecting peers. The `deny` options are evaluated after the `accept` options; thus, you can use `deny` options only to further restrict the settings done by the `accept` options.

**network.deny.originating_ips:** Specifies the IPs which are not allowed to authenticate using a list of CIDR expressions.  The addresses tested here are the IPs of the clients where the request actually originated from. This requires that `network.trusted_proxies` is configured.




## User cache settings

Search Guard uses a cache to store the user information of authenticated users. This way, it avoids having to query authentication backends for each request, which might be costly.

By default, the cache contents expire two minutes after they have been written.

The settings of the cache can be adjusted by using the following configuration properties in `sg_authc.yml` and `sg_authc_transport.yml`:

**user_cache.enabled:** Controls whether a cache shall be used or not. Default: true

**user_cache.expire_after_write:** Specifies that entries shall be removed from the cache a certain time after these were written. Use a duration expression in the format *duration* `h|m|s`. Defaults to `2m`, which means 2 minutes.

**user_cache.expire_after_access:** Specifies that entries shall be removed from the cache if they have not been accessed for a certain time. Use a duration expression in the format *duration* `h|m|s`. By default, there is no access-based expiry.

**user_cache.max_size:** The maximum number of entries in the cache. Defaults to 1000 entries.


The cache can be [flushed manually with sgctl](sgctl-system-administration)