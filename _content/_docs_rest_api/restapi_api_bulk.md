---
title: REST API - Bulk Requests
html_title: REST API - Bulk Requests
slug: rest-api-bulk
category: restapi
order: 600
layout: docs
edition: enterprise
description: How to perform REST API bulk requests
---
<!---
Copyright 2020 floragunn GmbH
-->

# REST API - Bulk Requests
{: .no_toc}

{% include toc.md %}

To perform bulk requests, e.g. creating multiple roles in one request, check the corresponding endpoint page for the PATCH section.
Please note that not all endpoints support bulk requests.

## Example: Creating multiple roles

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

### Example: Creating multiple users

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

### Example: Removing multiple users

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
