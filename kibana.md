<!---
Copryight 2016 floragunn GmbH
-->

# Using Search Guard with Kibana

Search Guard is compatible with [Kibana](https://www.elastic.co/products/kibana). Since Kibana mainly acts as a client (or to be more precise, a proxy) for Elasticsearch, you can use nearly all features of Search Guard with Kibana. 

In the following description, we assume that you have already set up an Search Guard secured Elasticsearch cluster. We'll walk through all additional steps needed for integrating Kibana with your setup.

We also assume that you have enabled TLS support on the REST layer via Search Guard SSL. While this is optional, we strongly recommend using this feature. Otherwise, traffic between Kibana and Elasticsearch is made via unsecure HTTP calls, and thus can be sniffed.

Please check the `elasticsearch.yml` file and see whether TLS on the REST layer is enabled:

```
searchguard.ssl.http.enabled: true
```
## Configuring Kibana

### Installing the Search Guard Plugin

First download the [Search Guard Kibana plugin](https://github.com/floragunncom/search-guard-kibana-plugin/releases) matching your Kibana version from github:

[Search Guard Kibana plugin](https://github.com/floragunncom/search-guard-kibana-plugin/releases)

The installation procedure is the same as for any other Kibana plugin:

* Kibana >= 5:
  * cd into your Kibana installaton directory.
  * Execute: `bin/kibana-plugin install file:///path/to/searchguard-kibana-<version>.zip`. 
* Kibana < 5:
  * cd into your Kibana installaton directory.
  * Execute: `bin/kibana plugin -i searchguard-kibana-alpha -u file:///path/to/searchguard-kibana-<version>.zip`. 

### Configuring the Search Guard Kibana Plugin

The Search Guard Kibana plugin provides session management for Kibana. If not already authenticated, the user is redirected to a login page. The credentials, once validated, are stored in an encrypted cookie on the user's browser. Use the following settings in kibana.yml to configure the plugin:

| Name | Description |
|---|---|
| searchguard.basicauth.enabled | boolean, enable or disable the session management. Defaut: true|
| searchguard.cookie.secure | boolean, if set to true cookies are only stored when using HTTPS. Default: false. |
| searchguard.cookie.name | String, name of the cookie. Default: 'searchguard_authentication' |
| searchguard.cookie.password | String, key used to encrypt the cookie. Must be at least 32 characters long. Default: 'searchguard\_cookie\_default\_password' |
| searchguard.cookie.ttl | Integer, lifetime of the cookie in milliseconds. Can be set to 0 for session cookie. Default: 1 hour |
| searchguard.session.ttl | Integer, lifetime of the session in milliseconds. If set, the user is prompted to log in again after the configured time, regardless of the cookie. Default: 1 hour |
| searchguard.session.keepalive | boolean, if set to true the session lifetime is extended by `searchguard.session.ttl` upon each request. Default: true |

### Configuring the Kibana server user

For management calls to Elasticsearch, such as setting the index pattern, saving and retrieving visualizations and dashboards etc., Kibana uses a special user, called the Kibana server users.

This user needs special privileges for the Kibana index, and is used under the hood by Kibana. When using the sample users and roles that ship with Search Guard, you can use the preconfigured `kibanaserver` user. If you want to set up your own user, please see chapter "Configuring Elasticsearch" below.

The username and password for the Kibana server user can be configured in `kibana.yml` by setting:

```
elasticsearch.username: "kibanaserver"
elasticsearch.password: "kibanaserver"
```

### Setting up SSL/TLS

If you use TLS on the Elasticsearch REST layer, you need to configure Kibana accordingly. This is done in the kibana.yml configuration file. Simply set the protocol on the entry `elasticsearch.url` to `https`:

```
elasticsearch.url: "https://localhost:9200"
```

All requests that Kibana makes to Elasticsearch will now use HTTPS instead of HTTP.

#### Configuring the Root CA

If you use your own root CA on Elasticsearch, you need to either disable certificate validation or provide the root CA and all intermediate certififcates (if any) to Kibana. Otherwise, you'll see the following error message in the Kibana logfile:

```
Request error, retrying -- self signed certificate in certificate chain
```

You can disable certificate validation in `kibana.yml`:

Kibana >= 5.3.0

```
elasticsearch.ssl.verificationMode: none
```

Kibana < 5.3.0:

```
elasticsearch.ssl.verify: false
```

You can also provide the root CA in PEM format by setting:

```
elasticsearch.ssl.ca: "/path/to/your/root-ca.pem"
```

In this case, you can leave the `elasticsearch.ssl.verify` set to `true`.

#### Kibana 5: Configuring the Dev Tools

For Kibana 5, SSL has to be configured separately for the so-called "Dev Tools" (a.k.a Console, a.k.a. Sense). You can follow the setup and installation guide of [Sense](https://www.elastic.co/guide/en/sense/current/installing.html) and replace every occurence of "sense" in configuration keys with "console". For example, to disable the certificate validity check, you can use:

```
console.proxyConfig:
  - match:
      protocol: "https"
    ssl:
      verify: false
```

Instead, you may also pass the Root CA in pem format to establish a chain of trust:

```
console.proxyConfig:
  - match:
      protocol: "https"
    ssl:
      ca: "/path/to/your/root-ca.pem"
```

### Upgrading the Search Guard Kibana Plugin

In order to upgrade the Search Guard Kibana Plugin:

* Stop Kibana
* Delete the Search Guard Kibana plugin from the `plugins` directory 
* Restart Kibana, which will clear all cached files
* Stop Kibana, and install the new version of the plugin


### Customising the login page (5.0.2 and above)

Since v2, you can fully customize the login page to adapt it to your needs. Per default, the login page shows the following elements:

<p align="center">
<img src="images/kibana_customize_login.jpg" style="width: 40%;border: 1px solid"/>
</p>

Use the following setting in kibana.yml to customize one or more elements:

| Name | Description |
|---|---|
| searchguard.basicauth.login.showbrandimage | boolean, show or hide the brand image, Default: true|
| searchguard.basicauth.login.brandimage | String, `src` of the brand image. Should be an absolute URL to your brand image, e.g. `http://mycompany.com/mylogo.jpg`.|
| searchguard.cookie.name | String, name of the cookie. Default: 'searchguard_authentication' |
| searchguard.basicauth.login.title | String, title of the login page. |
| searchguard.basicauth.login.subtitle | String, subtitle of the login page. |
| searchguard.basicauth.login.buttonstyle | String, style attribute of the login button. |

## Configuring Elasticsearch

Tip: For a quickstart, you can use the role definitions that ships with Search Guard. The Kibana server user role is `sg_kibana_server`, the role for regular users is `sg_kibana`. Both are defined in `sg_roles.yml`.

### Adding the Kibana server user

As outlined above, Kibana internally uses a special user to talk to Elasticsearch when performing management calls.

The username and password for this user is configured in kibana.yml. On the Elasticsearch side, make sure that this user has the following permissions:

```
sg_kibana_server:
  cluster:
      - CLUSTER_MONITOR
      - CLUSTER_COMPOSITE_OPS
  indices:
    '?kibana':
      '*':
        - ALL
```

Where the action groups in `sg_action_groups.yml` are defined as follows:

```
ALL:
  - "indices:*"
CLUSTER_MONITOR:
  - cluster:monitor/*
CLUSTER_COMPOSITE_OPS:
  - "indices:data/write/bulk"
  - "indices:admin/aliases*"
  - CLUSTER_COMPOSITE_OPS_RO
```

You can use any type of authentication mechanism for the Kibana server user, given that the credentials can be extracted from the HTTP request as HTTP Basic Authentication headers. In other words, SSO authentication like JWT will not work for the Kibana server user.

#### Example: Internal authentication

If you want to use the internal Search Guard user database as authentication method, add the user kibanaserver to the file `sg_internal_users.yml` and publish the changes via `sgadmin`:

```
kibanaserver:
  hash: $2a$12$4AcgAt3xwOWadA5s5blL6ev39OXDNhmOesEoo33eZtrq2N0YrU3H.
  #password is: kibanaserver
```

And set the authenticator accordingly:

```
searchguard:
  dynamic:
    http:
     ...
    authc:
      kibana_auth_domain:
        enabled: true
        order: 1
        http_authenticator:
          type: basic
          challenge: true
        authentication_backend:
          type: internal
    authz:
      ...
```

### Adding Kibana users

Adding Kibana users is no different from adding any other user to Search Guard. You need to:

* Add the users to your authentication backend (e.g. LDAP, internal Search Guard database).
* Define a role mapping for these users.
* Set the permissions for these roles.

You can use all features of Search Guard to configure the permitted access for these users, such as index and document-type-based permissions, and also document and field-level security.

The following defines the minimum permissions a Kibana user needs:

```
sg_kibana:
  cluster:
    - CLUSTER_COMPOSITE_OPS_RO
  indices:
    'myindex':
      'mytype':
        - READ
        - indices:admin/mappings/fields/get*
    '?kibana':
      '*':
        - ALL
```
Where the action groups are defined as:

```
CLUSTER_COMPOSITE_OPS_RO:
  - "indices:data/read/mget"
  - "indices:data/read/msearch"
  - "indices:data/read/mtv"
  - "indices:data/read/coordinate-msearch*"
  - "indices:admin/aliases/exists*"
  - "indices:admin/aliases/get*"
  -
READ:
  - "indices:data/read*"
ALL:
  - "indices:*"
```

## Using Kibana with JWT

If you're using JWT, first disable the login form by setting:

```
searchguard.basicauth.enabled: false 
```

If you're using the default `Authorization` HTTP header field for your JWT, you don't need to do anything else in Kibana . If you're using a different HTTP header field, make sure to add it the header whitelist in kibana.yml:

```
elasticsearch.requestHeadersWhitelist: [ "authorization", "myjwtheader"]
```

Finally, if you're using HTTP Basic Authentication and the internal user database for the Kibana server user, make sure that the JWT authenticator is first in your authenticator list in `sg_config.yml`:

```
jwt_auth_domain:
  enabled: true
  order: 0
  http_authenticator:
    type: jwt
    ...
basic_internal_auth_domain: 
  enabled: true
  order: 1
  http_authenticator:
    type: basic
    challenge: false
    ...
```

## Using Kibana with Proxy authentication

If you're using proxy authentication, first disable the login form by setting:

```
searchguard.basicauth.enabled: false 
```

Make sure to whitelist all HTTP headers set by your proxy in the header whitelist in kibana.yml:

```
elasticsearch.requestHeadersWhitelist: [ "authorization", "x-forwarded-for", "x-forwarded-by", "x-proxy-user", "x-proxy-roles" ]

```

Finally, if you're using HTTP Basic Authentication and the internal user database for the Kibana server user, make sure that the Proxy authenticator is first in your authenticator list in `sg_config.yml`:

```
proxy_auth_domain:
  enabled: true
  order: 0
  http_authenticator:
    type: proxy
    challenge: false
    config:
      user_header: "x-proxy-user"
      roles_header: "x-proxy-roles"
  authentication_backend:
    type: noop
basic_internal_auth_domain: 
  enabled: true
  order: 1
  http_authenticator:
    type: basic
    challenge: false
    ...
```

## Using Kibana with Kerberos

If you're using Kerberos, first disable the login form by setting:

```
searchguard.basicauth.enabled: false 
```

If you're using HTTP Basic Authentication and the internal user database for the Kibana server user, make sure that only the Kerberos authenticator has set `challenge` to `true`:

```
basic_internal_auth_domain: 
  enabled: true
  order: 0
  http_authenticator:
    type: basic
    challenge: false
  authentication_backend:
    type: intern
kerberos_auth_domain: 
  enabled: true
  order: 1
  http_authenticator:
    type: kerberos
    challenge: true
    config:
    ...
```

### Disabling the replay cache

Kerberos/SPNEGO has a security mechanism called "Replay Cache". The replay cache makes sure that an Kerberos/SPENGO token can be used only once in a certain timeframe.

If a request to Kibana results in multiple subrequests to Elasticsearch under the hood, Kibana will reuse the initial Kerberos/SPNEGO token for all of these subrequests. Depending on your Kerberos setup, this can be interpreted as a replay attack. You will see error messages like:

```
[com.floragunn.dlic.auth.http.kerberos.HTTPSpnegoAuthenticator] Service login not successful due to java.security.PrivilegedActionException: GSSException: Failure unspecified at GSS-API level (Mechanism level: Request is a replay (34)) 
```

At the moment, the only way to make Kerberos work with Kibana is to disable the replay cache. This is of course not optimal, but so far the only known way.

With Oracle JDK, you can set

```
-Dsun.security.krb5.rcache=none
```

in `jvm.options` of Elasticsearch. With this setting, Kerberos works fine out of the box now, however, the security level is lowered a bit of course.
