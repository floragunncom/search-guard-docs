---
title: Kerberos / SPNEGO
slug: kerberos-spnego
category: authauth
order: 400
layout: docs
edition: enterprise
description: How to configure Kerberos/SPNEGO with Search Guard to implement Single Sign On access to your Elasticsearch cluster.
---
<!---
Copyright 2017 floragunn GmbH
-->

# Kerberos
{: .no_toc}

{% include_relative _includes/toc.md %}

## Static configuration in elasticsearch.yml

Due to the nature of Kerberos, you need to define some (static) settings in `elasticsearch.yml`, and some in `sgconfig.yml`.

In `elasticsearch.yml`, you need to define:

```yaml
searchguard.kerberos.krb5_filepath: '/etc/krb5.conf'
searchguard.kerberos.acceptor_keytab_filepath: 'eskeytab.tab'
```

`searchguard.kerberos.krb5_filepath` defines the path to your Kerberos configuration file. This file contains various settings regarding your Kerberos installation, for example, the realm name(s) and the hostname(s) and port(s) of the Kerberos Key Distribution Center services.

`searchguard.kerberos.acceptor_keytab_filepath` defines the path to the keytab file, containing the principal that Search Guard will use to issue requests against Kerberos/KDC.

`acceptor_principal: 'HTTP/localhost'` defines the principal that Search Guard will use to issue requests against Kerberos/KDC. 

The `acceptor_principal` defines the acceptor/server principal name Search Guard uses to issue requests against Kerberos/KDC. This must be present in the keytab file.

**Due to security restrictions the keytab file must be placed in the `<ES installation directory>/conf` directory or a subdirectory, and the path in `elasticsearch.yml` must be configured relative, not absolute.**

## Dynamic configuration in sgconfig.yml

A typical Kerberos authentication domain in sgconfig.yml looks like this:

```yaml
    authc:
      kerberos_auth_domain:
        enabled: true
        order: 1
        http_authenticator:
          type: kerberos
          challenge: true
          config:
            krb_debug: false
            strip_realm_from_principal: true
        authentication_backend:
          type: noop
```

Authentication against Kerberos via a browser on HTTP level is achieved by using SPNEGO. The Kerberos/SPNEGO implementations vary, depending on your browser/operating system. This is important when deciding if you need to set the `challenge` flag to true or false.

As with [HTTP Basic Authentication](httpbasic.md), this flag determines how Search Guard should react when no `Authorization` header is found in the HTTP request, or if this header does not equal `negotiate`.

If set to true, Search Guard will send a response with status code 401 and a `WWW-Authenticate` header set to `Negotiate`. This will tell the client (browser) to resend the request with the `Authorization` header set. If set to false, Search Guard cannot extract the credentials from the request, and authentication will fail. Setting `challenge` to false thus only makes sense if the Kerberos credentials are sent in the inital request.

As the name implies, setting `krb_debug` to true will output a lot of Kerberos specific debugging messages to stdout. Use this if you encounter any problems with your Kerberos integration.

If you set `strip_realm_from_principal` to true, Search Guard will strip the realm from the user name.

## Authentication backend

Since SPNEGO/Kerberos authenticates a user on HTTP level, no additional `authentication_backend` is needed, hence it can be set to `noop`.

## Troubleshooting

Set `krb_debug: true` in the dynamic configuration. Now any login attempt with a SPNEGO token should print diagnostic information to stdout.

If you do not see any output or use an older Search Guard Kerberos module set the following JVM porperties manually:

* `-Dsun.security.krb5.debug=true`
* `-Djava.security.debug=gssloginconfig,logincontext,configparser,configfile`
* `-Dsun.security.spnego.debug=true`