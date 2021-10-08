---
title: Field-level security
html_title: Field-level security
slug: field-level-security
category: dlsfls
order: 100
layout: docs
edition: enterprise
description: Include or exclude individual fields from your documents by using the Field-level security module of Search Guard.
resources:
  - "search-guard-presentations#dls-fls|Document- and Field-level security (presentation)"
  - https://search-guard.com/document-field-level-security-search-guard/|Document- and field-level security with Search Guard (blog post)
  - https://search-guard.com/attribute-based-document-access/|Attribute based document access (blog post)

---
<!---
Copyright 2016 floragunn GmbH
-->

# Field-level security
{: .no_toc}

{% include_relative _includes/toc.md %}

Field-level security controls which fields a user is able to see. As with document-level security, FLS can be defined per role and per index. Search Guard supports including (whitelisting) and excluding (blacklisting) fields from documents.

In order to restrict access to certain fields, you simply list the fields to be excluded or included on the same indentation level as the document types.

## Including fields

In this mode, only fields listed in the FLS section of the role definition are returned by Search Guard. In the example below, only the fields `Designation`, `FirstName` and `LastName` are included in the returned documents. All other fields are filtered out:

```yaml
hr_employee:
  ...
  indices:
    'humanresources':
      'employees':
      ...
      _dls_: ...
      _fls_:
        - 'Designation'
        - 'FirstName'
        - 'LastName'
     ...
```

## Excluding fields

If you rather want to exclude than include fields, simply prefix all fields with a `~`. In the example below, all fields except `Designation`, `FirstName` and `LastName` are returned by Search Guard:

```yaml
hr_employee:
  ...
  indices:
    'humanresources':
      'employees':
      ...
      _dls_: ...
      _fls_:
        - '~Designation'
        - '~FirstName'
        - '~LastName'
     ...
```

## Using wildcards

You can use wildcards when definig FLS field, both for include and exclude mode.

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

Using wildcards with FLS security will have an effect on the overall performance, especially if you are dealing with documents that contain a huge number of fields. If possible, they should be avoided. See also chapter "Performance considerations" below.

## Mixing included and excluded fields

Mixing included and excluded fields per role and index does not make sense and leads to undefined results.

Please make sure that the FLS definition(s) of an authenticated user is either include only, or exclude only!

## Multiple roles and field-level security

As with document-level security, if a user is member of multiple roles it is important to understand how the FLS settings for these roles are combined.

In case of FLS, the FLS field definitions of the roles are combined with `AND`. If you use FLS `include` (whitelisting) and `exclude` (blacklisting) definitions for different roles, you need to make sure that for each user and its roles the combination of the FLS field is either include only, or exclude only.

## DLS/FLS Execution Order

If you use both DLS and FLS, all fields that you are basing the DLS query on must be visible, i.e. not filtered by FLS. Otherwise, your DLS query will not work properly. 