---
title: Search Guard 7.x-47.0.0
permalink: changelog-searchguard-7x-47_0_0
layout: changelogs
description: Changelog for Search Guard 7.x-47.0.0
---
<!--- Copyright 2020 floragunn GmbH -->

**Release Date: 10.11.2020**

* [Upgrade Guide from 6.x to 7.x](sg-upgrade-6-7)

## New Features



### Enabling Auth Domains only for certain IPs

The Search Guard auth domain configuration now supports the attribute `enabled_only_for_ips`. You can use this option to specify a list of IPv4 or IPv6 addresses or netmasks. If such a list is specified, these auth domains only allow authentication from the specified networks.

This can be for example useful if the only client using basic authentication is Kibana. You can then restrict the basic authentication module to the IPs of Kibana. 

**Example:**

```
        basic_internal_auth_domain: 
          description: "Authenticate via HTTP Basic against internal users database"
          http_enabled: true
          enabled_only_for_ips:
          - '10.10.2.0/24' 
          order: 4
          http_authenticator:
            type: basic
            challenge: true
          authentication_backend:
            type: intern
```


## Improvements



### Allowing Custom Headers

So far, Search Guard would filter all unknown thread context headers. This release adds the option `searchguard.allow_custom_headers` which can be used to specify a list of regular expressions for white-listing custom headers. This option has to be added to `elasticsearch.yml`. 


### Using more than one SAML auth domain

It is now possible to use several SAML authentication domains at once with Search Guard if you are using IdP-initiated SSO (i.e., you are using the login form your your IdP and not the login form of Kibana).

The definition of such a configuration is straight-forward: Just specifiy several auth domains using the SAML authenticator. Search Guard will then use the `saml:Issuer` attribute from the SAML responses to choose the correct auth module for validating the SAML response.


## Bug Fixes



### Authentication / Authorisation

* Using auth domains for HTTP basic auth and for JWT auth at the same time would lead to bogus warning messages in the ES log. Fixed.
<p />


