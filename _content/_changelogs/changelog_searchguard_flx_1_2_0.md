---
title: Search Guard FLX 1.2.0
permalink: changelog-searchguard-flx-1_2_0
category: changelogs-searchguard
order: -1030
layout: changelogs
description: Changelog for Search Guard FLX 1.2.0
---

<!--- Copyright 2022 floragunn GmbH -->

# Search Guard FLX 1.2.0

**Release Date: 2023-06-09**

This is a new minor release of Search Guard FLX. 

It brings some new features, some bug fixes and updates a number of dependencies.

## New features

### Automatically selected auth methods for Kibana

If you are using more then one auth method for Kibana, you can now mark one of them as the default auth domain using the `auto_select` attribute. Users opening Kibana will be then directed directly to the respective IdP for that auth method. Other auth methods are still available by predefined links.

* [Documentation](../_docs_kibana/kibana_authentication_multi_auth.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/428)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/830)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/383)


### Use negation in index patterns of Search Guard role definitions

You can now define index patterns like this in Search Guard role definitions:

```yaml
example_role:
  index_permissions:
  - index_patterns:
    - "my_indices_*"
    - "-my_indices_secret"
    allowed_actions:
    - "*"
```

This allows you to give permissions to a certain set of indices matched by one pattern except for a subset matched by another pattern. The latter pattern is marked by prefixing a `-` to it.

* [Documentation](../_docs_roles_permissions/configuration_roles_permissions.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/194)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/367)

### Support for Mustache templates for additional Signals features

You can now use Mustache templates to provide dynamic values for HTTP request headers which are used by webhook actions and HTTP inputs.

* [Documentation](../docs_signals/actions_webhook.md)
* [Documentation](../docs_signals/inputs_http.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/84)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/343)


### Signals email action: Use of real names in E-Mail addresses 

The Signals email action allows you now to use real names in E-Mail addresses by using the syntax `Emily Example <emily@example.com>`. 

* [Documentation](../docs_signals/actions_email.md)
* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/158)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/342)

## Improvements

### Signals script compilations are no longer subject to rate limiting

Older versions of Signals could sometimes run into script compliation rate limits imposed by Elasticsearch. This was especially the case on installations with many watches. This rate limit does no longer apply to Signals. 

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/51)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/350)

### Signals Kibana UI: Validation improvements

Validation errors in the Signals Kibana UI have been improved to be better readable and display more useful error messages instead of HTTP status codes.

* [Issue](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/425)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/merge_requests/800)

### Signals: Improved ack API

An additonal REST API for acknowleding actions has been created which returns the updated status as result.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/139)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/311)

## Bug fixes

### Signals Log indices are now marked as hidden

The `.signals_log` indices are now marked as hidden in the index settings. This avoids warnings from Elasticsearch.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/166)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/395)


### Client certificate auth username mapping is now case insensitive

When using the `clientcert` auth domain type, the JSON paths accessing information from the subject DN were accessing it in a case-sensitive fashion. However, RDNs can have varying cases, so a case-insensitive access was necessary.

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/160)
* [Merge Request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/332)

### Misc

* [server.publicBaseUrl in conjunction with OIDC auth did not work](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/162)
* [Logo on login page was broken on Kibana 8](https://git.floragunn.com/search-guard/search-guard-kibana-plugin/-/issues/458)
* [Impersonation with sg_authc without user mapping failed](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/144)

## More

* See the complete changes in the [Gitlab Milestone](https://git.floragunn.com/groups/search-guard/-/milestones/9)
