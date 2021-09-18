---
title: Enhanced Proxy Authentication 2
permalink: proxy-authentication-2
category: authauth
order: 810
layout: docs
edition: community
description: Use Search Guard's enhanced Proxy authentication feature to connect OpenSearch/Elasticsearch to any third-party identity provider.
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


## Using Further Headers as Search Guard User Attributes 

Search Guard allows to use further HTTP header values to construct [dynamic index patterns](../_docs_roles_permissions/configuration_roles_permissions.md#dynamic-index-patterns-user-name-substitution) and [dynamic queries for document and field level security](../docs_dls_fls/_dlsfls_dls.md#dynamic-queries-variable-subtitution). In order to use these header values, you need to use the configuration attribute `map_headers_to_user_attrs` to provide a mapping from HTTP header values to Search Guard user attributes inside the authenticator configuration.

As the other proxy authenticator configuration, the `map_headers_to_user_attrs` attribute needs to be placed in the `config` section of the `http_authenticator` configuration. As value, you need to provide a map of the form `search_guard_user_attribute: http_header_name`. 

This might look like this:


```yaml
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
                      map_ldap_attrs_to_user_attrs:
                        department: "x-user-dept"
                        email_address: "x-user-mail"
                authentication_backend:
                    type: "noop"
```

This adds the attributes `department` and `email_address` to the Search Guard user and sets them to the respective values from the HTTP headers. 

In the Search Guard role configuration, the attributes can be then used like this:

```yaml
my_dls_role:
  index_permissions:
  - index_patterns:
    - "dls_test"
    dls: '{"terms" : {"filter_attr": ${user.attrs.department|toList|toJson}}}'
    allowed_actions:
    - "READ"
```


**Note:** Take care that the mapped attributes are of reasonable size. As the attributes need to be internally forwarded over the network for each operation in the OpenSearch/Elasticsearch cluster, attributes carrying a big amount of data may cause a performance penalty.

**Note:** This method of providing attributes supersedes the old way which provided the headers listed in the `attribute_headers`  configuration as Search Guard user attributes with the prefix `attr.proxy2`. These attributes are still supported, but are now deprecated.
