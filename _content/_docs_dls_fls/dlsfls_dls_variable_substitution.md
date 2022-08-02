---
title: Attribute-based authorization
html_title: Attribute-based DLS authorization with Search Guard
permalink: attribute-based-dls
category: dls
order: 200
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

# Attribute-based DLS authorization
{: .no_toc}

{% include toc.md %}

Search Guard supports variables in the DLS query. With this feature, you can write dynamic queries based on the current users's attributes. This allows you to construct a permission scheme that is more flexible than bare role-based authorization.

In addition to the simple user name and the roles of a user, Search Guard allows you to use arbitrary user attributes, which are defined inside your `sg_authc` configuration with the `user_mapping.attributes` [settings](../_docs_auth_auth/auth_auth_rest_config.md#mapping-user-information). These attributes can be extracted from all information that is available during authentication, such as claims from JWT tokes, LDAP roles, request headers, etc.

Search Guard provides a number of functions which can be used to construct complex queries from user attributes.

## Example

For the example, we look at JWT-based authentication. Suppose a user authenticated with JWT which contains a claim `department`:

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
auth_domains:
- type: jwt
  ...
  user_mapping.attributes.from:
    dept_no: jwt.department.number
```

The expression after `dept_no` is a JSON path, which reads the attribute `number` inside the object `department`, which is again found in the object `jwt`. During the authentication phase,
Search Guard automatically constructs this object tree from the information in the request. The attributes inside the `jwt` object directly correspond to the object structure of the JWT that was used during 
authentication. The result of the JSON path is mapped to the user attribute `dept_no`.

Afterwards, you can use the user attribute `dept_no` like this in a DLS query:

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - ...
      dls: '{"term" : {"department" : ${user.attr.dept_no|toJson}}}'
```

When the user accesses the index `humanresources`, Search Guard will automatically construct a query that looks like this:

```json
{"term" : {"department" : "17"}}}
```

The `|toJson` pipe function that can be found in the variable substitution expression, takes care that a proper JSON fragment is constructed from the attribute value. Attributes can be of arbitrary types. Using the `|toJson` function, you make sure that you can safely embed strings, numbers, objects or arrays in the query.

The DLS query in this case will only return documents where the `department` field equals the `department.number` claim in the users JWT. In this case, it only returns documents where the `department` field equals `17`.

## Authentication modules that are able to provide user attributes


Any authentication and authorization domain can provide additional user attributes that you can use for variable substitution in DLS queries. 

For this, the auth domains need to configure a mapping from attributes specific to the particular domain to Search Guard user attributes. See the documentation of the respective auth method for details and examples:

- [Internal User Database](../_docs_auth_auth/internalusers.md)
- [JWT](../_docs_auth_auth/auth_auth_jwt.md#using-further-attributes-from-the-jwt-claims)
- [LDAP](../_docs_auth_auth/auth_auth_ldap_authentication.md#using-further-active-directory-attributes)
- [Trusted Origin](../_docs_auth_auth/auth_auth_proxy.md#using-further-headers-as-search-guard-user-attributes)
- [OIDC](../_docs_kibana/kibana_authentication_openid.md)
- [SAML](../_docs_kibana/kibana_authentication_saml.md)

If you're unsure what attributes are available, you can always access the `/_searchguard/authinfo` REST endpoint to check. The endpoint will list all attribute names for the currently logged in user.

**Note:** The attribute mapping mechanism described here supersedes the old mechanism which would automatically provide all attributes from the authentication domain under the prefix `${attr....}`. The old mechanism is no longer supported by Search Guard FLX.

## Standard user attributes

Using the arbitrarily structured gives you the greatest flexibility and the greatest expressiveness when using dynamic DLS query. Still, you can also use the username and the roles of a user for variable substitution.

**`${user.name}`:** This allows you to access the user name. In order to safely use the user name in the JSON-based query, you should normally use `${user.name|toJson}`.

**`${user.roles}`:** This allows you to access the roles of a user. The roles are represented as an array of strings. In order to safely use the role names in the JSON-based query, you should normally use `${user.roles|toJson}`.


## Functions for variable substitution

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


