# User cache settings

Search Guard uses a cache to store the roles of authenticated users. The default time to live (TTL) is one hour. This will for example speed up LDAP based authorisation, since the roles are fetched only once per hour.

The TTL of the cache can be adjusted by setting `searchguard.cache.ttl_minutes` `in elasticsearch.yml`:

```
searchguard.cache.ttl_minutes: <integer, ttl in minutes>`
```

Setting the value to `0` will completely disable the cache.
