---
title: Injecting an SSLContext
html_title: Injecting an SSLContext
slug: search-guard-oem-inject-ssl-context
category: systemintegrators
order: 700
layout: docs
edition: community
description: How to inject an SSL context into a Search Guard secured Elasticsearch cluster. This can be used to integrate with 
---
<!---
Copyright 2018 floragunn GmbH
-->

# Injecting an SSLContext

If you are integrating Search Guard with your software, you might already have a `javax.net.ssl.SSLContext` object available that you want to use. In this case, instead of building an `SSLContext` from the configured keystore and truststore, you can instruct Search Guard to use your `SSLContext` directly.

Search Guard can manage multiple `SSLContext` objects. You need to register the objects you want to use with the `com.floragunn.searchguard.ssl.ExternalSearchGuardKeyStore` and an id first. When constructing the `Settings` object used for instantiating the `TransportClient`, you can configure which `SSLContext` should be used for this `TransportClient`.

Example:

```java
SSLContext sslContext = …

ExternalSearchGuardKeyStore.registerExternalSslContext(
    "mycontext",
     sslContext
);

final Settings tcSettings = Settings.builder()
    .put("searchguard.ssl.client.external_context_id", "mycontext")
    .put("path.home",".")
    ...
    .build();

Client client = TransportClient.builder()
    .settings(tcSettings)
    .addPlugin(SearchGuardSSLPlugin.class)
    .build()
```



