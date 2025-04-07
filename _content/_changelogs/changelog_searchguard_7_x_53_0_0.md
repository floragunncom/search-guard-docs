---
title: Search Guard 7.x-53.0.0
permalink: changelog-searchguard-7x-53_0_0
layout: changelogs
description: Changelog for Search Guard 7.x-53.0.0
---
<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Suite 53.0

**Release Date: 2022-02-22**

Search Guard 53 brings support for Elasticsearch 7.17.0, new functionality for the JWT authenticator and a bugfix for Signals static inputs.

## JWT: Optional check for audience and issuer claims

The JWT authenticator now allows you to specify expected values for audience and/or issuer claims. If one of these values is specified, a JWT will be only accepted if the value matches. 

**Example:**

```
jwt_auth_domain:
  http_enabled: true
  order: 0
  http_authenticator:
    type: jwt
    challenge: false
    config:
      signing_key: "base64 encoded key"
      required_audience: "http://my-es-cluster.example.com"
  authentication_backend:
     type: noop
```

**Details:**

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/56)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/132)

## Signals: Bugfix for static input index mapping issues

By specifying certain values in static inputs, Signals could run into index mapping issues. This release fixes these issues.


**Details:**

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/54)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/165)

