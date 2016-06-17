<!---
Copryight 2016 floragunn UG (haftungsbeschränkt)
-->

# Addendum A: Configuration examples

## Use HTTP basic auth and validate against the internal user database

```
searchguard:
  dynamic:
    authc:
      basic_internal_auth_domain: 
        enabled: true
        order: 1
        http_authenticator:
          type: basic
          challenge: true
        authentication_backend:
          type: intern
```

## Use HTTP basic auth and validate LDAP

```
searchguard:
  dynamic:
    authc:
      ldap:
        enabled: true
        order: 1
        http_authenticator:
          type: basic
          challenge: false
        authentication_backend:
          type: ldap
          config:
            enable_ssl: false
            enable_start_tls: false
            enable_ssl_client_auth: false
            verify_hostnames: true
            hosts:
              - localhost:8389
            bind_dn: null
            password: null
            userbase: 'ou=people,dc=example,dc=com'
            usersearch: '(uid={0})'
```

## Use the clients certificate, no additional authentication backend necessary

```
searchguard:
  dynamic:
    authc:
      clientcert_auth_domain:
        enabled: true
        order: 1
        http_authenticator:
          type: clientcert
          challenge: false
        authentication_backend:
          type: noop
```

## Use the XFF/Proxy authentication, no additional authentication backend necessary

```
searchguard:
  dynamic:
    http:
      anonymous_auth_enabled: false
      xff:
        enabled: true
        internalProxies: '192\.168\.0\.10|192\.168\.0\.11' # regex pattern
        remoteIpHeader:  'x-forwarded-for'
        proxiesHeader:   'x-forwarded-by'    
    authc:
      proxy_auth_domain:
        enabled: true
        order: 1
        http_authenticator:
          type: proxy
          challenge: false
          config:
            user_header: "x-proxy-user"
            roles_header: "x-proxy-roles"
        authentication_backend:
          type: noop
```