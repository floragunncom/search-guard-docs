---
title: Field-level security
html_title: Field-level security
permalink: field-level-security
layout: docs
edition: enterprise
description: Include or exclude individual fields from your documents by using the
  Field-level security module of Search Guard.
resources:
- https://search-guard.com/presentations/|Document- and Field-level security (presentation)
- https://search-guard.com/document-field-level-security-search-guard/|Document- and
  field-level security with Search Guard (blog post)
- https://search-guard.com/attribute-based-document-access/|Attribute based document
  access (blog post)
---
<!---
Copyright 2022 floragunn GmbH
-->

# Field-level security
{: .no_toc}

{% include toc.md %}

Field-level security controls which fields a user is able to see. As with document-level security, FLS can be defined per role and per index. 

You can both use field inclusion lists and exclusion lists. As inclusion lists are most robust against accidental exposure of data, this is the recommended approach.

**Note:** Search Guard FLX 1.0 comes with two implementations of DLS/FLS:

- A legacy implementation, which is compatible with nodes which are running still older versions of Search Guard
- A new implementation, which provides better efficiency and functionality. However, this implementation can only be used if you have completely updated your cluster to Search Guard FLX.

As the new implementation is not backwards-compatible, it needs to be manually activated in the configuration. To do so, create or edit `sg_authz_dlsfls.yml` and add:

```yaml
use_impl: flx
```

**Note:** `LogsDB` mode, introduced by Elasticsearch in version 8.15, is not supported with the legacy DLS/FLS implementation.

This documentation describes the *new implementation*.


## Example

The most basic example for a rule using FLS rules looks like this:

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - ...
      fls:
        - 'designation'
        - 'first_name'
        - 'last_name'      
```

Here, the attribute `fls` defines an include list. For users which have only this role, only the fields `designation`, `first_name` and `last_name` are included in the returned documents. All other fields are filtered out.

If you want to use exclusion rules, you need to prefix the field names inside the `fls` attribute with a `~`. This can look like this:

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - ...
      fls:
        - '~salary'
```

## FLS on data streams and aliases

The alias and data stream features are only supported in SG FLX version 3.0 and above
{: .note}

You can also use FLS with data streams and aliases. 

The following is example configuration of data streams with fls:

```yaml
hr_employee:
  luster_permissions:
  - "SGS_CLUSTER_COMPOSITE_OPS"
  data_stream_permissions:
    - data_stream_patterns:
      - "ds_a"
      allowed_actions:
        - "SGS_READ" 
      fls:
        - '~salary'
```

The following is example configuration of alias with fls:

```yaml
dls_test_role_for_all_indices:
  cluster_permissions:
  - "SGS_CLUSTER_COMPOSITE_OPS"
  alias_permissions:
  - alias_patterns:
    - "datastream_alias"
    allowed_actions:
    - "SGS_READ"  
    fls:
      - '~salary'
``` 

## Using wildcards

You can use wildcards when defining FLS field, both for include and exclude mode.

For example:

```yaml
- '*Name'
```

only returns fields that end with `Name`, while on the other hand

```yaml
- '~*Name'
```

would filter our all fields that end with `Name`.

An asterisk matches any character sequence, while a question mark will match any single character.

## Mixing included and excluded fields

As already explained, we strongly recommend to only use field inclusion. However, in some cases, field exclusion or a mix of inclusion or exclusion might be more suitable.

The new FLS implementation of Search Guard FLX uses well-defined semantics for mixing included and excluded fields.

If you consider single roles, any excluded fields are *subtracted* from the included fields. Thus, you can use the following role:

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - logs
      allowed_actions:
        - ...
      fls:
        - 'meta_*'
        - '~meta_uid'
```

This allows to read all fields that start with the string `meta_`. However, as an exception, the field `meta_uid` is not included.

## Multiple roles and field-level security

A user can be member of more than one role, and each role can potentially define different FLS rules for the same index. Search Guard uses well-defined semantics for these cases, which are described in this section.

If Search Guard encounters users which have more than one role with a FLS rules for the same index, Search Guard grants access to the *union* of all fields that are granted by the respective rules.

What this means is illustrated by the following example:

- `role_a` grants only access to the fields `a1`, `a2` and `a3` 
- `role_b` grants only access to the fields `b1`, `b2` and `b3`

A user who is member both of `role_a` and `role_b` gets thus access to the fields `a1`, `a2`, `a3`, `b1`, `b2` and `b3`

If you use exclusion, Search Guard will first determine the actually included fields for each role and then create the union of the *included* fields. Consider the following example:

- `role_no_x` grants access to all fields except `x`
- `role_no_y` grants access to all fields except `y`

Note that `role_no_y` grants access to `x`. Likewise, `role_no_x` grants access to `y`. Thus, a user that is member of both roles is effectively allowed to access all fields, including `x` and `y`.


Keep in mind that roles without explicit FLS rules implicitly grant access to all attributes of a document. Thus, if a user is in such a role, they will always be able to access all fields, even though they might be also member of roles which only grant access to a subset of fields.

For illustration:

- `role_all` does not have an explicit FLS rule and thus grants access to all fields
- `role_b` grants only access to fields `b1`, `b2` and `b3`

A user who is member both of `role_all` and `role_b` gets thus access to all fields. The FLS rule of `role_b` does not have any effect in this case.

## Combining DLS and FLS

If you use both DLS and FLS, all fields that you are basing the DLS query on must be visible, i.e. not filtered by FLS. Otherwise, your DLS query will not work properly. 