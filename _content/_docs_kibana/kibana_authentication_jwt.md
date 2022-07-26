---
title: JWT URL Parameters
html_title: JWT URL Parameter Authentication with the Search Guard Kibana Plugin
permalink: kibana-authentication-jwt
category: kibana-authentication
order: 700
layout: docs
edition: enterprise
description: How to use JSON web tokens to implement Kibana and Elasticsearch Single Sign on.
resources:
  - "https://search-guard.com/jwt-secure-elasticsearch/|Using JSON web tokens to secure Elasticsearch (blog post)"
  - "https://jwt.io/|jwt.io - useful tools for generating and validating JWT (website)"
---
<!---
Copyright 2020 floragunn GmbH
-->

# Kibana JWT URL Parameter Authentication
{: .no_toc}

{% include toc.md %}

The Search Guard Kibana plugin provides you the possibility to authenticate requests to Kibana using a URL paramter in the Kibana request URL.

This is intended for embedding read-only Kibana instances using IFrames in dashboards or similar applications.

If in your setup, the JWT gets transmitted via an HTTP header, check out the [Kibana proxy authentication](kibana_authentication_proxy.md).
{: .note .js-note .note-warning}

## Search Guard Backend Setup

In order to use proxy authentication with Kibana, you have to also set up an JWT authenticator in the Search Guard backend configuration `sg_authc.yml`.

See the [JWT authenticator documentation](../_docs_auth_auth/auth_auth_jwt.md) for details.

## Kibana Setup

Additionally, you need to edit the file `config/kibana.yml` in your Kibana installation and add the following lines:

```
searchguard.auth.jwt_param.enabled: true
searchguard.auth.jwt_param.url_param: auth
```

This assumes that the URL parameter is called `auth`. If the JWT gets transmitted with a different URL parameter name, please replace the value accordingly.
