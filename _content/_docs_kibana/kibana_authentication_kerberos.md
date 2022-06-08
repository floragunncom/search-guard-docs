---
title: Kerberos
html_title: Kerberos authentication
permalink: kibana-authentication-kerberos
category: kibana-authentication
order: 400
layout: docs
edition: enterprise
description: How to use Kerberos to implement Dashboards/Kibana Single Sign On and  to protect your data from any unauthorized access.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Dashboards/Kibana Kerberos Authentication
{: .no_toc}

{% include toc.md %}

## Prerequisites

To user Kerberos-based authentication with Dashboards/Kibana, you first need to configure [Kerberos authentication](../_docs_auth_auth/auth_auth_kerberos.md) for the OpenSearch/Elasticsearch backend.

Depending on the browser you are using, make sure you have configured the Dashboards/Kibana domain correctly for Kerberos authentication. Please refer to the documentation of your browser for further instructions.

## Dashboards/Kibana configuration

The remaining configuration for Dashboards/Kibana is rather simple; configure it as authentication type in `kibana.yml`/`opensearch_dashboards.yml` like: 

```
searchguard.auth.type: "kerberos"
```

You can use all Search Guard features like multi tenancy and the configuration GUI with Kerberos. 

Due to bugs and limitations in Dashboards/Kibana and X-Pack, not all X-Pack features will work however, please see below.
{: .note .js-note .note-warning}


## Accessing external monitoring clusters via Kibana

If you want to use both Kerberos authentication for Kibana and want to access an external monitoring cluster with Kibana (using the settings `monitoring.ui.elasticsearch.*´), some further special configuration is needed. This is necessary because the monitoring cluster will need to use sessions managed by the main cluster in order to authenticate Kibana users. 

**Note:** Using sessions to access external monitoring clusters via Kibana/Dashboards is an Enterprise feature. A license is needed to use this in production.

The first part is to configure an explicit session signing hash key for the main cluster. You need to edit `sg_sessions.yml` and add the following lines. If you do not yet have the file `sg_sessions.yml`, you must create it.

```yaml
jwt_signing_key_hs512: "base64url encoded 512 bit value"
jwt_audience: "session_prod1" 
```

The value for `jwt_signing_key_hs512` can be for example generated with the following command:

```
$ openssl rand 64 | basenc --base64url 
```

The setting `jwt_audience` identifies the cluster which created the session JWT. Thus, the monitoring cluster can tell where the JWT originally came from.

The configuration can be updated using

```
$ ./sgctl.sh update-config path/to/sg_sessions.yml 
```

The second part is the configuration on the monitoring cluster. An additional authentication domain of type `jwt/external_session` needs to be added to `sg_authc.yml`. That might look like this:

```yaml
auth_domains:
- ...
- type: jwt/external_session
  jwt.signing.jwks.keys:
  - kty: oct
    kid: kid_a
    k: "the same key as used in sg_sessions.yml on the main cluster "
    alg: HS512
  jwt.required_audience: "session_prod1"
  external_session.hosts:
  - "https://node1.prod_cluster:9200"
  external_session.tls.trusted_cas:
  - "public certificates 1" 
```

The options `jwt.signing.jwks.keys` and `jwt.required_audience` must be adapted to the corresponding settings in `sg_sessions.yml` on the main cluster. If several clusters are using the same monitoring cluster, you can create several entries, one for each cluster.

The option `external_session.hosts` requires the URL of at least one node of the main cluster. You can also specifiy more than one node for load-balancing. 

The option `external_session.tls.trusted_cas` can be used if TLS connections to the main cluster need to use a special PKI. You can directly specify the CA certificate as PEM file here.



## Known Issues/Limitations

### X-Pack Machine Learning

Due to the way HTTP requests are handled by the machine learning module internally, it is currently not possible to use X-Pack Machine Learning with Kerberos. 

### Dashboards/Kibana URL shortener

It's currently not possible to use the Dashboards/Kibana URL shortener together with Dashboards/Kibana/SPNEGO due to technical limitations of the Dashboards/Kibana architecture.

### Dashboards/Kibana Index Management UI

It's currently not possible to use the Dashboards/Kibana Index Management UI together with Dashboards/Kibana/SPNEGO due to technical limitations of the Dashboards/Kibana architecture.

### Disabling the replay cache

Kerberos/SPNEGO has a security mechanism called "Replay Cache". The replay cache makes sure that an Kerberos/SPENGO token can be used only once in a certain timeframe. This conflicts with the Dashboards/Kibana request handling, where one browser request to Dashboards/Kibana can result in multiple requests to OpenSearch/Elasticsearch.

These sub-requests will all carry the same Kerberos token and are thus interpreted as replay attack. You will see error messages like:

```
[com.floragunn.dlic.auth.http.kerberos.HTTPSpnegoAuthenticator] Service login not successful due to java.security.PrivilegedActionException: GSSException: Failure unspecified at GSS-API level (Mechanism level: Request is a replay (34)) 
```

At the moment, the only way to make Kerberos work with Dashboards/Kibana is to disable the replay cache. This is of course not optimal, but so far the only known way.

With Oracle JDK, you can set

```
-Dsun.security.krb5.rcache=none
```

in `jvm.options` of OpenSearch/Elasticsearch. 
