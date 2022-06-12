---
title: Basics
html_title: Search Guard document-level security basics
permalink: document-level-security
category: dls
order: 100
layout: docs
edition: enterprise
description: Use Document- and Field-Level Security to implement fine grained access control to documents and fields in your OpenSearch/Elasticsearch cluster.
resources:
  - "search-guard-presentations#dls-fls|Document- and Field-level security (presentation)"
  - https://search-guard.com/document-field-level-security-search-guard/|Document- and field-level security with Search Guard (blog post)
  - https://search-guard.com/attribute-based-document-access/|Attribute based document access (blog post)

---
<!---
Copyright 2020 floragunn GmbH
-->

# Document-level security basics
{: .no_toc}

{% include toc.md %}

Document-level security (DLS) restricts a user's access to certain documents within an index. To enable document-level security you configure an OpenSearch/Elasticsearch query that defines which documents are accessible and which not. Only documents matching this query will be visible for the role that the DLS is defined for.

The query supports the full range of the OpenSearch/Elasticsearch query DSL, and you can also use user attributes to make the query dynamic. This is a powerful feature to implement access permissions to documents based on user attributes stored in Active Directory / LDAP or a JSON web token.

**Note:** Search Guard FLX 1.0 comes with two implementations of DLS/FLS:

- A legacy implementation, which is compatible with nodes which are running still older versions of Search Guard
- A new implementation, which provides better efficiency and functionality. However, this implementation can only be used if you have completely updated your cluster to Search Guard FLX.

As the new implementation is not backwards-compatible, it needs to be manually activated in the configuration. To do so, create or edit `sg_dlsfls.yml` and add:

```yaml
use_impl: flx
```

This documentation describes the *new implementation*.

## Example

Let's imagine we have an index called `humanresources`. This index contains documents with type `employees`, and these documents have a field called `department`. We want to define a query that allows access to all employee documents, except those where the department is set to "Management". 

The respective query to filter these documents in regular query DSL would look like:

```json
{
  "query": {
    "bool": {
      "must_not": { "match": { "department": "Management" }}
    }
  }
}
```

You can use this query to define the DLS in `sg_roles.yml`:

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - ...
      dls: '{ "bool": { "must_not": { "match": { "department": "Management" }}}}'
```

If a user has the role `hr_employee`, Search Guard now filters all documents where the `department` field is set to "Management" from any search result before passing it back to the user.

The format of the query is the same as if it was used in a search request. The specified query expects the same format as if it was defined in the search request and supports ELasticsearch’s full Query DSL.

This means that you can make the DSL query as complex as you want, but since it has to be executed for each query, this, of course, comes with a small performance penalty.

## Multiple roles and document-level security

A user can be member of more than one role, and each role can potentially define a different DLS query and different privileges for the same index. Search Guard uses well-defined semantics for these cases, which are described in this section. Keep these semantics in mind when defining your DLS roles.

If Search Guard encounters users which have more than one role with a DLS query for the same index, all DLS queries are collected and combined with the logical `OR` operator. 

What this means is illustrated by the following example:

- `role_a` grants only access to documents `a1`, `a2` and `a3` 
- `role_b` grants only access to documents `b1`, `b2` and `b3`

A user who is member both of `role_a` and `role_b` gets thus access to `a1`, `a2`, `a3`, `b1`, `b2` and `b3`


Keep in mind that roles without explicit DLS query definitions implicitly grant access to all documents of an index. Thus, if a user is in such a role, they will always be able to access all documents, even though they might be also member of roles which only grant access to a subset of documents.

For illustration:

- `role_all` does not have an explicit DLS query and thus grants access to all documents of an index
- `role_b` grants only access to documents `b1`, `b2` and `b3`

A user who is member both of `role_all` and `role_b` gets thus access to all documents. The DLS query of `role_b` does not have any effect.


## DLS and write-access

DLS only applies for operations that read from an index. It does not apply to index or update operations. Thus, you should take care that you do not grant any write privileges in roles which apply DLS restrictions.  

## Performance considerations

A DLS query can be as simple or complex as necessary, and you can use the full range of OpenSearch/Elasticsearch's query DSL. Regarding the performance overhead, think of the DLS query as an additional query executed on top of your original one. 

## Combining DLS and FLS

If you use both DLS and FLS, all fields that you are basing the DLS query on must be visible, i.e. not filtered by FLS. Otherwise, your DLS query will not work properly. 
