---
title: License API
html_title: License API
permalink: rest-api-license
layout: docs
section: security
edition: enterprise
description: How to use the license REST API endpoints to retrieve and apply a Search
  Guard license.
---
# License API
{: .no_toc}

{% include toc.md %}

Used to retrieve and update the Search Guard license.

## Endpoint

```
/_searchguard/api/license/
```

## GET

```
GET /_searchguard/api/license/
```
Returns the currently installed license in JSON format. 

## PUT

```
PUT /_searchguard/api/license/
```

Validates and replaces the currently active Search Guard license. Invalid (e.g. expired) licenses are rejected.

```json
PUT /_searchguard/api/license/
{ 
  "sg_license": <licensestring>
}
```