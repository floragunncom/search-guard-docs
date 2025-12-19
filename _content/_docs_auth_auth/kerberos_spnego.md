---
title: Kerberos / SPNEGO
permalink: kerberos-spnego
layout: docs
section: security
edition: enterprise
description: How to configure Kerberos/SPNEGO with Search Guard to implement Single
  Sign On access to your Elasticsearch cluster.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Kerberos
{: .no_toc}

{% include toc.md %}

## Prerequisites

To use Kerberos with Search Guard, you need matching `krb5.conf` and keytab files for your Kerberos installation. 

## Search Guard setup

### `sg_authc.yml`

A typical Kerberos authentication domain in `sg_authc.yml` looks like this:

```yaml
auth_domains:
- type: kerberos
  kerberos.krb5_config_file: "/etc/krb5.conf"
  kerberos.acceptor_keytab: "eskeytab.tab"
  kerberos.acceptor_principal: "HTTP/localhost"
  kerberos.krb_debug: false
  kerberos.strip_realm_from_principal: true
```

The attribute `krb5_config_file` defines the path to your Kerberos configuration file. This file contains various settings regarding your Kerberos installation, for example, the realm name(s) and the hostname(s) and port(s) of the Kerberos Key Distribution Center services. Note: You cannot have multiple Kerberos auth domains with different configuration files. The default value is `/etc/krb5.conf`. 

The attribute `acceptor_keytab`  defines the path to the keytab file, containing the principal that Search Guard will use to issue requests against Kerberos/KDC. Please note that Elasticsearch puts restrictions on the location of this file: It must be placed in `<ES installation directory>/conf` directory or a subdirectory. Furthermore, you must configure a relative path.

The `acceptor_principal` defines the acceptor/server principal name Search Guard uses to issue requests against Kerberos/KDC. This must be present in the keytab file.

As the name implies, setting `krb_debug` to true will output a lot of Kerberos specific debugging messages to stdout. Use this if you encounter any problems with your Kerberos integration.

If you set `strip_realm_from_principal` to true, Search Guard will strip the realm from the user name.

## Troubleshooting

Set `krb_debug: true` in the dynamic configuration. Now any login attempt with a SPNEGO token should print diagnostic information to stdout.

If you do not see any output or use an older Search Guard Kerberos module set the following JVM porperties manually:

* `-Dsun.security.krb5.debug=true`
* `-Djava.security.debug=gssloginconfig,logincontext,configparser,configfile`
* `-Dsun.security.spnego.debug=true`