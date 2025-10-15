---
title: Search Guard FLX 4.0.0
permalink: changelog-searchguard-flx-4_0_0
layout: changelogs
description: Changelog for Search Guard FLX 4.0.0
---
<!--- Copyright 2024 floragunn GmbH -->
# Search Guard FLX 4.0.0

**Release Date: TBD**

<span style="color:red">
This version introduces backwards-incompatible changes.</span>

## Breaking Changes
### Removing the Bouncy Castle security provider
This results in a reduced number of supported cryptographic algorithms. Cryptographic algorithms are now provided by the default Java Cryptography Extension (JCE). Before upgrading to Search Guard FLX 4.0.0 or newer, perform tests (e.g., in a test environment) to ensure that all required cryptographic algorithms are still supported. This change may affect:
- TLS connections (e.g., between nodes, between clients and nodes, between Kibana and Elasticsearch, connections with LDAP, Kerberos, HTTP requests sent by Signals, etc.)
- JWT signature verification
- Authentication with OIDC and SAML
- Supported formats of X.509 certificates and other operations on X.509 certificates
- Any other cryptographic operation performed by Search Guard

### Legacy code removal
Support for configuration stored in `sg_config.yml` (the format used before SG FLX 1.0.0) and all related features has been removed. APIs deprecated in SG FLX 1.0.0 and earlier are no longer available, including but not limited to:

- `GET /_searchguard/auth_domain/{authdomain}/openid/{endpoint}`
- `POST /_searchguard/auth_domain/{authdomain}/openid/{endpoint}`
- `POST /_searchguard/api/authtoken`
- `GET /_searchguard/api/sgconfig/`
- `GET /_searchguard/api/sg_config/`
- `PUT /_searchguard/api/sgconfig/{name}`
- `PUT /_searchguard/api/sg_config/`
- `PUT /_searchguard/api/sg_config/{name}`
- `PATCH /_searchguard/api/sgconfig/`
- `PATCH /_searchguard/api/sg_config/`
- etc.

For migration guidance, see [Migrating to FLX](sg-classic-config-migration-overview).

**Before upgrading to Search Guard FLX 4.0.0 or newer, ensure you are not using any of the removed features or APIs.**
### TLS on the REST layer is enabled by default
The new value of configuration parameter `searchguard.ssl.http.enabled` is `true` by default. If you want to disable TLS on the REST layer, set it to `false`. However, we strongly recommend keeping it enabled in production environments.

### Action groups type attribute is mandatory
The `type` attribute in action groups is now mandatory. If it is not specified, then a validation error will be reported. System administrators should upgrade all `yml` files that store action groups so the new required `type` attribute is present before upgrading to Search Guard FLX 4.0.0. A similar validation is employed on the REST API level.

## New Features



## Improvements



## Bug Fixes



## More


