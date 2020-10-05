---
title: Document-level security
html_title: Document-level security
slug: document-level-security
category: dlsfls
order: 100
layout: docs
edition: enterprise
description: Use Document- and Field-Level Security to implement fine grained access control to documents and fields in your Elasticsearch cluster.
resources:
  - "search-guard-presentations#dls-fls|Document- and Field-level security (presentation)"
  - https://search-guard.com/document-field-level-security-search-guard/|Document- and field-level security with Search Guard (blog post)
  - https://search-guard.com/attribute-based-document-access/|Attribute based document access (blog post)

---
<!---
Copyright 2020 floragunn GmbH
-->

# Document-level security
{: .no_toc}

{% include toc.md %}

Document-level security restricts a user's access to certain documents within an index. To enable document-level security you configure an Elasticsearch query that defines which documents are accessible and which not. Only documents matching this query will be visible for the role that the DLS is defined for.

The query supports the full range of the Elasticsearch query DSL, and you can also use user attributes to make the query dynamic. This is a powerful feature to implement access permissions to documents based on user attributes stored in Active Directory / LDAP or a JSON web token.

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

## Dynamic queries: Variable substitution

Search Guard supports variables in the DLS query. With this feature, you can write dynamic queries based on the current users's attributes. 

### Username

You can use the variable `${user.name}` in the DLS query, and Search Guard will replace it with the username of the currently logged in user.

Let's imagine that each employee document has a field called `manager`, which contains the username of the employee's manager. Each logged in user should only have access to employees he manages. You can do so by defining:

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - ...
      dls: '{"term" : {"manager" : ${user.name|toJson}}}'
```

Before the DLS query is applied to the result set, `${user.name|toJson}` is replaced by the currently logged in user. The pipe character introduces a function 
which processes the value of the user name. The function `toJson` converts the user name string to JSON format. This ensures that the user name is quoted and properly escaped. You can use this variable repeatedly in the DLS query if required.

### User Roles

You can use the variable `${user.roles}` in the DLS query, and Search Guard will replace it with a comma-delimited list of the backend roles of the current user.

Let's imagine that each employee document has an array field called `role`, which contains backend role names and at least one of them is needed to access this document. You can do so by defining:

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - ...
      dls: '{"terms" : { "role" : ${user.roles|toJson}}}'
```

Before the DLS query is applied to the result set, `${user.roles|toJson}` is replaced the JSON representation of the array containing the backend roles of the current user. You can use this variable repeatedly in the DLS query if required.

### User Attributes

Any authentication and authorization domain can provide additional user attributes that you can use for variable substitution in DLS queries. 

For this, the auth domains need to configure a mapping from attributes specific to the particular domain to Search Guard user attributes. See the documentation of the respective auth method for details and examples:

- [JWT](../_docs_auth_auth/auth_auth_jwt.md#using-further-attributes-from-the-jwt-claims)
- [LDAP](../_docs_auth_auth/auth_auth_ldap_authentication.md#using-further-active-directory-attributes)
- [Proxy](../_docs_auth_auth/auth_auth_proxy2.md#using-further-headers-as-search-guard-user-attributes)
- [Internal User Database](../_docs_roles_permissions/configuration_roles_permissions.md)


If you're unsure what attributes are available, you can always access the `/_searchguard/authinfo` REST endpoint to check. The endpoint will list all attribute names for the currently logged in user.

**Note:** The attribute mapping mechanism described here supersedes the old mechanism which would automatically provide all attributes from the authentication domain under the prefix `${attr....}`. The old mechanism is now deprecated but still supported. 

#### JWT Example

Suppose a JWT which contains a claim `department`:

```json
{
  "name": "John Doe",
  "roles": "admin, devops",
  "department": 
  {
    "name": "operations",
    "number": "17"
  }
}
```

Then, you need to map it to a Search Guard user attribute in the JWT authenticator configuration:

```yaml
jwt_auth_domain:
  http_enabled: true
  order: 0
  http_authenticator:
    type: jwt
    challenge: false
    config:
      map_claims_to_user_attrs:
        department: department.number
```

Afterwards, you can use it like this in a DLS query:

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - ...
      dls: '{"term" : {"department" : ${user.attr.department|toJson}}}'
```

The DLS query in this case will only return documents where the `department` field equals the `department.number` claim in the users JWT. In this case, it only returns documents where the `department` field equals `17`.

You can also combine multiple variables and username substitution in the same DLS query.

### Subtitution Variable Functionality

Substitution variables are always enclosed in the characters `${` and `}`. Inside the brackets, you specify the attribute name, optionally followed by a chain of operations on the attribute value.

The pipe character `|` followed by a function name causes the attribute value to be processed by the function. You can arbitrarily chain functions.

Available functions are:

**`|toJson`:** Converts the value to a string in JSON format. If the value is a string, it will be properly quoted and escaped. If the value is a number, it will be left untouched. If the value is an object or array, it will be converted into the corresponding JSON syntax.

**`|toString`:** Converts the value to a simple string format. If the value is a string, it will be left without quotes. 

**`|toList`:** Makes sure that the value is a list (or, in JSON terms, an array). If the value is already a list, it will be left unchanged. If the value is a single value, it will be converted to a list containing the single value. You can use this function to ensure that the substituted value is always a list.

**`|head`:** Extracts the first element of a list. If the current value is not a list, the current value is left unchanged. If the current value is an empty list, the current value will be changed to `null`.  You can use this function to ensure that the substituted value is always a scalar value.

**`|tail`:** Extracts all but the first element of a list. If the current value is not a list, the current value will be set to an empty list.


Additionally, you can use the `?:` operator to provide a value in case the current value is unset, resp. `null`. The value to be used in this case is specified after the `?:` in JSON syntax. You can use the `?:` operator at any place between other operations. 

It is recommended to use the `?:` operator for all cases where it is not absolutely sure that a value is always present. If an attribute is unset and no fallback is provided by `?:`, the ES operation triggering the DLS query will be aborted with an error.

**Examples:**

`${user.attr.department?:["17"]|toList|toJson}`: Provides a list/array of departments in JSON format. If the attribute `user.attr.department` is not defined, an array containing the string `"17"` is provided. 

`${user.attr.email|head?:"nobody@nowhere"|toJson}`: Extracts the first element from the list stored by the attribute `user.attr.email`. If the attribute is unset, `nobody@nowhere` will be used as fallback value. Additionally, if the attribute `user.attr.email` contains an empty list, the `|head` function will change the current value to `null`; thus, also in this case the `?:` operator will provide `"nobody@nowhere"` as a fallback.
  
`${user.attr.xyz|tail|head?:0|toJson}`: Extracts the second element of a list and converts it to JSON format. If there is no second element, 0 is returned.


 
## Multiple roles and document-level security

A user can be member of more than one role, and each role can potentially define a different DLS query for the same index. In this case, all DLS queries are collected and combined with `OR`.

If a user has a role that defines DLS restrictions on an index, and another role that does not place any DLS restrictions on the same index, the restrictions defined in the first role still apply.

You can change that behaviour so that a role that places no restrictions on an index removes any restrictions from other roles. This can be enabled in `elasticsearch.yml`: 

```
searchguard.dfm_empty_overrides_all: true
```


## Performance considerations

A DLS query can be as simple or complex as necessary, and you can use the full range of Elasticsearch's query DSL. Regarding the performance overhead, think of the DLS query as an additional query executed on top of your original one. 

## DLS/FLS Execution Order

If you use both DLS and FLS, all fields that you are basing the DLS query on must be visible, i.e. not filtered by FLS. Otherwise, your DLS query will not work properly. 