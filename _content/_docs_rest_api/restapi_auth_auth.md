---
title: Authentication API
html_title: Authentication API
permalink: rest-api-authentication
category: restapi
order: 460
layout: docs
edition: enterprise
description: How to use the Search Guard REST API to create, modify and change authentication and authorization settings.
---

<!---
Copyright 2022 floragunn GmbH
-->


# Authentication API
{: .no_toc}

{% include toc.md %}

Used to retrieve the configured authentication and authorization modules.

## Endpoint

```
/_searchguard/api/sg_config
```

## GET

```
GET /_searchguard/api/sg_config
```

Returns the configured authentication and authorization modules in JSON format.

## PUT

Since you can break the Search Guard authentication by uploading a faulty configuration, you need to explicitly enable the PUT endpoint by setting `searchguard.unsupported.restapi.allow_sgconfig_modification: true` in elasticsearch.yml
{: .note .js-note}

```
PUT /_searchguard/api/sg_config/
```

Replaces or creates the Search Guard authentication and authorisation configuration.

```
PUT /_searchguard/api/sg_config
{
	"sg_config": {
		"dynamic": {
			"do_not_fail_on_forbidden": false,
			"kibana": {
				"multitenancy_enabled": true
			},
			"http": {
				"anonymous_auth_enabled": false
			},
			"authc": {
				"basic_internal_auth_domain": {
					"http_enabled": true,
					"transport_enabled": true,
					"order": 4,
					"http_authenticator": {
						"challenge": true,
						"type": "basic",
						"config": {}
					},
					"authentication_backend": {
						"type": "intern",
						"config": {}
					},
					"description": "Authenticate via HTTP Basic against internal users database"
				}
			}
		}
	}
}  
```

## PATCH

Since you can break the Search Guard authentication by uploading a faulty configuration, you need to explicitly enable the PUT endpoint by setting `searchguard.unsupported.restapi.allow_sgconfig_modification: true` in elasticsearch.yml
{: .note .js-note}

The PATCH endpoint can be used to change individual attributes of the Search Guard configuration. The PATCH endpoint expects a payload in JSON Patch format. Search Guard supports the complete JSON patch specification.

[JSON patch specification: http://jsonpatch.com/](http://jsonpatch.com/){:target="_blank"}

```
PATCH /_searchguard/api/sg_config/
```

Adds, deletes or changes one or more attributes of the authentication and authorization configuration.

```json
PATCH /_searchguard/api/sg_config/
[ 
  { 
    "op": "replace", "path": "/sg_config/dynamic/authc/basic_internal_auth_domain/transport_enabled", "value": "false"
  }
]
```

