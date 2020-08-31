---
title: Enhanced Proxy Authentication 2
slug: proxy-authentication-2
category: authauth
order: 810
layout: docs
edition: community
description: Use Search Guard's enhanced Proxy authentication feature to connect Elasticsearch to any third-party identity provider.
---
<!---
Copyright 2020 floragunn GmbH
-->

## Enhanced HTTP-header/Proxy based authentication

{: .no_toc}
{% include toc.md %}

The enhanced proxy2 authenticator enables you, just like the regular [proxy authenticator](auth_auth_proxy.md) does to use a single sign on (SSO) solution (you might already have) instead of the Search Guard authentication backend. But it also offers some extra features that are not part of the regular [proxy authenticator](auth_auth_proxy.md). The enhanced proxy2 authenticator comes with four different authentication modes that enable you to not only use hostnames as validation but also certificates. This feature is very useful if you have a system where hostnames change. Another extra feature is the option to configure custom user attributes that can carry additional user information.

## Configuration

To enable enhanced proxy2 authenticator with additional features just add the `proxy2` authenticator as a new auth domain to your `sg_config.yml` as shown below and configure `auth_mode` to fit your needs ("ip", "cert", "both" or "either").

```yml
sg_config:
    dynamic:
        authc:
            proxy2_auth_domain:
                http_enabled: true
                transport_enabled: true
                order: 0
                http_authenticator:
                    type: "proxy2"
                    challenge: false
                    config:
                        auth_mode: "both"
                        user_header: "x-proxy-user"
                        roles_header: "x-proxy-roles"
                        roles_separator: ","
                authentication_backend:
                    type: "noop"
```

| Config name | Default value | Description |
|---|---|---|
|`auth_mode`|"both"|Sets the authentication mode|
|`user_header`|"x-proxy-user"|Sets the name of the header containing the username|
|`roles_header`|"x-proxy-roles"|Sets the name of the header containing the user roles|
|`roles_separator`|","|Sets the separator that separates roles in the roles header content|
{: .config-table}

| Possible `auth_mode` values | Description |
|---|---|
|"ip"|Authentication works just like in the regular [proxy authenticator](auth_auth_proxy.md) with a x-forwarded-for header as validation|
|"cert"|Authenticates the request if a valid client certificate is given|
|"both"|Authenticates the request if both a correct x-forwarded-for header and a valid client certificate is given|
|"either"|Authenticates the request if either a correct x-forwarded-for header or a valid client certificate is given|
{: .config-table}

### Using 'ip' mode: Hostname validation

The 'ip' mode compares the remote address with a list of configured internal proxies. If the remote address is not in the list of trusted proxies, it is treated like a client request. Proxy authentication will not work in this case.

If you choose 'ip' mode make sure you enabled x-forwarded-for (`xff`) and configured your `internalProxies` inside the `sg_config.yml` file as shown in the example below.

```yml
sg_config:
    dynamic:
        http:
            xff:
                enabled: true
                internalProxies: '192\.168\.0\.10|192\.168\.0\.11'
                remoteIpHeader:  'x-forwarded-for'
        authc:
            proxy2_auth_domain:
                http_enabled: true
                transport_enabled: true
                order: 0
                http_authenticator:
                    type: "proxy2"
                    challenge: false
                    config:
                        auth_mode: "ip"
                        user_header: "x-proxy-user"
                        roles_header: "x-proxy-roles"
                        roles_separator: ","
                authentication_backend:
                    type: "noop"
```

| xff config name | Default value | Description |
|---|---|---|
|`enabled`|true|Enables or disables x-forwarded-for|
|`internalProxies`||Ip-addresses of all trusted proxies|
|`remoteIpHeader`|"x-forwarded-for"|Name of the header where the chain of hostnames is stored|
{: .config-table}

### Using 'client' mode: Client certificate validation

The 'client' mode is especially useful in systems without static hostnames. It performs a certificate validation instead of a hostname check. Besides a valid certificate the DN has to match a pre-configured DN-whitelist.

