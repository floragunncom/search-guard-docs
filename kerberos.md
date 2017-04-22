<!---
Copryight 2016 floragunn GmbH
-->

# Kerberos

## Installation

Download the Kerberos module from Maven Central: 

[Maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-auth-http-kerberos%22) 
 
and place it in the folder 

* `<ES installation directory>/plugins/search-guard-2` 

or

* `<ES installation directory>/plugins/search-guard-5` 

if you are using Search Guard 5. 

**Choose the module version matching your Elasticsearch version, and download the jar with dependencies.**

After that, restart all nodes to activate the module.

Due to the nature of Kerberos, you need to define some (static) settings in `elasticsearch.yml`, and some in `sgconfig.yml`.

## Static configuration in elasticsearch.yml

In `elasticsearch.yml`, you need to define:

```
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

```
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

More on how to set JVM properties in Elasticsearch [2.x](https://www.elastic.co/guide/en/elasticsearch/reference/2.0/setup-service.html) and [5.x](https://www.elastic.co/guide/en/elasticsearch/reference/5.0/heap-size.html).
