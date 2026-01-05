---
title: FLX release notes
html_title: Search Guard FLX release notes
permalink: sg-flx-release-notes
layout: docs
section: security
edition: community
description: Search Guard FLX release notes
---
<!---
Copyright 2022 floragunn GmbH
-->

# Search Guard FLX release notes
{: .no_toc}

{% include toc.md %}

## Configuration

The Search Guard configuration underwent a major redesign. Many configuration options were moved from `elasticsearch.yml` to configuration files which are dynamically updatable using `sgctl`. Furthermore, a number of legacy configuration options was removed in order to simplify and streamline configuration.

##### Related:

* [Merge Request: New config scheme](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/162)

### Configuration variables

Search Guard offers now a first-class mechanism for defining variables inside configuration. The variables can be updated at runtime using the `sgctl` tool. 

The old environment variable substitution mechanism using the syntaxes `${env...}`, `${envbase64...}` or `${envbc...}` is deprecated and only supported for the legacy configuration file formats. It will be removed in the next major release.

##### Related:

* [Documentation](configuration-password-handling)
* [Merge Request: Infrastructure for storing configuration secrets](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/99)
* [Merge Request: Extended SecretsService into a more general ConfigVarService](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/140)

<a name="sg_license_key"></a>
###  License configuration

There is now a dedicated configuration file for the license key: `sg_license_key.yml`. 

In order to update your license, create `sg_license_key.yml` like this and activate it with `sgctl.sh update-config sg_license_key.yml`.

```
key: 'LS0tLS1CRUdJTiBQR1AgU0lHTkVEIE1FU1NBR0UtLS0tLQpIYXNo...'
```

### Removed support for Search Guard 6 configuration

While earlier versions of Search Guard still worked with Search Guard 6 configuration, Search Guard FLX does not support this configuration any more. If you want to update from a cluster still running with Search Guard 6 configuration, you need to update that configuration to Search Guard 7 configuration first.

##### Related:

