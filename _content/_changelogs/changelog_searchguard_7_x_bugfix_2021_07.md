---
title: Search Guard Bugfix Release July 2021
permalink: changelog-searchguard-7.x-bugfix-20217-07
category: changelogs-searchguard
order: -315
layout: changelogs
description: Search Guard Bugfix Release July 2021
---

<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Bugfix Release July 2021

**Release Date: 2021-07-19**

This is a bugfix release for *all* supported Search Guard versions. The release brings a number of security bug fixes and other important, but not security-related bug fixes. 

We provide releases for Search Guard versions 41 to 51 and for Elasticsearch versions 7.6.0 to 7.13.3. If you are already using Search Guard 52, you don't need to install this release.

Please carefully read the release notes. We recommend to install the bugfix release **only** if you are affected by one of the listed issues.

## Available Versions

The bugfix release is available for these versions of Search Guard and Elasticsearch:





|           | SG 51          | SG 50           | SG 49           | SG 48           | SG 47           | SG 46           | SG 45           | SG 43           | SG 42           |  SG 41          |
|-----------|----------------|-----------------|-----------------|-----------------|-----------------|-----------------|-----------------|-----------------|-----------------|-----------------|
| ES 7.13.3 | [7.13.3-51.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.13.3-51.2.0/search-guard-suite-plugin-7.13.3-51.2.0.zip)  | -               | -               | -               | -               | -               | -               | -               | -               | -               |
| ES 7.13.2 | [7.13.2-51.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.13.2-51.2.0/search-guard-suite-plugin-7.13.2-51.2.0.zip)  | -               | -               | -               | -               | -               | -               | -               | -               | -               |
| ES 7.13.1 | [7.13.1-51.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.13.1-51.2.0/search-guard-suite-plugin-7.13.1-51.2.0.zip)  | -               | -               | -               | -               | -               | -               | -               | -               | -               |
| ES 7.13.0 | [7.13.0-51.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.13.0-51.2.0/search-guard-suite-plugin-7.13.0-51.2.0.zip)  | -               | -               | -               | -               | -               | -               | -               | -               | -               |
| ES 7.12.1 | [7.12.1-51.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.12.1-51.2.0/search-guard-suite-plugin-7.12.1-51.2.0.zip)  | [7.12.1-50.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.12.1-50.3.0/search-guard-suite-plugin-7.12.1-50.3.0.zip)   | -               | -               | -               | -               | -               | -               | -               | -               | 
| ES 7.12.0 | [7.12.0-51.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.12.0-51.2.0/search-guard-suite-plugin-7.12.0-51.2.0.zip)  | [7.12.0-50.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.12.0-50.3.0/search-guard-suite-plugin-7.12.0-50.3.0.zip)   | -               | -               | -               | -               | -               | -               | -               | -               | 
| ES 7.11.2 | -              | [7.11.2-50.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.11.2-50.3.0/search-guard-suite-plugin-7.11.2-50.3.0.zip)   | -               | -               | -               | -               | -               | -               | -               | -               | 
| ES 7.11.1 | -              | [7.11.1-50.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.11.1-50.3.0/search-guard-suite-plugin-7.11.1-50.3.0.zip)   | -               | -               | -               | -               | -               | -               | -               | -               | 
| ES 7.10.2 | [7.10.2-51.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.10.2-51.2.0/search-guard-suite-plugin-7.10.2-51.2.0.zip)  | -               | [7.10.2-49.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.10.2-49.3.0/search-guard-suite-plugin-7.10.2-49.3.0.zip)   | [7.10.2-48.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.10.2-48.2.0/search-guard-suite-plugin-7.10.2-48.2.0.zip)   | -               | -               | -               | -               | -               | -               | 
| ES 7.10.1 | -              | -               | [7.10.1-49.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.10.1-49.3.0/search-guard-suite-plugin-7.10.1-49.3.0.zip)   | [7.10.1-48.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.10.1-48.2.0/search-guard-suite-plugin-7.10.1-48.2.0.zip)   | -               | -               | -               | -               | -               | -               | 
| ES 7.10.0 | -              | -               | [7.10.0-49.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.10.0-49.3.0/search-guard-suite-plugin-7.10.0-49.3.0.zip)   | [7.10.0-48.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.10.0-48.2.0/search-guard-suite-plugin-7.10.0-48.2.0.zip)   | -               | -               | -               | -               | -               | -               | 
| ES 7.9.3  | -              | -               | -               | -               | [7.9.3-47.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.3-47.3.0/search-guard-suite-plugin-7.9.3-47.3.0.zip)    | [7.9.3-46.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.3-46.3.0/search-guard-suite-plugin-7.9.3-46.3.0.zip)    | [7.9.3-45.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.3-45.3.0/search-guard-suite-plugin-7.9.3-45.3.0.zip)    | -               | -               | -               | 
| ES 7.9.2  | -              | -               | -               | -               | [7.9.2-47.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.2-47.3.0/search-guard-suite-plugin-7.9.2-47.3.0.zip)    | [7.9.2-46.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.2-46.3.0/search-guard-suite-plugin-7.9.2-46.3.0.zip)    | [7.9.2-45.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.2-45.3.0/search-guard-suite-plugin-7.9.2-45.3.0.zip)    | -               | -               | -               | 
| ES 7.9.1  | -              | -               | -               | -               | [7.9.1-47.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.1-47.3.0/search-guard-suite-plugin-7.9.1-47.3.0.zip)    | [7.9.1-46.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.1-46.3.0/search-guard-suite-plugin-7.9.1-46.3.0.zip)    | [7.9.1-45.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.1-45.3.0/search-guard-suite-plugin-7.9.1-45.3.0.zip)    | -               | -               | -               | 
| ES 7.9.0  | -              | -               | -               | -               | [7.9.0-47.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.0-47.3.0/search-guard-suite-plugin-7.9.0-47.3.0.zip)    | [7.9.0-46.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.0-46.3.0/search-guard-suite-plugin-7.9.0-46.3.0.zip)    | [7.9.0-45.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.9.0-45.3.0/search-guard-suite-plugin-7.9.0-45.3.0.zip)    | -               | -               | -               | 
| ES 7.8.1  | -              | -               | -               | -               | -               | -               | -               | [7.8.1-43.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.8.1-43.2.0/search-guard-suite-plugin-7.8.1-43.2.0.zip)    | -               | -               | 
| ES 7.8.0  | -              | -               | -               | -               | -               | -               | -               | [7.8.0-43.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.8.0-43.2.0/search-guard-suite-plugin-7.8.0-43.2.0.zip)    | -               | -               | 
| ES 7.7.1  | -              | -               | -               | -               | -               | -               | -               | -               | [7.7.1-42.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.7.1-42.3.0/search-guard-suite-plugin-7.7.1-42.3.0.zip)    | -               | 
| ES 7.7.0  | -              | -               | -               | -               | -               | -               | -               | -               | [7.7.0-42.3.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.7.0-42.3.0/search-guard-suite-plugin-7.7.0-42.3.0.zip)    | -               | 
| ES 7.6.2  | -              | -               | -               | -               | -               | -               | -               | -               | -               | [7.6.2-41.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.6.2-41.2.0/search-guard-suite-plugin-7.6.2-41.2.0.zip)    | 
| ES 7.6.1  | -              | -               | -               | -               | -               | -               | -               | -               | -               | [7.6.1-41.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.6.1-41.2.0/search-guard-suite-plugin-7.6.1-41.2.0.zip)    | 
| ES 7.6.0  | -              | -               | -               | -               | -               | -               | -               | -               | -               | [7.6.0-41.2.0](https://maven.search-guard.com/search-guard-suite-release/com/floragunn/search-guard-suite-plugin/7.6.0-41.2.0/search-guard-suite-plugin-7.6.0-41.2.0.zip)    | 

## Security Bugfixes

### Rule definitions using regular expressions with negation as index patterns

*Applies to: all versions*

Search Guard allows using any regular expression supported by the Java Runtime Environment as an index pattern in rule definitions. A rule might look like this:

```
my_role:
  index_permissions:
    - index_patterns:
      - "/index_[0-9]+/"
      allowed_actions:
        - READ
```

The regular expression syntax also supports negation in two variants: negative lookahead and negative character classes. An example with negative lookahead looks like this:

```
my_role_using_negative_lookahead:
  index_permissions:
    - index_patterns:
      - "/(?secret_).*/"
      allowed_actions:
        - READ
```

This pattern is supposed to match all index names that *do not* start with the prefix `secret_`.

However, older versions of Search Guard failed to interpret this definition under a specific set of conditions correctly:

- The option `sg_config.dynamic.do_not_fail_on_forbidden` in `sg_config.yml` is in default state or `false`.
- The role definitions use an index pattern with negation. This can be either negative lookahead (like `/(?!secret_).*/`) or a negated character class (like `[^x-y].*`).
- A user having such a role does a search request on `*` (i.e., all indices on the cluster).

In this case, the user is granted access to all indices, even though the negation should restrict access to certain indexes (i.e., the user should not have access to any index starting with `secret_`).

Search Guard 52.0 and the versions provided in this bugfix release with `do_not_fail_on_forbidden: false` fix this issue by explicitly requiring index permissions on `*` if a user tries to do a search operation on `*`.

Details:

* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/80)


