---
title: Advanced Configuration
html_title: Kibana OIDC Advanced Configuration
slug: kibana-authentication-openid-advanced-config
category: kibana-authentication-openid-overview
order: 200
layout: docs
edition: enterprise
description: How to use OpenID Connect and your favorite identity provider to implement Kibana Single Sign-On.

---
<!---
Copyright 2021 floragunn GmbH
-->

# Kibana OpenID Connect Advanced Configuration
{: .no_toc}

{% include toc.md %}


This chapter lists all advanced configuration options for OIDC. Most of them are only needed for special setups.


## Mapping of JWT Claims to User Data

The name of the users and their roles are determined by so called claims stored in the JWTs which are provided by the IdP to Search Guard. You can control the mapping of these claims to user data using the following options:

**user_mapping.subject:** The name of the JWT claim that stores the user's name. If not defined, the [subject](https://tools.ietf.org/html/rfc7519#section-4.1.2) registered claim is used. Most IdP providers use the `preferred_username` claim. Optional. You can also use a JSON path expression here.

**user_mapping.roles:** The name of the JWT claim that stores the user's roles. The value of this claim must be a comma-separated list of roles. You can also use a JSON path expression here. 

**user_mapping.attrs:** You can use this option to map JWT claims to Search Guard user attributes. See [below](#mapping-user-attributes) for details. Optional.

**user_mapping.subject_pattern:**  A regular expression that defines the structure of an expected user name. You can use capturing groups to use only a certain part of the subject supplied by the JWT as the Search Guard user name. If the pattern does not match, login will fail. See [below](#using-only-certain-sections-of-a-jwt-subject-claim-as-user-name) for details. Optional, defaults to no pattern. 

## TLS Settings

If you need special TLS settings to create connections from Search Guard to the IdP, you can configure them with the options listed below. Such configuration might become necessary for example if your IdP uses TLS certificates which are signed by non-public certificate authorities.

**idp.tls.trusted_cas:** The root certificates to trust when connecting to the IdP. You can specify the certificates in PEM format inline or specify an absolute path name using the syntax `${file:/path/to/certificate.pem}`.

**idp.tls.enabled_protocols:** The enabled TLS protocols. Defaults to `["TLSv1.2", "TLSv1.1"]`. 

**idp.tls.enabled_ciphers:** The enabled TLS cipher suites. 

**idp.tls.verify_hostnames:** Whether to verify the hostnames of the IdP’s TLS certificate or not. Default: true.

**idp.tls.trust_all:** Disable all certificate checks. You should only use this for quick tests. *Never use this for production systems.*


### Example

```yaml
default:
  authcz:
  - type: oidc
    client_id: "my-kibana-client"
    client_secret: "client-secret-from-idp"
    idp.openid_configuration_url: "https://your.idp/.../.well-known/openid-configuration"
    idp.tls.trusted_cas: |
      -----BEGIN CERTIFICATE-----
      MIIEZjCCA06gAwIBAgIGAWTBHiXPMA0GCSqGSIb3DQEBCwUAMHgxEzARBgoJkiaJ
      [...]
      1k4enV7iJWXE8009a6Z0Ouwm2Bg68Wj7TAQ=
      -----END CERTIFICATE-----
    user_maping.roles: roles
```

## TLS Client Authentication

If you need to use TLS client authentication to connect from Search Guard to the IdP, you can configure it using the following options:

**idp.tls.client_auth.certificate:** The client certificate. You can specify the certificate in PEM format inline or specify an absolute path name using the syntax `${file:/path/to/certificate.pem}`. You can also specify several certificates to specify a certificate chain.

**idp.tls.client_auth.private_key:** The private key belonging to the client certificate. You can specify the key in PEM format inline or specify an absolute path name using the syntax `${file:/path/to/private-key.pem}`. 

**idp.tls.client_auth.private_key_password:** If the private key is encrypted, you need to specify the key password using this option. 


## Proxy Settings

If the IdP is only reachable from Search Guard via an HTTP proxy, you can use the `idp.proxy` option to define the URI of the proxy. Optional, defaults to no proxy.

### Example

```yaml
default:
  authcz:
  - type: oidc
    client_id: "my-kibana-client"
    client_secret: "client-secret-from-idp"
    idp.openid_configuration_url: "https://your.idp/.../.well-known/openid-configuration"
    idp.proxy: "https://your.outbreaking.proxy:8080"
    user_maping.roles: roles
```

## Mapping user attributes

Search Guard allows to use any attribute available in the JWT claims to construct [dynamic index patterns](../_docs_roles_permissions/configuration_roles_permissions.md#dynamic-index-patterns-user-name-substitution) and [dynamic queries for document and field level security](../_docs_dls_fls/dlsfls_dls.md#dynamic-queries-variable-subtitution). In order to use these attributes, you need to use the configuration option `user_mapping.attrs` to provide a mapping from JWT claim attributes to Search Guard user attributes.

This configuration options accepts a mapping of the form `search_guard_user_attribute: json_path_to_jwt_claim_attribute`. You can use JSON path expressions to specify what part of the claims you want to extract exactly.


This might look like this:

```yaml
default:
  authcz:
  - type: oidc
    client_id: "my-kibana-client"
    client_secret: "client-secret-from-idp"
    idp.openid_configuration_url: "https://your.idp/.../.well-known/openid-configuration"
    idp.proxy: "https://your.outbreaking.proxy:8080"
    user_maping.roles: roles
    user_mapping.attrs: 
      department: department.number
      email_address: user.email
```

This adds the attributes `department` and `email_address` to the Search Guard user and sets them to the respective values from the JWT claims. The types from the JSON claim structure are preserved, i.e., arrays remain arrays and objects remain objects, etc.

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


**Note:** Take care that the mapped attributes are of reasonable size. As the attributes need to be internally forwarded over the network for each operation in the Elasticsearch cluster, attributes carrying a big amount of data may cause a performance penalty.

## Using only certain sections of a JWT subject claim as user name

In some cases, the subject claim in a JWT might be more complex than needed or wanted. For example, a JWT subject claim could be specified as an email address like `exampleuser@example.com`. The `user_mapping.subject_pattern` option gives you the possibility to only use the local part (i.e., `exampleuser`) as the user name inside Search Guard.

With `subject_pattern` you specify a regular expression that defines the structure of an expected user name. You can then use capturing groups (i.e., sections enclosed in round parentheses; `(...)`) to use only a certain part of the subject supplied by the JWT as the Search Guard user name.

For example:

```yaml
default:
  authcz:
  - type: oidc
    client_id: "my-kibana-client"
    client_secret: "client-secret-from-idp"
    user_mapping.subject_pattern: "^(.+)@example\.com$"
    user_maping.roles: roles
```

In this example, `(.+)` is the capturing group, i.e., at least one character. This group must be followed by the string `@example.com`, which must be present, but will not be part of the resulting user name in Search Guard. If you try to login with a subject that does not match this pattern (e.g. `foo@bar`), login will fail.

You can use all the pattern features which the Java `Pattern` class supports. See the [official documentation](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html) for details. 

Keep in mind that all capturing groups are used for constructing the user name. If you need grouping only because you want to apply a pattern quantifier or operator, you should use non-capturing groups: `(?:...)`. 

Example for using capturing groups and non-capturing groups:

```yaml
      user_mapping.subject_pattern: "^(.+)@example\.(?:com|org)$"
```

In this example, the group around `com` and `org` is required to use the alternative operator `|`. But it must be non-capturing, because otherwise it would show up in the user name.

You can however also use several capturing groups if you want to use these groups for the user name:

```yaml
      user_mapping.subject_pattern: "^(.+)@example\.com|(.+)@foo\.bar$"
```

## Logout URL

If you want to customize the URL which Kibana will navigate to when the user selects the "Logout" menu item, use the `logout` option.

```yaml
default:
  authcz:
  - type: oidc
    client_id: "my-kibana-client"
    client_secret: "client-secret-from-idp"
    idp.openid_configuration_url: "https://your.idp/.../.well-known/openid-configuration"
    logout_url: "https://your.idp/logout"
    roles_key: "roles"
```

## Rate-limiting connections to the IdP

In theory it is possible to DOS attack an OpenID based infrastructure by sending tokens with randomly generated, non-existing key ids at a high frequency. In order to mitigate this, Search Guard will only allow a maximum number of new key ids in a certain time frame. If more unknown key ids are receievd, Search Guard will return a HTTP status code 503 (Service not available) and refuse to query the IdP. By defaut, Search Guard does not allow for more than 10 unknown key ids in a time window of 10 seconds. You can control these settings by the following configuration keys:

**refresh_rate_limit_count:**  The maximum number of unknown key ids in the time window. Default: 10

**refresh_rate_limit_time_window_ms:** The time window to use when checking the maximum number of unknown key ids, in milliseconds. Default: 10000