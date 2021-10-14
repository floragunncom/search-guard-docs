---
title: Search Guard 7.x-49.0.0
permalink: changelog-searchguard-7x-49_0_0
category: changelogs-searchguard
order: -200
layout: changelogs
description: Changelog for Search Guard 7.x-49.0.0	
---

<!--- Copyright 2021 floragunn GmbH -->

**Release Date: 02.02.2021**

* [Upgrade Guide from 6.x to 7.x](../_docs_installation/installation_upgrading_6_7.md)

## New Features



### API Auth Token Service

Search Guard 49 brings you the first general available version of the API Auth Token Service. This functionality allows you to create and manage API auth tokens that can be used to access Elasticsearch.

This is especially useful if you have applications which need authenticated access to Elasticsearch. Before the auth token service, you would have to give the application your full credentials, i.e., username and password. Now, you can create an auth token and just use this for authentication; it is also possible to limit the permissions the auth token is granted. Search Guard makes it easy to revoke the auth token at any time.

The auth token service is available in the Search Guard Kibana plugin and via a dedicated [REST API](https://docs.search-guard.com/latest/search-guard-auth-tokens#creating-auth-tokens).

The auth token service is disabled by default. To use it, you need to [enable and configure](https://docs.search-guard.com/latest/search-guard-auth-tokens#configuring-the-search-guard-auth-token-service) it inside `sg_config.yml`.

The service is an enterprise feature. You can try it with the trial license that comes with a new Search Guard installation. If you want to use it for production purposes, you need an enterprise license.

More details:
* [Documentation](https://docs.search-guard.com/latest/search-guard-auth-tokens)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/35)
<p />
 
## Improvements

### Faster Bulk Actions

The privilege evaluation for bulk actions has been optimized. This yields a significant performance improvement for bulk actions; in some of our tests, we could double the throughput.

More information:
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/89)
<p />

### OIDC Authenticator Improvements

This release brings minor improvements to the OIDC auth functionality.

In some environments, ES can connect to IdP servers only via a proxy. For these scenarios, Search Guard introduces the new `proxy` option for `http_authenticators` of type `oidc` inside `sg_config.yml`.

This may look like this:

```
openid_auth_domain:
  http_enabled: true
  order: 0
  http_authenticator:
    type: openid
    challenge: false
    config:
      subject_key: preferred_username
      roles_key: roles
      openid_connect_url: https://keycloak.example.com:8080/auth/realms/master/.well-known/openid-configuration
      proxy: "https://proxy.example.com:9999"
  authentication_backend:
    type: noop
```

Furthermore, with this release, the Kibana server will perform any communication with the IdP also via the Search Guard plugin. Thus, the Kibana configuration options `searchguard.openid.connect_url`,  `searchguard.openid.root_ca` and `searchguard.openid.verify_hostnames` inside  `kibana.yml` are no longer required and can be removed.

More information:
* [Documentation for backend configuration](https://docs.search-guard.com/latest/openid-json-web-keys)
* [Documentation for frontent configuration](https://docs.search-guard.com/latest/kibana-authentication-openid)
* [Merge request for backend](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/39)
* [Merge request for frontend](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/646)
<p />

### Using only a specific sub-string of a JWT, OIDC or SAML user as the Search Guard user

This release introduces the new configuration option `subject_pattern` for the JWT, OIDC and SAML authenticators. You can use this option to configure a regular expression which defines the expected format of the user name obtained from JWT tokens or SAML responses. If the user name does not match the pattern, authentication will fail. You can use capturing groups inside the regular expression to mark only certain parts to be used as the user name inside Search Guard.

For example, this can be used if your IdP provides user names in the format of email addresses. Using a `subject_pattern` with the value `^(.+)@example.com$` will then only use the local part of the email address as user name.

More information:

* [Docs for JWT](https://docs.search-guard.com/latest/json-web-tokens#using-only-certain-sections-of-a-jwt-subject-claim-as-user-name)
* [Docs for OIDC](https://docs.search-guard.com/latest/openid-json-web-keys#using-only-certain-sections-of-a-jwt-subject-claim-as-user-name)
* [Docs for SAML](https://docs.search-guard.com/latest/saml-authentication#using-only-certain-sections-of-a-saml-user-name)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/44)


## Bugfixes

### Blocked IPs and X-Forward-For addresses from proxies

The feature for blocking IPs did not work correctly when ES is only reachable by a proxy. While Search Guard can use IPs obtained from a `X-Forward-For` header for IP-based authentication (if `xff` is configured in `sg_config.yml`; see the [documentation](https://docs.search-guard.com/latest/authentication-authorization#http) for details), IP blocking did not take such IPs into account.

This is now fixed; IPs considered for blocking are now the same IPs which are used for authentication.