### Vulnerability in a component used for OIDC authentication

*Applies to: all versions*

Search Guard uses Apache CXF for implementing OIDC authentication. Apache CXF versions before 3.3.11 are vulnerable to a denial of service attack due to a bug in JSON parsing. This bugfix release updates to an Apache CXF version which fixes this vulnerability.

Details:

* [CVE for Apache CXF](https://nvd.nist.gov/vuln/detail/CVE-2021-30468)


### Auth Tokens: Revocation does not work for tokens with freeze_privileges: false and full requested privileges

*Applies to: Search Guard 49. Already fixed in later versions.*

Revocation of auth tokens did not work where tokens were created with `freeze_privileges: false` and fully requested privileges (i.e. `cluster_permissions: *` and `index_permissions: */*`. This is a non-standard setup, which can be only achieved by modification of the default confguration in `sg_config.yml`: `exclude_cluster_permissions` in the `auth_token_provider` would need to be `[]` in order to introduce this issue. This is a non-recommended setup.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/16)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/60)

### Search Guard IP blocking does not respect XFF

*Applies to: Search Guard versions 47 and earlier. Already fixed in later versions.*

The feature for blocking IPs did not work correctly when ES is only reachable by a proxy. While Search Guard can use IPs obtained from a X-Forward-For header for IP-based authentication (if xff is configured in sg_config.yml; see the documentation for details), IP blocking did not take such IPs into account.

