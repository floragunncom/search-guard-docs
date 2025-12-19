---
title: Search Guard 7.x-51.0.0
permalink: changelog-searchguard-7x-51_0_0
layout: docs
section: security
description: Changelog for Search Guard 7.x-51.0.0
---
<!--- Copyright 2021 floragunn GmbH -->

# Search Guard Suite 51.0

**Release Date: 2021-06-08**

This is a maintenance release of Search Guard which brings some smaller improvements and bug fixes. See below for details.

### Support for HTTP proxies in Signals checks and actions

You can now specify HTTP proxies for all Signals checks and actions which create HTTP connections. This can be useful if you are running your ES installation in a setup which does not allow direct outgoing HTTP connections. A proxy can be defined both as a global default and on a action or check level.

#### Default Proxy

Signals supports now global configuration of an HTTP proxy which is used for all Signals checks and actions which create HTTP connections. These actions are

* HTTP input
* Webhook action
* Slack action
* PagerDuty action
* Jira action

The global proxy can be configured using the Signals setting `http.proxy`. To set a global proxy, you can use this command:

```
curl -k -u admin -X PUT -H "Content-Type: application/json" -d '"http://proxy.host:8080"' 'https://your-es-host:9200/_signals/settings/http.proxy'
```

#### Proxy specific to HTTP input and Webhook action

It is also possible to specify a proxy directly in the definition of an HTTP input or a webhook action.

This can be achieved using the property `proxy` which must be specified on the top level of an action or input definition. 

For example:

```
{
	"actions": [
		{
			"type": "webhook",
			"name": "my_webhook_action",
			"throttle_period": "10m",
                        "proxy": "http://proxy.host:8080",
			"request": {
				"method": "POST",
				"url": "https://my.test.web.hook/endpoint",
				"body": "{\"flight_number\": \"{{data.source.FlightNum}}\"}",
				"headers": {
					"Content-Type": "application/json"
				}
			}
		}
	]
}
```

This will override a global proxy configuration. If there is a global proxy configuration, but you want that a particular webhook action or HTTP input does not use a proxy, you can specify `"proxy": "none"`.

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/44)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/130)
* [Signals Settings REST API](https://docs.search-guard.com/latest/elasticsearch-alerting-rest-api-settings-put)


### Support for Search Templates

Search Guard now properly allows to assign a user the privileges for using Elasticsearch [search templates](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-template.html). To allow a user to use search templates, add the action group  `SGS_SEARCH_TEMPLATES`  to the cluster permissions of a role of the user:

```
{
  "index_permissions" : [
    {
      "index_patterns" : [ "your_index" ],
      "allowed_actions" : [ "SGS_READ" ]
    }
  ],
  "cluster_permissions": [ "SGS_SEARCH_TEMPLATES" ]
}
```

Details:

* [Issue](https://git.floragunn.com/search-guard/search-guard-suite/-/issues/35)
* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite/-/merge_requests/129)


### Support PUT /_searchguard/api/sg_config

The endpoint `PUT /_searchguard/api/sg_config/sg_config` is now also available at the more expected address `PUT /_searchguard/api/sg_config`. 

These endpoints remain to be only available if `elasticsearch.yml` contains `searchguard.unsupported.restapi.allow_sgconfig_modification: true`.

Details:

* [Merge request](https://git.floragunn.com/search-guard/search-guard-suite-enterprise/-/merge_requests/68)
 