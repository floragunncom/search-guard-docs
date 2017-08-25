<!---
Copryight 2016 floragunn GmbH
-->

# Document and field-level security

Document and field-level-security (DLS/FLS) allows for fine grained control to documents and fields.

As the name implies, document-level security restricts access to certain documents within an index. Field level security restricts access to certain fields within a document.

As with regular permissions, settings for document and field-level security can be applied on an index-level, meaning that you can have different settings for each index.

**Note: Do not use filtered aliases for security relevant document filtering. Instead, use Document Level Security.**

## Installation

Download the DLS/FLS module from Maven Central:

[Maven central](http://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22com.floragunn%22%20AND%20a%3A%22dlic-search-guard-module-dlsfls%22) 

and place it in the folder

* `<ES installation directory>/plugins/search-guard-5`

if you are using Search Guard 5.

**Choose the module version matching your Elasticsearch version, and download the jar with dependencies.**

After that, restart all nodes for to activate the module.

## Document-level security

Document-level security restricts the user's access to a certain set of documents within an index. These "certain documents" are defined by a **standard Elasticsearch query**. Only documents matching this query will be visible for the role that the DLS is defined for.

### Example

Let's imagine we have an index called `humanresources`. This index contains documents with type `employees`, and these documents have a field called `department`. We want to define a query that allows access to all employee documents, except those where the department is set to "Management". 

The respective query to filter these documents in regular query DSL would look like:

```
{
  "query": {
    "bool": {
      "must_not": { "match": { "department": "Management" }}
    }
  }
}
```

You can use this exact query to define the DLS in `sg_roles.yml`:

```
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

### Username substitution

In addition to the regular query DSL of Elasticsearch, Search Guard also supports username substitution. You can use the variable `${user.name}` in the DLS query, and Search Guard will replace it with the username of the currently logged in user.

Let's imagine that each employee document has a field called `manager`, which contains the username of the employee's manager. Each logged in user should only have access to employees he manages. You can do so by defining:

```
management:
  indices:
    'humanresources':
      'employees':
        - '*'
      _dls_: '{"term" : {"manager" : "${user.name}"}}'
```

Before the DLS query is applied to the result set, `${user.name}` is replaced by the currently logged in user. You can use this variable repeatedly in the DLS query if required.

### Multiple roles and document-level security

A user can be member of more than one role, and each role can potentially define a different DLS query for the same index. In this case, all DLS queries are collected and combined with `OR`.

### Performance considerations

As stated above, a DLS query can be as complex as necessary, and you can use the full range of Elasticsearch's query DSL. Regarding the performance overhead, think of the DLS query as an additional query executed on top of your original one. While technically speaking this statement is not 100% true, you can use it as a rule of thumb: The more complex your DLS query, the higher the performance impact will be.

## Field-level security

Field-level security controls which fields a user is able to see. As with document-level security, FLS can be defined per role and per index. Search Guard supports including (whitelisting) and excluding (blacklisting) fields from documents.

In order to restrict access to certain fields, you simply list the fields to be excluded or included on the same indentation level as the document types.

### Including fields

In this mode, only fields listed in the FLS section of the role definition are returned by Search Guard. In the example below, only the fields `Designation`, `FirstName` and `LastName` are included in the returned documents. All other fields are filtered out:

```
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

### Excluding fields

If you rather want to exclude than include fields, simply prefix all fields with a `~`. In the example below, all fields except `Designation`, `FirstName` and `LastName` are returned by Search Guard:

```
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

### Using wildcards

You can use wildcards when definig FLS field, both for include and exclude mode.

For example:

```
- '*Name'
```

only returns fields that end with `Name`, while on the other hand

```
- '~*Name'
```

would filter our all fields that end with `Name`.

An asterisk matches any character sequence, while a question mark will match any single character.

Using wildcards with FLS security will have an effect on the overall performance, especially if you are dealing with documents that contain a huge number of fields. If possible, they should be avoided. See also chapter "Performance considerations" below.

### Mixing included and excluded fields

Mixing included and excluded fields per role and index does not make sense and leads to undefined results.

Please make sure that the FLS definition(s) of an authenticated user is either include only, or exclude only!

### Multiple roles and field-level security

As with document-level security, if a user is member of multiple roles it is important to understand how the FLS settings for these roles are combined.

In case of FLS, the FLS field definitions of the roles are combined with `AND`. If you use FLS `include` (whitelisting) and `exclude` (blacklisting) definitions for different roles, you need to make sure that for each user and its roles the combination of the FLS field is either include only, or exclude only.

## DLS/FLS Execution Order

If you use both DLS and FLS, all fields that you are basing the DLS query on must be visible, i.e. not filtered by FLS. Otherwise, your DLS query will not work properly. 