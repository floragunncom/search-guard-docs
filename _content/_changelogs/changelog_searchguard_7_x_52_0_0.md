---
title: Search Guard 7.x-52.0.0
permalink: changelog-searchguard-7x-52_0_0
category: changelogs-searchguard
order: -320
layout: changelogs
description: Changelog for Search Guard 7.x-52.0.0
---

<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Suite 52.0

**Release Date: 2021-07-19**

Search Guard Suite 52.0 is a new major release that primarily adds updates for Document Level Security. Additionally, there are two security bug fixes and one breaking change. Please be sure to thoroughly read the sections on the security bug fixes and breaking changes.

The security bug fixes are also made available as patch releases for older versions of Search Guard.

## Security Bugfixes

### Rule definitions using regular expressions with negation as index patterns

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

Search Guard 52.0 and newer versions with `do_not_fail_on_forbidden: false` fix this issue by explicitly requiring index permissions on `*` if a user tries to do a search operation on `*`.

Details:

* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/80)


### Vulnerability in a component used for OIDC authentication

Search Guard uses Apache CXF for implementing OIDC authentication. Apache CXF versions before 3.3.11 are vulnerable to a denial of service attack due to a bug in JSON parsing. This version of Search Guard updates to an Apache CXF version which fixes this vulnerability.

Details:

* [CVE for Apache CXF](https://nvd.nist.gov/vuln/detail/CVE-2021-30468)

## Breaking Changes

### Handling of write privileges in combination with Document- and Field-Level Security

Earlier versions of Search Guard automatically block index update and bulk update operations on indices protected by document- or field-level security (DLS/FLS).

This was, however, never thorough protection against modification of documents protected by DLS/FLS. It was still possible to overwrite documents protected by document-level security by index or delete operations. Also, Elasticsearch maps update operations under certain circumstances to index operations. These were also never blocked by Search Guard.

Thus, the automatic blocking of index update operations gave a wrong impression of protection.

For this reason, **Search Guard 52.0 and newer versions will not any longer automatically block update operations.**

To enforce that documents protected by DLS/FLS can not be modified please make sure that:

- Roles which define DLS/FLS restriction for indices never grant any write privileges to these indices
- Users who have roles with DLS/FLS restrictions for indices must not have other roles which grant write privileges for the same indices

These rules must be manually checked when creating role definitions.

**Please make sure to review your role definitions accordingly when upgrading to Search Guard 52.**

Details:

* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/84)

## New Features and Improvements

### Support for Term Lookup Queries in Document Level Security

Term Lookup Queries (TLQ) allow you to retrieve values from one document and use these values for a term query on a different index. This can be useful in document-level security where administrators can then have a separate index that defines which users have access to which documents.

Search Guard 52 allows you to use term lookup queries in document-level security queries. For example, you can define a role like this:

```
sg_dls_lookup:
  cluster_permissions:
    - '*'
  index_permissions:
    - index_patterns:
      - "restricted_index"
      allowed_actions:
        - '*'
      dls: |
                 {
                   "terms": {
                     "allow_access_for_codes": {
                       "index": "users",
                       "id": "${user.name}",
                       "path": "codes"
                     }
                   }
                 }
```

This role definition restricts access to documents in `restricted_index`. For each access attempt to `restricted_index` the `users` index is queried in addition. The query looks for a document with an id that is equal to the user name of the currently logged-in user. If a document matches, the values in the`codes` field are extracted. These values are then used as terms for the column `allow_access_for_codes` in `restricted_index`.

**Note:** Supporting this kind of DLS query requires a new method of enforcing DLS. Search Guard supports two ways: The already available mode (internally called `lucene_level`) and the new mode with support for term lookup queries (internally called `filter_level`). Search Guard continues to use the`lucene_level` mode as default, as it provides the best performance and has fewer restrictions. If Search Guard detects access to an index protected by a term lookup DLS query, it will automatically switch to the new `filter_level`.

**Note:** It is **not** necessary to grant additional privileges to the index used inside the term lookup query (in the example, the `users` index). Search Guard will automatically allow access for term lookup queries on such indices. Direct access to these indices is, however, not possible with such role definitions.

**Restrictions:** Users using term lookup queries for DLS should be aware that there are some restrictions on accessing these indexes:

- Only a limited set of read operations is available for term lookup queries. These are: `get`, `search`, `mget`, `msearch`.
- Cross Cluster Search (CCS) with TLQ protected indices on the remote cluster is not completely supported. It works for searches using `minimize_round_trips=true`. However, it does not work for cases where this mode is unavailable, such as scrolling or point-in-time searches.

Details:

* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/75)
* [Documentation for DLS](https://docs.search-guard.com/latest/document-level-security)

### JWT and OIDC: Proper support for subject_path queries which return arrays

In earlier versions of Search Guard, `subject_path` queries that return arrays result in a subject (i.e., user name) in square brackets.
This is usually not the desired result. Instead, the authenticators supporting `subject_path` now do the following if they encounter an array after applying the JSON path:

- Check if the array is of size 1. If so, use the single element as the subject.
- If the array is of any other size, authentication will fail.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/issues/22)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/83)
