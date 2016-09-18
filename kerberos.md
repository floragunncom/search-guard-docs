# Kerberos

Due to the nature of Kerberos, you need to define some (static) settings in `elasticsearch.yml`, and some in `sgconfig.yml`.

## Static configuration in elasticsearch.yml

In `elasticsearch.yml`, you need to define:

```
searchguard.kerberos.krb5_filepath: '/etc/krb5.conf'
searchguard.kerberos.acceptor_keytab_filepath: 'eskeytab.tab'
```

`searchguard.kerberos.krb5_filepath` defines the path to your Kerberos configuration file. This file contains various settings regarding your Kerberos installation, for example the realm name(s) and the hostname(s) and port(s) of the Kerberos Key Distribution Center services.

`searchguard.kerberos.acceptor_keytab_filepath` defines the path to the keytab file, containing the principal which Search Guard will use to issue requests against Kerberos.

If you do not know where to get these from, refer to the administrator of your Kerberos infrastructure.

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
            acceptor_principal: 'HTTP/localhost'
            strip_realm_from_principal: true
        authentication_backend:
          type: noop
```

Authentication against Kerberos via a browser on HTTP level is achieved by using SPNEGO. The Kerberos/SPNEGO implementations vary, depending on your browser/operating system. This is important when deciding if you need to set the `challenge` flag to true or false.

As with [HTTP Basic Authentication](httpbasic.md), this flag determines how Search Guard should behave when no `Authorization` header is found in the HTTP request, or if this header does not equal `negotiate`.

If set to true, Search Guard will send a response with status code 401 and a `WWW-Authenticate` header set to `Negotiate`. This will tell the client (browser) to resend the request with the `Authorization` header set. If set to false, Search Guard cannot extract the credentials from the request, and authentication will fail. Setting `challenging` to false thus only makes sense if the Kerberos credentials are sent in the inital request. 

As the name implies, setting `krb_debug` to true will output a lot of Kerberos specific debugging messages will be outputted to standard out. Use this if you encounter any problems with your Kerberos integration.

The `acceptor_principal` defines the acceptor/server principal name Search Guard uses. This must be present in the keytab file configured in `elasticsearch.yml`.

If you set `strip_realm_from_principal` to true, Search Guard will strip the realm from the user name.

## Authentication backend

Since SPNEGO/Kerberos authenticates a user on HTTP level, no additional `authentication_backend` is needed, hence it can be set to `noop`.