* [Upgrading from Search Guard 6 to Search Guard 7](https://docs.search-guard.com/7.x-51/upgrading-6-7)
* [Merge Request: Removed support for Search Guard 6 configuration](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/134)


## Authentication

### New configuration file

The configuration for authentication has been moved from `sg_config.yml` to `sg_authc.yml` to authentication directly at Elasticsearch and `sg_frontend_authc.yml` for authentication at Kibana.

Generally, `sg_authc.yml` offers a redesigned approach to authentication configuration, which offers functionality in a more flexible, streamlined and consistent manner.

When using `sg_authc.yml`, you also get access to new implementations of authentication modules, which often offer more features and greater performance.

In most cases, the conversion from `sg_config.yml` to the new config files can be automatically performed using the [sgctl migrate-config command]().

##### Related:

* [Documentation: sgctl migrate-config](sg-classic-config-migration-quick#migrating-the-configuration)
* [Documentation: Authentication configuration](authentication-authorization-configuration)
* [Documentation: Authentication configuration for Kibana](kibana-authentication-types)
* [Merge Request: New config scheme](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/162)




### LDAP

When using `sg_authc.yml`, you have access to a completely new LDAP authentication backend implementation. New features of the backend include:

* The LDAP backend supports a connection pool for connections to the LDAP server
* Easier configuration
* Greatly enhanced performance for recursive role search; while the old LDAP implementation required at least one network roundtrip per role, the new implementation batches requests; thus, the number of roundtrips is not higher than the depth of the search tree.


##### Related:

* [Documentation: LDAP](active-directory-ldap)
* [Merge Request: New config scheme](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/162)


### JWT

When using `sg_authc.yml`, you have access to a new JWT authentication backend implementation. It includes features found in the old `jwt` and `openid` authenticators.

Keys can be obtained from certificates, from JWKS, or dynamically from OIDC configuration endpoints. If keys are obtained dynamically, these can be automatically refreshed.


##### Related:

* [Documentation: JWT](json-web-tokens)
* [Merge Request: New config scheme](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/162)


### Proxy authentication

The legacy auth modules `proxy` and `proxy2` have been unified into a new `trusted_origin` authentication frontend. The `cert` mode of the old `proxy2` auth module can be now achieved using the `clientcert` authentication frontend.   Like the other new authentication frontends, this new implementations are only available when using `sg_authc.yml`.  

The IPs of trusted origins can be now configured in `sg_authc.yml` in the property `network.trusted_proxies`. You can now use CIDR notation in order to define trusted networks.

##### Related:

* [Documentation: Proxy authentication](proxy-authentication)
* [Documentation: Client certificate authentication](client-certificate-auth)
* [Merge Request: New config scheme](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/162)

### HTTP authentication challenges

In older versions of Search Guard, only one auth domain could send an HTTP authentication challenge. Search Guard FLX now supports sending several authentication challenges at once. Thus, you do no longer have to think about which authentication domain should have an enabled `challenge` flag and which not. If absolutely necessary, you can still disable challenges for HTTP basic, JWT bearer and Kerberos authentication frontends using the `challenge` flags in the respective authentication frontend settings.

##### Related:

* [Merge Request: New config scheme](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/162)


### Debug mode

The Search Guard authentication components now support a debug mode. If you are having issues with the authentication configuration, you can activate debug mode by a switch in `sg_authc.yml`. You will then have access to more detailed information in error messages. Additionally, you get access to a special REST endpoint which also provides the same information for successful logins.

##### Related:

* [Documentation: Debugging the authc configuration](authentication-authorization-configuration#mapping-user-information)


### Metrics

The Search Guard authentication components now collect some performance metrics by default. You can retrieve the metrics using the `sgctl component-state` command. There are three metrics levels, `NONE`, `BASIC` and `DETAILED`, which can be configured using the `metrics` property inside `sg_authc.yml`. The default `BASIC` collects a basic set of metrics without creating a relevant overhead. If you still want to disable metrics, you can set `metrics` to `NONE` inside `sg_authc.yml`. 

##### Related:

* [Merge Request: Metrics](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/200)


### User cache configuration

The purpose of the user cache is to cache the results of authentication backends; thus, it can make authentication fasted because fewer network roundtrips are necessary during authentication. In older Search Guard versions, the expiration time of users cached in the user cache was configured using the setting `searchguard.cache.ttl_minutes` in `elasticsearch.yml`. This setting was moved now to `sg_authc.yml` and looks like this:

```
auth_domains:
  ...
user_cache:
  enabled: true
  expire_after_write: 10m
  max_size: 1000
```

Besides the configuration location, the default values have been changed. If you do not specify any user cache configuration, Search Guard will keep users for 2 minutes in its cache. Additionally, the cache is limited to 1000 entries. Before FLX, Search Guard would keep users cached for 1 our by default. The cache size was unlimited.

You can retrieve metrics for the user cache using `sgctl component-state`.

##### Related:

* [Documentation: User cache settings](authc-advanced-options#user-cache-settings)
* [Merge Request: New config scheme](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/162)

    
### Removed transport client authentication

Search Guard FLX no longer supports authentication with the deprecated transport client. The only exception are transport clients authenticated by admin certificates, which are still supported for Elasticsearch 7.x.

##### Related:

* [Merge Request: Removed transport client authentication](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/222)
    
    
## Authentication for Kibana

### Session-based authentication

Search Guard now uses server-side sessions for managing logins at Kibana. This fixes a number of issues, such as:

- Issues with cookies exceeding the browser size limit.
- The “logout” menu item is able to invalidate the session. Thus, session cookies cannot be re-used any more.
- Configuration of SSO using OIDC or SAML for Kibana no longer interferes with backend authentication configuration. Thus, you can now have challenging basic authentication on the backend while using OIDC or SAML for Kibana.
- The configuration format is now more streamlined and consistent.
- Kibana authentication configuration can be changed without having to restart the node.

The configuration format for authentication in Kibana has been fundamentally changed. You can use the `sgctl migrate-config`  command to migrate the configuration. 

See the documentation for details on the functionality.

##### Related:

* [Documentation: Migrating the configuration](sg-classic-config-migration-quick)
* [Documentation: Kibana authentication](kibana-authentication-types)
* [Merge Request: Support for session based authentication from the Kibana plugin](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/71)
* [Merge Request: Support for session based authentication from the Kibana plugin](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/742)

### Kerberos

When using Kerberos with Kibana, Search Guard will now only authenticate the first request using Kerberos and then create a session. 

If you have configured Kibana with an external monitoring cluster (using the settings `monitoring.ui.elasticsearch.*´), you will need additional configuration on the monitoring cluster. This is necessary because the monitoring cluster will need to use sessions managed by the main cluster in order to authenticate Kibana users. 

See the documentation for details.

**Note:** Using sessions to access external monitoring clusters via Kibana is an Enterprise feature. A license is needed to use this in production.

##### Related:

* [Documentation: Kerberos authentication for Kibana](kibana-authentication-kerberos)
* [Merge Request: Let Kerberos authenticated request also start a session](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/781)
* [Merge Request: New API for creating sessions working on normal authenticated requests ](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/196)
* [Merge Request: Kerberos authentication](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/184)

## Authorization

### More efficient permission resolution

In most cases, privileges can be now evaluated in *constant time*. Earlier versions of Search Guard had linear or even quadratic complexity, depending on number of roles and indices. This is achieved by a number of different techniques:

- The mapping from backend roles to Search Guard roles is performed using trie data structures
- Index and action name patterns are resolved in advance against all indices in the cluster and a list of well-known actions


##### Related:

* [Merge Request: Optimized permission resolution](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/177)
* [Merge Request: Moved to trie-based codova Pattern impl](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/210)
* [Merge Request: Optimized action group resolution](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/147)


### Handling of unauthorized indices

The `do_not_fail_on_forbidden` mode has been replaced by `ignore_unauthorized` mode with refined semantics. This mode is now active by default. 

We **strongly recommend** to follow the new default and keep `ignore_unauthorized` active. Generally, there should be only very few reasons to disable this setting. 

See the documentation links below for the behavior in the different modes.

##### Effects of disabling `ignore_unauthorized` 

If you choose to disable `ignore_unauthorized`, you might need further action in order to make queries with wildcards (like `/_search/_all`) to work. This is necessary because legacy Search Guard
versions created the `searchguard` index, which is non-hidden and thus also matched by wildcards. If you disable `ignore_unauthorized` and still have the `searchguard` index, any wildcard query matching the `searchguard` index will fail with a 403 Forbidden error, because normal users are not allowed to access the `searchguard` index, and - as `ignore_unauthorized`  is disabled - it is no longer ignored. 

We then recommend to migrate the `searchguard` index to a hidden index, i.e., `.searchguard`. Search Guard provides special tooling and a special process to achieve this.

##### Related:

* [Documentation: Runtime index privilege evaluation](authorization-runtime-index-privilege-evaluation)
* [Documentation: Index name migration](search-guard-index-maintenance#index-name-migration)
* [Merge Request: New approach at privilege evaluation for indices with focus on DNFOF mode.](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/146)
* [Merge Request: Replace SearchGuardIndexAccessEvaluator functionality by ignore_unauthorized_indices handling](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/209)
* [Merge Request: Added more action eligible for ignore_unauthorized_indices](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/220)
* [Merge Request: Infrastructure for migration to new .searchguard index name](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/212)
* [Merge Request: sgctl special mode-sg-index](https://git.floragunn.com/search-guard/sgctl/-/merge_requests/33)

### User attributes

The old style user attributes (`attr.ldap....`, `attr.jwt...`, etc) are not supported any more for users logging in via Kibana. You need to use new style user attributes (`user.attrs....`)  instead. See the chapters on [DLS](document-level-security) and [Roles](roles-permissions) for details.


### Using negation for index and action patterns

The syntax of the simple patterns used in `sg_roles.yml` for index and action names has been extended to allow for exclusion of matches. The syntax is very similar to the index pattern syntax used for Elasticsearch search operations. For example, you can now write a role like this:

```yaml
role_with_pattern_negation:
  index_permissions:
  - index_patterns:
    - "*"
    - "-a*"
    allowed_actions:
    - "READ"
```

This will give read privileges to all indices except the indices starting with the letter `a`. 

Negated patterns must come after the patterns that should be restricted by the negated patterns.

**Note:** This feature is different from the `exclude_index_patterns` feature. The attribute `exclude_index_patterns` creates a global rule that denies access to matched indices and actions that cannot be overridden. On the other hand, negated index patterns like `-a*` only have an effect on the non-negated index patterns listed before in the same `index_patterns` list. 


##### Related:


* [Merge Request: Moved to trie-based codova Pattern impl](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/210)


### Assigning privileges to aliases

Due to performance reasons, privileges cannot be assigned to aliases any longer. Privileges must be always assigned to actual indices. 

##### Related:

* [Merge Request: Optimized permission resolution](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/177)

### Seperate config attribute for IPs-based role mapping

Older versions of Search Guard allowed to specify both IPs and host names in the `hosts` attribute of `sg_role_mapping.yml`. This created the issue that a reverse DNS lookup was necessary when this attribute was in use; this again could be controlled by the `hosts_resolver_mode` setting. 

Search Guard FLX introduces a new `ip` attribute in `sg_role_mapping.yml`, which supports CIDR based matching and will never trigger reverse DNS lookups. 


##### Related:

* [Merge Request: New config scheme](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/162)

### General authorization settings

The new configuration file `sg_authz.yml` contains a number of general configuration options for authorization; you can update the settings during cluster runtime using the `sgctl` tool. A number
of these configuration options was found before in `elasticsearch.yml`; thus, any changes to these options required a cluster restart.

- `searchguard.roles_mapping_resolution` was moved  from `elasticsearch.yml` to `sg_authz.yml`. It is now called `role_mapping.resolution_mode`. You need to remove the setting from `elasticsearch.yml` before starting FLX.


##### Related:

* [Merge Request: Cleaned up settings of privileges evaluator](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/215)

### Debug mode for authorization

You can enable a special debug mode for authorization by setting the `sg_authz.yml` flag `debug` to `true`. If you then perform an action and get an `Insufficient permissions` error, the response body will include more information on:

- All privileges that are necessary for the request
- User roles and user attributes
- Any errors that occurred during privilege evaluation
- If applicable, concrete rules or settings that led to the denial

##### Related:

* [Merge Request: Optimized permission resolution](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/177)


### Removed the `multi_rolespan_enabled` setting

We will now always respect all roles when evaluating privileges; this
corresponds to the previous default value. The non-default behaviour was
rather just a legacy item.

##### Related:

* [Merge Request: Removed the `multi_rolespan_enabled` setting](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/148)

### DLS/FLS/Field anonymization

Search Guard FLX comes with a revised implementation for DLS/FLS and field anonymization. The new implementation offers the following advantages:

- Uses a more efficient model for evaluating DLS/FLS/FM permissions. The permissions are now evaluated directly on the shards. Before, the permissions were evaluated up-front and written as a huge blob in a request header.
- The combination of several roles with FLS or FM rules will always create the union of permissions - i.e., the allowed fields never shrink, they can only grow.
- FLS now allows to mix inclusions and exclusions using well-defined semantics. Using rules like `a*`, `~ab*` will allow the access to all attributes starting with `a`, but - as an exception - accessing attributes starting with `ab`will be not possible.
- Source documents subject to FLS and FM are now filtered using a streaming parser, which makes processing significantly faster.
- Most DLS/FLS/FM config attributes which were only available in elasticsearch.yml have been now moved to sg_authz_dlsfls.yml and can be modified during runtime.

**Note:** By default the new implementation is inactive, because it can be only used if all nodes of the cluster have finished the migration to Search Guard FLX. After you have completed the migration, you can activate the new implementation by creating/editing `sg_authz_dlsfls.yml` and setting the attribute `use_impl` to `flx`. 

**Note:** The hashing parameters for the new implementation of field masking have changed. Thus, when switching to the new implementation, the value of hashed fields changes.

##### Related:

* [Documentation: DLS](document-level-security)
* [Documentation: FLS](field-level-security)
* [Documentation: Field anonymization](field-anonymization)
* [Merge Request: New DLS/FLS implementation](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/223)



### Configurable admin-only actions and indices

Search Guard now allows to configure actions and indices which can be **only** used by users authenticated by an admin certificate. 

Search Guard uses these configuration options by itself to restrict the access to the internal `searchguard` and `.searchguard_*` indices, and to restrict access to the low-level configuration REST APIs used by `sgctl`. 

Both options are contained in `elasticsearch.yml`:

**searchguard.admin_only_actions:** Actions that can be only used by users authenticated with an admin certificate. A list of patterns. Default: `cluster:admin:searchguard:config/*`, `cluster:admin:searchguard:internal/*`

**searchguard.admin_only_indices:** Indices that can be only used by users authenticated with an admin certificate. A list of patterns. Default: `searchguard`, `.searchguard_*`, `.signals_watches*`, `.signals_accounts`, `.signals_settings`

**Note:** These are low-level settings which are not necessary for normal use.

##### Related:

* [Merge Request: Replace SearchGuardIndexAccessEvaluator functionality by ignore_unauthorized_indices handling](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/209)

### Filtered alias settings

The warnings logged by Search Guard regarding filtered aliases usually went unnoticed in the logs and were not really helpful for the user. This. Search Guard no longer warns about filtered alias settings.

##### Related:

* [Merge Request: Removed filtered alias handling](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/97)


### Snapshot/restore privilege configuration

The setting `searchguard.enable_snapshot_restore_privilege` has been removed; thus, restore operations are available to users that have the corresponding permission. If you still want to
make sure that only admin users can execute restore operations, you can use the new `searchguard.admin_only_actions` setting and add the action `cluster:admin/snapshot/restore` to it.

##### Related:

* [Merge Request: Cleaned up settings of privileges evaluator](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/215)


### Privileges

#### Templated search privileges

The `indices:data/read/search/template` and `indices:data/read/msearch/template` privileges must be now specified as cluster privileges. The actual search privileges must be defined for `indices:data/read/search`.

##### Related:

* [Merge Request: Optimized permission resolution](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/177)

### Kibana Multi-Tenancy

The Multi-Tenancy configuration from `sg_config.yml` was moved to a separate file called `sg_frontend_multi_tenancy.yml`. However, the defaults are suitable for most cases and thus do not need to be changed. 


##### Related:

* [Merge Request: New config scheme](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/162)


Users with the `SGS_KIBANA_USER` role automatically get write access to the default tenant. If this is not wanted, you need to use privilege exclusion or use the role `SGS_KIBANA_USER_NO_DEFAULT_TENANT` instead of `SGS_KIBANA_USER`.

##### Related:

* [Merge Request: Optimized permission resolution](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/177)


## Miscellaneous

### Auth token service configuration

The configuration for the auth token service was moved from the section `sg_config.dynamic.auth_token_provider` in the file `sg_config.yml` to `sg_auth_token_service.yml`. 

Assuming your `sg_config.yml` contained this:

```yaml
sg_config:
  dynamic:
      auth_token_provider:
        enabled: true
        jwt_signing_key_hs512: "abcdefg"
        max_tokens_per_user: 100   
```

Then, the new file `sg_auth_token_service.yml` looks like this:

```yaml
enabled: true
jwt_signing_key_hs512: "abcdefg"
max_tokens_per_user: 100   
```


Furthermore, you no longer need to configure an explicit authentication domain for auth tokens. Earlier versions of Search Guard required you to add an authentication domain like the following to `sg_config.yml`: 

```yaml
        sg_issued_jwt_auth_domain:
          http_enabled: true
          http_authenticator:
            type: sg_auth_token
            challenge: false
          authentication_backend:
            type: sg_auth_token   
```

This is no longer necessary. If you enable the auth tokens in `sg_auth_token_service.yml`, authentication gets automatically available.
            




##### Related:

* [Merge Request: New config scheme](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/162)


### Metrics

Search Guard now collects metrics for various information in the cluster. The configuration whether metrics are collected occurs in the respective module-specific configuration files such as `sg_authc.yml` and `sg_authz.yml`. See these sections for details.

##### Related:

* [Merge Request: Metrics](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/200)
* [Merge Request: Track non-well-known actions in metrics](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/216)


### OpenSSL configuration options

Support for OpenSSL was removed from Search Guard already quite a while a go. Now, also the configuration options - which were just ignored in the meantime - have been also removed. Thus, if you have any `searchguard` settings in `elasticsearch.yml` mentioning `openssl`, you need to remove these.

##### Related:

* [Merge Request: Removed OpenSSL support code](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/110)

### Removed Kafka audit logging sink

The Kafka audit logging sink was an undocumented experiment. For security reasons, the code has been removed from Search Guard.

##### Related:

* [Merge Request: Removed Kafka audit logging sink](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/178)

### Removed user injection functionality

User injection was a niche feature; no use of it is known any more.

##### Related:

* [Merge Request: Removed user injection functionality](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/163)

### No support for custom authentication modules

Custom authentication modules are no longer supported by Search Guard FLX

### Removed multiple roles and document-level security configuration

The setting `searchguard.dfm_empty_overrides_all` has been deprecated. Search Guard now always behaves like it is set to true.

A user can be member of more than one role, and each role can potentially define a different DLS query for the same index. A standard behaviour is that all DLS queries are collected and combined with `OR`.

Meanwhile if a role does not define DLS query, it grants the user access to all documents. This means that the role overrides and removes any restrictions and overrides all the other roles. The alternative behaviour was rarely needed and used and thus removed from Search Guard FLX.

##### Related:

* [Merge Request: Optimized permission resolution](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/177)
