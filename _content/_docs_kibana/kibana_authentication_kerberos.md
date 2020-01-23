---
title: Kerberos authentication
html_title: Kerberos authentication
slug: kibana-authentication-kerberos
category: kibana-authentication
order: 700
layout: docs
edition: enterprise
description: How to use Kerberos to implement Kibana Single Sign On and  to protect your data from any unauthorized access.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Using Kibana with Kerberos
{: .no_toc}

{% include toc.md %}

## Kibana configuration

Once you have set up [Kerberos](../_docs_auth_auth/auth_auth_kerberos.md) for Elasticsearch, configure it as authentication type in kibana.yml like: 

```
searchguard.auth.type: "kerberos"
```

You can use all Search Guard features like multi tenancy and the configuration GUI with Kerberos. 

Due to bugs and limitations in Kibana and X-Pack, not all X-Pack features will work however, please see below.
{: .note .js-note .note-warning}

## Elasticsearch configuration

If you're using HTTP Basic Authentication and the internal user database for the Kibana server user, make sure that only the Kerberos authenticator has set `challenge` to `true`:

```yaml
basic_internal_auth_domain: 
  enabled: true
  order: 0
  http_authenticator:
    type: basic
    challenge: false
  authentication_backend:
    type: intern
kerberos_auth_domain: 
  enabled: true
  order: 1
  http_authenticator:
    type: kerberos
    challenge: true
    config:
    ...
```

## Browser configuration

Depending on the browser you are using, make sure you have configure the Kibana domain correctly for Kerberos authentication. Please refer to the documentation of your browser for further instructions.

## Known Issues/Limitations

## X-Pack Monitoring

Due to a bug regarding handling HTTP error codes 401 and 403 in X-Pack, it is currently not possible to use X-Pack Monitoring with Kerberos. 

## X-Pack Machine Learning

Due to the way HTTP requests are handled by the machine learning module internally, it is currently not possible to use X-Pack Machine Learning with Kerberos. 

## Kibana URL shortener

It's currently not possible to use the Kibana URL shortener together with Kibana/SPNEGO due to technical limitations of the Kibana architecture.

## Kibana Index Management UI

It's currently not possible to use the Kibana Index Management UI together with Kibana/SPNEGO due to technical limitations of the Kibana architecture.

## Disabling the replay cache

Kerberos/SPNEGO has a security mechanism called "Replay Cache". The replay cache makes sure that an Kerberos/SPENGO token can be used only once in a certain timeframe. This conflicts with the Kibana request handling, where one browser request to Kibana can result in multiple requests to Elasticsearch.

These sub-requests will all carry the same Kerberos token and are thus interpreted as replay attack. You will see error messages like:

```
[com.floragunn.dlic.auth.http.kerberos.HTTPSpnegoAuthenticator] Service login not successful due to java.security.PrivilegedActionException: GSSException: Failure unspecified at GSS-API level (Mechanism level: Request is a replay (34)) 
```

At the moment, the only way to make Kerberos work with Kibana is to disable the replay cache. This is of course not optimal, but so far the only known way.

With Oracle JDK, you can set

```
-Dsun.security.krb5.rcache=none
```

in `jvm.options` of Elasticsearch. 