```yml
sg_config:
    dynamic:
        authc:
            proxy2_auth_domain:
                http_enabled: true
                transport_enabled: true
                order: 0
                http_authenticator:
                    type: "proxy2"
                    challenge: false
                    config:
                        auth_mode: "cert"
                        user_header: "x-proxy-user"
                        roles_header: "x-proxy-roles"
                        roles_separator: ","
                        allowed_dn_s:
                            - "trusted DN 1"
                            - "trusted DN 2"
                authentication_backend:
                    type: "noop"
```

| Config name | Default value | Description |
|---|---|---|
|`allowed_dn_s`||List of trusted DNs|
{: .config-table}

### Using 'both' mode: Client certificate *and* hostname validation

The 'both' mode basically combines the 'ip' mode and the 'cert' mode. That means that it checks not only the hostnames given by the x-forwarded-for (`xff`) header but also if a valid client certificate is given which DN matches one of the configured DNs.

Just as in the ip-mode you have to activate x-forwarded-for (`xff`) and whitelist your proxy hostnames inside the `sg_config.yml` file. In addition to that you need to configure valid DNs just like in 'cert' mode as shown in the example below.

```yml
sg_config:
    dynamic:
        http:
            xff:
                enabled: true
                internalProxies: '192\.168\.0\.10|192\.168\.0\.11'
                remoteIpHeader:  'x-forwarded-for'
        authc:
            proxy2_auth_domain:
                http_enabled: true
                transport_enabled: true
                order: 0
                http_authenticator:
                    type: "proxy2"
                    challenge: false
                    config:
                        auth_mode: "both"
                        user_header: "x-proxy-user"
                        roles_header: "x-proxy-roles"
                        roles_separator: ","
                        allowed_dn_s:
                            - "trusted DN 1"
                            - "trusted DN 2"
                authentication_backend:
                    type: "noop"
```

| xff config name | Default value | Description |
|---|---|---|
|`enabled`|true|Enables or disables x-forwarded-for|
|`internalProxies`||Ip-addresses of all trusted proxies|
|`remoteIpHeader`|"x-forwarded-for"|Name of the header where the chain of hostnames is stored|
{: .config-table}

| Config name | Default value | Description |
|---|---|---|
|`allowed_dn_s`||List of trusted DNs|
{: .config-table}

### Using 'either' mode: Client certificate *or* hostname validation

The 'either' mode checks if either the certificate or the hostname is valid. 

```yml
sg_config:
    dynamic:
        http:
            xff:
                enabled: true
                internalProxies: '192\.168\.0\.10|192\.168\.0\.11'
                remoteIpHeader:  'x-forwarded-for'
        authc:
            proxy2_auth_domain:
                http_enabled: true
                transport_enabled: true
                order: 0
                http_authenticator:
                    type: "proxy2"
                    challenge: false
                    config:
                        auth_mode: "either"
                        user_header: "x-proxy-user"
                        roles_header: "x-proxy-roles"
                        roles_separator: ","
                        allowed_dn_s:
                            - "trusted DN 1"
                            - "trusted DN 2"
                authentication_backend:
                    type: "noop"
```

| xff config name | Default value | Description |
|---|---|---|
|`enabled`|true|Enables or disables x-forwarded-for|
|`internalProxies`||Ip-addresses of all trusted proxies|
|`remoteIpHeader`|"x-forwarded-for"|Name of the header where the chain of hostnames is stored|
{: .config-table}

| Config name | Default value | Description |
|---|---|---|
|`allowed_dn_s`||List of trusted DNs|
{: .config-table}

## Additional attributes

If you want to pass additional attributes via header you can do that by simply adding your `attribute_headers` in your existing configuration as in the following example.

```yml
sg_config:
    dynamic:
        authc:
            proxy2_auth_domain:
                http_enabled: true
                transport_enabled: true
                order: 0
                http_authenticator:
                    type: "proxy2"
                    challenge: false
                    config:
                        attribute_headers:
                            - "additional-attribute-1"
                            - "additional-attribute-2"
                authentication_backend:
                    type: "noop"
```

| Config name | Default value | Description |
|---|---|---|
|`attribute_headers`||List of additional attribute header names|
{: .config-table}

You can then refer to them `attr_proxy2_additional-attribute-2` like described [here](roles-permissions.md). There is also an attribute `attr_proxy2_username` available containing the username like it was submitted by the proxy.

