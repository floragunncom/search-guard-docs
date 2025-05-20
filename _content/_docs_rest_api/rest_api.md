---
title: Usage and return values
html_title: REST API usage overview
permalink: rest-api
layout: docs
edition: enterprise
description: General usage instructions for the Search Guard REST API which can be
  used to manage users, roles and permissions.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Search Guard Elasticsearch REST API
{: .no_toc}

{% include toc.md %}

The API provides `GET`, `PUT` and `DELETE` handlers for users, roles, roles mapping and action groups. The general format is:

```
/_searchguard/api/<configuration type>/{resource name}
```

The `configuration type` can be one of:

* [internalusers](rest-api-internalusers)
* [roles](rest-api-roles)
* [rolesmapping](rest-api-roles-mapping)
* [actiongroups](rest-api-actiongroups)
* [tenants](rest-api-tenants)
* [blocks](rest-api-blocks)

The resource name specifies the entry in the `configuration type` you want to operate on. In case of the internal user database, it specifies a user. In case of roles, it specifies the role name, and so on.

The API returns the following HTTP status codes:

* 200: A resource was modified successfully
* 201: A resource was created
* 400: The request could not be processed
* 404: The resource could not be found

The response body has the format:

```json
{
  "status":<HTTP status code>,
  "message":<message>,
  "details": <detailed message in case of an error>,
  "invalid_keys": <comma separated keys>,
  "missing_mandatory_keys": <comma separated keys>  
}
```

The last two entries are returned if you `PUT` a new resource but the content is malformed. `invalid_keys` is used when the content contains invalid keys. `missing_mandatory_keys` is used when a mandatory key is missing. 
