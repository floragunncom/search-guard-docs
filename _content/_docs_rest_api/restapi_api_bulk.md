---
title: REST API - Bulk Requests
html_title: REST API - Bulk Requests
permalink: rest-api-bulk
layout: docs
edition: enterprise
description: How to perform REST API bulk requests
---
<!---
Copyright 2022 floragunn GmbH
-->

# REST API - Bulk Requests
{: .no_toc}

{% include toc.md %}

To perform bulk requests, e.g. creating multiple roles in one request, check the corresponding endpoint page for the PATCH section.
Please note that not all endpoints support bulk requests.

## Example: Create multiple roles

```json
PATCH /_searchguard/api/roles
[ 
  { 
    "op": "add", "path": "/klingons",  "value": { "index_permissions": [...] } 
  },
  { 
    "op": "add", "path": "/romulans",  "value": { "index_permissions": [...] }
  }
]
``` 

### Example: Create multiple users

```json
PATCH /_searchguard/api/internalusers
[ 
  { 
    "op": "add", "path": "/spock", "value": { "password": "testpassword1", "backend_roles": ["testrole1"] } 
  },
  { 
    "op": "add", "path": "/worf", "value": { "password": "testpassword2", "backend_roles": ["testrole2"] } 
  }
]
```

### Example: Remove multiple users

```json
PATCH /_searchguard/api/internalusers
[ 
  { 
    "op": "remove", "path": "/riker"} 
  },
  { 
    "op": "remove", "path": "/worf"} 
  }
]
```

### Example: Modify an existing object or array

```json
PATCH /_searchguard/api/internalusers/spock
[
  {
    "op": "add", "path": "/backend_roles/0", "value": "testrole2" 
  },
  {
    "op": "add", "path": "/backend_roles/-", "value": "testrole3"
  },
]
```

The operation inserts the value into an array. The value is inserted before the given index. The `-` character can be used instead of an index to insert at the end of an array.

```json
PATCH /_searchguard/api/internalusers/spock
[
  {
    "op": "remove", "path": "/backend_roles/0"
  }
]
```

The operation removes the element `0` of the array (or just removes the `"0"` key if `backend_roles` is an object)

For more examples, please refer to [JSON patch format documentation](http://jsonpatch.com/).
