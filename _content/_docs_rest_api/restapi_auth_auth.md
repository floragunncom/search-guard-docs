---
title: Authentication API
html_title: Search Guard Authentication REST API endpoints
slug: rest-api-authentication
category: restapi
order: 460
layout: docs
edition: enterprise
description: How to use the authentication REST API endpoints.
---

<!---
Copyright 2019 floragunn GmbH
-->


# Authentication API
{: .no_toc}

{% include toc.md %}

Used to retrieve the configured authentication and authorization modules.

## Endpoint

```
/_searchguard/api/sgconfig
```

## GET

```
GET /_searchguard/api/sgconfig
```

Returns the configured authentication and authorization modules in JSON format.