Details: 

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/19)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/126)


### User blocking not effective for transport requests

*Applies to: Search Guard 43 and earlier. Already fixed in later versions.*

User blocking was not effective for requests originating from transport clients. Fixed.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/23)

## Other Bugfixes

### Support for Composable Templates

*Applies to: Search Guard versions 49 and earlier. Already fixed in later versions.*

The [composable templates feature](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-put-template.html) introduced by Elastichsearch 7.8 was not yet supported by Search Guard. Now, the necessary privileges are included in the action group `SGS_CLUSTER_MANAGE_INDEX_TEMPLATES`. 

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/12)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/108)

### Signals: Runtime data attachment does not work for eMail action

*Applies to: Search Guard versions 49 and earlier. Already fixed in later versions.*

Trying to use e-mail actions with attachments of `type: runtime` caused exceptions. This is now fixed.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/36)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/106)
* [Documentation](https://docs.search-guard.com/latest/elasticsearch-alerting-actions-email)

### Signals Footprint

*Applies to: Search Guard versions 49 and earlier.*

On clusters having many (about > 100) tenants, Signals creates a high amount of threads. 

Administrators who face this problem can now use the `elasticsearch.yml` setting `signals.all_tenants_active_by_default`. The setting is `true` by default. If you edit  `elasticsearch.yml` on all nodes and add `signals.all_tenants_active_by_default: false`, all tenants are disabled by default in Signals. 

In order to have an Signals scheduler for a tenant, you then need to use the [Signals activate tenant API](https://docs.search-guard.com/latest/elasticsearch-alerting-rest-api-tenant-activate) to explicitly activate a tenant.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/42)

### Signals stability

*Applies to: Search Guard versions 46 to 49.*

A number of improvements and bug fixes regarding node fail-over and general stability of Signals watch execution have been implemented:

* [Recovery fails if a watch was executing while the executing node shut down](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/38)
* [When waiting for a yellow index state, don't give up after 1 hour](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/110)
* [Signals state update bugfixes](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/118)

### Using HTTP basic auth and for JWT auth at the same time leads to bogus warnings

*Applies to: Search Guard versions 46 and earlier. Already fixed in later versions.*

Search Guard installations which have both configured basic auth domains and JWT auth domains in `sg_config.yml` would log a bogus warning message
for each user trying to login.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/21)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/75)

### Incomplete scroll permission in CLUSTER_COMPOSITE_OPS

*Applies to: Search Guard versions 45 and earlier. Already fixed in later versions.*

Even though the  SGS_CLUSTER_COMPOSITE_OPS_RO action group provided privileges for scrolling searches, it did not provide privileges for clearing scrolling searches. This could also affect SQL operations and cause error messages about a missing privilege for `indices:data/read/scroll/clear`. Fixed.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/15)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/68)

### Signals: E-Mail accounts using TLS without trusted_hosts fail

*Applies to: Search Guard versions 45 and earlier. Already fixed in later versions.*

E-Mail accounts using TLS could not be configured if the `trusted_hosts` property was not set. Fixed.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/22)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/56)

### Performance problem for Field Caps and many indexes

*Applies to: Search Guard versions 43 and earlier. Already fixed in later versions.*

Using the field caps operation on clusters with many indexes could put an extremly high load on the cluster.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/20)

### Incoming connections with X-Opaque-Id set fail

*Applies to: Search Guard versions 43 and earlier. Already fixed in later versions.*

Incoming requests with an `X-Opaque-Id` header would fail. Fixed.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/14)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/53)


### Signals severity levels: Actual value below all thresholds would fail

*Applies to: Search Guard versions 43 and earlier. Already fixed in later versions.*

Signals watches would fail if severity levels are used and the actual value was determined to be below all defined thresholds.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/18)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/45)
