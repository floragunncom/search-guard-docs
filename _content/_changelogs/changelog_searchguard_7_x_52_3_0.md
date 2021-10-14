---
title: Search Guard 7.x-52.3.0
permalink: changelog-searchguard-7x-52_3_0
category: changelogs-searchguard
order: -350
layout: changelogs
description: Changelog for Search Guard 7.x-52.3.0
---

<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Suite 52.3

**Release Date: 2021-09-16**

This is a bug fix release for Search Guard 52. 

## Security Issues

### Unreliable `enable_start_tls` option for `ldap` authcz module

The `enable_start_tls` option of the `ldap` authcz module was unreliable in earlier versions of Search Guard: If the `ldap` authcz module was configured with `enable_start_tls: true`, it would not upgrade the connection to TLS in some cases. If the LDAP server also accepted commands over unencrypted connections, this would have caused user names and passwords to be transmitted over unencrypted connections between an Elasticsearch node running Search Guard and the LDAP server. If the LDAP server refused commands over unencrypted connections, authentication would just fail.

Details:

[Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/116) 
