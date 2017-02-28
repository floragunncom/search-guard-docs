<!---
Copryight 2017 floragunn GmbH
-->

# Kibana Multitenancy

The multitenancy module currently provide two distinct features which could be used independently but which may also 
work together for a complete multitenancy experience. Configuration is done in `sg_config.yml` (not in elasticsearch.yml) and therefore hot reloadable.

## Multitenancy

This feature needs the [Search Guard Kibana Plugin v2 or later](https://github.com/floragunncom/search-guard-kibana-plugin) 
to be installed and tenants to be configured in `sg_roles.yml`.

```
sg_role_xyz:
  indices:
    'abc':
      '*':  
        - READ
        - ...
  tenants:
    mytenant1: RW
    mytenant2: RO
```
Every user which is assigned to `sg_role_xyz` is also permitted for the `mytenant1` (Read/Write) and `mytenant2` (Read-only)

In `sg_config.yml` you can configure:

```
searchguard.dynamic.kibana.multitenancy_enabled: false
```
Enable or disable multitenancy feature (default: enabled)

```
searchguard.dynamic.kibana.server_username: kbsrv
```
Username for the kibanaserver (default: kibanaserver)

```
searchguard.dynamic.kibana.index: '.mykibanaindex'
```
Indexname for the Kibana index (default: .kibana)

## Index rewriting

Shows only content you are allowed to see without throwing errors.

```
searchguard.dynamic.kibana.do_not_fail_on_forbidden: true
```
Enable or disable index rewriting feature (default: disabled)
