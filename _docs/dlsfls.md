---
title: Document-level security
html_title: Document-level security
slug: document-level-security
category: dlsfls
order: 100
layout: docs
description: Use Document- and Field-Level Security to implement fine grained access control to documents and fields in your Elasticsearch cluster.
---
<!---
Copryight 2016 floragunn GmbH
-->

# Document-Level security

Document and field-level-security (DLS/FLS) allows for fine grained control to documents and fields.

Document-level security restricts the user's access to a certain set of documents within an index. These "certain documents" are defined by a **standard Elasticsearch query**. Only documents matching this query will be visible for the role that the DLS is defined for.

As with regular permissions, settings for document and field-level security can be applied on an index-level.

**Note: Do not use filtered aliases for security relevant document filtering. Instead, use Document Level Security.**

## Installation

Download the DLS/FLS module from Maven Central:

[Maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-module-dlsfls%22){:target="_blank"} 

and place it in the folder

* `<ES installation directory>/plugins/search-guard-5`

if you are using Search Guard 5.

**Choose the module version matching your Elasticsearch version, and download the jar with dependencies.**

After that, restart all nodes for to activate the module.

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

You can use this exact query to define the DLS in `sg_roles.yml`:

```yaml
hr_employee:
  indices:
    'humanresources':
      'employees':
        - '*'
      _dls_: '{"query": { "bool": { "must_not": { "match": { "department": "Management" }}}}}'
```

If a user has the role `hr_employee`, Search Guard now filters all documents where the `department` field is set to "Management" from any search result before passing it back to the user.

**Note that the `_dls_` key needs to be on the same indentation level as the document types.**

The format of the query is the same as if it was used in a search request. It supports the full query DSL of Elasticsearch.

The specified query expects the same format as if it was defined in the search request and supports ELasticsearch’s full Query DSL.

This means that you can make the DSL query as complex as you want, but since it has to be executed for each query, this, of course, comes with a small performance penalty.

## Username substitution

In addition to the regular query DSL of Elasticsearch, Search Guard also supports username substitution. You can use the variable `${user.name}` in the DLS query, and Search Guard will replace it with the username of the currently logged in user.

Let's imagine that each employee document has a field called `manager`, which contains the username of the employee's manager. Each logged in user should only have access to employees he manages. You can do so by defining:

```yaml
management:
  indices:
    'humanresources':
      'employees':
        - '*'
      _dls_: '{"term" : {"manager" : "${user.name}"}}'
```

Before the DLS query is applied to the result set, `${user.name}` is replaced by the currently logged in user. You can use this variable repeatedly in the DLS query if required.

## Multiple roles and document-level security

A user can be member of more than one role, and each role can potentially define a different DLS query for the same index. In this case, all DLS queries are collected and combined with `OR`.

## Performance considerations

As stated above, a DLS query can be as complex as necessary, and you can use the full range of Elasticsearch's query DSL. Regarding the performance overhead, think of the DLS query as an additional query executed on top of your original one. While technically speaking this statement is not 100% true, you can use it as a rule of thumb: The more complex your DLS query, the higher the performance impact will be.

## DLS/FLS Execution Order

If you use both DLS and FLS, all fields that you are basing the DLS query on must be visible, i.e. not filtered by FLS. Otherwise, your DLS query will not work properly. 