---
title: Quick Start
html_title: HTTP Proxy Quick Start
permalink: proxy-authentication
layout: docs
section: security
edition: community
description: Use Search Guard's Proxy authentication feature to connect Elasticsearch
  to any third-party identity provider.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Proxy based authentication
{: .no_toc}

{% include toc.md %}

The proxy based authentication enables you to use a single sign on (SSO) solution - which you might already have - instead of the Search Guard authentication backend. 

Most of these solutions work as a proxy in front of Elasticsearch. Usually the request is routed to the SSO proxy first. The SSO proxy authenticates the user. If authentication succeeds, the (verified) username and its (verified) roles are set in HTTP header fields. The names of these fields are dependent on the SSO solution you have in place.

Several components of the Search Guard REST authentication feature can be composed to integrate with such a solution:

- The `trusted_origin` authentication frontend together with the `network.trusted_proxies` configuration makes sure that the requests come from the SSO proxy.
- Alternatively, if the proxy is capable of client certificate authentication, you can also use the `clientcert` authentication frontend. See [Client certificate authentication](client-certificate-auth) for more on this.
- The user information, i.e., user name, roles and attributes, can be extracted using the standard `user_mapping` functionality of Search Guard. By default, Search Guard makes the headers of the source request available to `user_mapping` below the attribute `request.headers`. 

## Prerequisites

For configuring proxy based authentication, you need to know the IP addresses of the proxy which connect to Elasticsearch. Additionally, you need to know 
the names and the format of the additional HTTP headers the proxy injects into the REST requests.

## Search Guard setup

If you identify the trusted proxies by IP address, a `sg_authc.yml` can look similar to this:

```yaml
auth_domains:
- type: trusted_origin
  user_mapping.user_name.from: request.headers.proxy_user
  user_mapping.roles.from_comma_separated_string: request.headers.proxy_roles
  
network:
  trusted_proxies: '10.10.123.0/24' 
```

The authentication frontend `trusted_origin` checks whether the IP address of the connecting host is contained in the `trusted_proxies` network specified in the `network`settings. Authentication succeeds only if this is the case.

**Important:** Make sure that you configure the `trusted_proxies` attribute correctly. If you include untrusted IP addresses, access by unauthorized clients might be possible.

Finally, the `user_mapping` configuration reads user name and roles from the configured HTTP request headers.

**Note:** Keep in mind that the user mapping is specified using JSON paths. If the header names contain special characters, you might need to use the alternative attribute notation: `$.request.headers["x-proxy-user"]`. 


## Where to go next

* Check the  [advanced configuration options for proxy authentication](proxy-authentication-advanced)
