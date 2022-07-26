---
title: Kerberos / SPNEGO
permalink: kerberos-spnego
category: authauth
order: 400
layout: docs
edition: enterprise
description: How to configure Kerberos/SPNEGO with Search Guard to implement Single Sign On access to your Elasticsearch cluster.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Kerberos
{: .no_toc}

{% include toc.md %}

## Prerequisites

To use Kerberos with Search Guard, you need matching `krb5.conf` and keytab files for your Kerberos installation. Due to the nature of Kerberos, you need to define some (static) settings in `elasticsearch.yml`. This means that a cluster restart is necessary to peform the configuration.

## Search Guard setup

### Static configuration

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

### `sg_authc.yml`

A typical Kerberos authentication domain in `sg_authc.yml` looks like this:

```yaml
auth_domains:
- type: kerberos
  kerberos.krb_debug: false
  kerberos.strip_realm_from_principal: true
```

As the name implies, setting `krb_debug` to true will output a lot of Kerberos specific debugging messages to stdout. Use this if you encounter any problems with your Kerberos integration.

If you set `strip_realm_from_principal` to true, Search Guard will strip the realm from the user name.

## Troubleshooting

Set `krb_debug: true` in the dynamic configuration. Now any login attempt with a SPNEGO token should print diagnostic information to stdout.

If you do not see any output or use an older Search Guard Kerberos module set the following JVM porperties manually:

* `-Dsun.security.krb5.debug=true`
* `-Djava.security.debug=gssloginconfig,logincontext,configparser,configfile`
* `-Dsun.security.spnego.debug=true`