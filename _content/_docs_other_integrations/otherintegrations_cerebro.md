---
title: Cerebro
html_title: Cerebro
permalink: elasticsearch-cerebro-search-guard
category: otherintegrations
order: 600
layout: docs
edition: community
description: How to configure and use Cerebro with a Search Guard secured Elasticsearch cluster. Protect your data from any unauthorized access.
resources:
  - https://www.playframework.com/documentation/2.6.x/WsSSL|Configuring WS SSL (website)
  - https://www.playframework.com/documentation/2.5.x/ExampleSSLConfig|Example configurations (website)

---
<!---
Copyright floragunn GmbH
-->

# Using Cerebro with Search Guard
{: .no_toc}

{% include toc.md %}

Cerebro connects to Elasticsearch on the REST layer, just like a browser or curl. Cerebro detects HTTP Basic Authentication automatically, so you only need to set up TLS. If you are using self-signed certificates, you have two options:

* disable certificate validation (not recommended)
* configure the root CA in Cerebro (recommended)

## Setting up a root CA

To configure your root CA in Cerebro, add the following configuration to application.conf:

```
play.ws.ssl {
  trustManager = {
    stores = [
      { type = "PEM", path = "/path/to/root-ca.pem" }
    ]
  }
}     
```

## Disabling certificate validation

To disable certificate validation, add the following configuration to application.conf:

```
play.ws.ssl.loose.acceptAnyCertificate=true
```

## Cerebro user

Since Cerebro is an admin tool for Elasticsearch, the user should have full permissions to manage the cluster. If you use the sample configuration Search Guard ships with, you can use the `SGS_ALL_ACCESS` role.

## Pre-configuring clusters

Cerebro also allows to pre-configure clusters in `application.conf`, for example:

```
hosts = [
  {
    host = "https://elasticsearch.example.com:9200"
    name = "Search Guard Secured Cluster"
    auth = {
      username = "admin"
      password = "admin"
    }
  }
]
```