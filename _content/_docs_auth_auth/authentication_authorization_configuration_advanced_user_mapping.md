---
title: Advanced user mapping
html_title: sg_authc advanced user mapping
permalink: authentication-authorization-configuration-advanced-user-mapping
layout: docs
edition: community
description: How to configure, mix and chain authentication and authorization domains
  for Search Guard.
resources:
- search-guard-presentations#configuration-basics|Search Guard configuration basics
  (presentation)
---
<!---
Copyright 2022 floragunn GmbH
-->
# Advanced user mapping
{: .no_toc}

{% include toc.md %}

The `user_mapping` configuration options of authentication domains in `sg_authc.yml` are one of the most powerful elements to configure authentication in Search Guard.

The user mapping functionality cooperates with the authentication frontends and backends to process user information. The authentication frontends and backends populate an object tree - structurally similar to a JSON object - with information that was collected about the user. The kind of information depends on the specific frontends and backends. You need to check the respective documentation for details on that.

The user mapping options now provide a unified way to process this information: As the object tree of user information is structured similarly to a JSON object, user mapping can use JSON paths to extract information from it. 

## `user_mapping.user_name`

The `user_mapping.user_name` options determine the name of the logged in user. 

If you use the `user_mapping.user_name` options, you need to make sure that these produce only a single value. If the options produce an array of values - or no value - authentication will fail.

Normally, you will use `user_mapping.user_name.from` to extract the user name. This option is evaluated after the authentication frontend gathered the credentials, but **before the authentication backend** is called. Thus, the  `user_mapping.user_name.from` option also determines the user name that is sent to the authentication backend.

For anonymous authentication, the option `user_mapping.user_name.static` might be helpful, as it just defines a constant value. This is also evaluated after the authentication frontend, but before any authentication backends.

If you want to map 

### Using only certain sections of a string as user name

In some cases, the user name extracted from the credentials might be more complex than needed or wanted. For example, a JWT subject claim could be specified as an email address like exampleuser@example.com. However, you might want to use only the local part of the email address as user name. For this, you can use the options `user_mapping.user_name.from.json_path` and `user_mapping.user_name.from.pattern`. Use `user_mapping.user_name.from.json_path` to specify the path to the attribute, just like `user_mapping.user_name.from`. 

With `user_mapping.user_name.from.pattern` you specify a regular expression that defines the structure of an expected user name. You can then use capturing groups (i.e., sections enclosed in round parentheses; (...)) to use only a certain part of the subject supplied by the JWT as the Search Guard user name.

For example:

```yaml
auth_domains:
- type: jwt
  user_mapping.user_name.from.json_path: jwt.sub
  user_mapping.user_name.from.pattern: "^(.+)@example\.com$"
```

In this example, `(.+)` is the capturing group, i.e., at least one character. This group must be followed by the string `@example.com`, which must be present, but will not be part of the resulting user name in Search Guard. If you try to login with a subject that does not match this pattern (e.g. `foo@bar`), login will fail.

You can use all the pattern features which the Java Pattern class supports. See the official documentation for details.

Keep in mind that all capturing groups are used for constructing the user name. If you need grouping only because you want to apply a pattern quantifier or operator, you should use non-capturing groups: `(?:...)`.

## `user_mapping.roles`

The `user_mapping.roles` options determine the backend roles of the logged in user. These options are evaluated at the end of the authentication process, after authentication frontend, backend and user information backends have finished. Thus, you can use information from all these components to construct role information.

In contrast to the user name, a user usually has more than one role. Thus, the JSON paths evaluated by `user_mapping.roles` can produce arrays of values. 

Even though the data structures usually support multi-valued attributes, many components only produce single values containing the roles as comma-separated string.

For this, you can use the shortcut `user_mapping.roles.from_comma_separated_string` searches for strings and splits these by commas. If you are sure that your frontend or backend produces actual arrays, you can use the simple `user_mapping.roles.from`, which does not do splitting.

Like `user_mapping.user_name`, `user_mapping.roles` also supports regular expressions to extract sub-strings from strings. Use the options `user_mapping.roles.from.json_path` and `user_mapping.roles.from.pattern` for this. 

If you have one component which produces role names as a single string, but separated by a character other than a comma, you can use `user_mapping.roles.from.json_path` combined with `user_mapping.roles.from.split` to specify the character to split at.

## JSON paths

Even though the JSON paths used for user mapping are very simple in most cases, you actually have a very comprehensive tree query language at hand. 

A JSON path can look like this:

```
$.ldap_group_entries[*].businessCategory
```

It is composed of the following parts:

- `$` stands for the root of the object tree. However, it can be omitted in most cases. That's why you won't see it in most examples.
- The period is a child operator, you extract the child with the name right of the period. This only works when the name does not contain characters which are reserved by JSON path. If it does, you can use square brackets as alternative child operator: `$["ldap_group_entries"][*]["businessCategory"]`. 
- `[*]` stands for all children of an object or array. 

Thus, the expression above collects the union of the `businessCategory` attribute values of all `ldap_group_entries`. 

### Filtering

You can also filter by values:

```
$.ldap_group_entries[?(@.sys == "search")].businessCategory
```

This collects only the `businessCategory` attribute values of the entries which have an attribute `sys` which has the value `search`. `@.sys` in the example, is a JSON path by itself. `@` denotes the *current* object; thus, we are looking at the `sys` attribute of `ldap_group_entries` objects. However, we also could specify a more complex JSON path here, descending deeper into the object tree or even ascending using `..`. 

In the filter expressions, you can use the following operators:

- `==`: Equality
- `!=`: Inequality
- `>`: Greater than
- `<`: Less than
- `>=`: Greater or equal
- `<=`: Less or equal
- `===`: Type-safe equality
- `!==`: Type-safe inequality
- `=~`: Matches a regular expression: `$.ldap_group_entries[?(@.dn =~ /^.*test.*$/i)].businessCategory`
- `IN`: Contained in a set: `$.ldap_group_entries[?(@.cn[*] IN ['a', 'b'])].businessCategory`
- `NIN`: Not contained in a set
- `CONTAINS`: A set contains a value:  `$.ldap_group_entries[?(@.foo CONTAINS 'a')].businessCategory`
