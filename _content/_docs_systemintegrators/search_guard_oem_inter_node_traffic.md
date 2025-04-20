---
title: Inter-node traffic evaluator
html_title: Inter-node traffic
permalink: search-guard-oem-inter-node-traffic
layout: docs
edition: community
description: How implement a custom inter-node traffic evaluator for Search Guard.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Custom inter-node traffic evaluator

If the provided methods of listing the DNs of node certificates or adding an OID to the certificates does not work for you, you can implement your own class to identify inter-cluster traffic. It must implement the following interface:

```java
com.floragunn.searchguard.transport.InterClusterRequestEvaluator
```

And provide a single argument constructor that takes a

```java
org.elasticsearch.common.settings.Settings
```

as argument. For example:

```java
public final class MyInterClusterRequestEvaluator
  implements InterClusterRequestEvaluator {
    
    public MyInterClusterRequestEvaluator(final Settings settings) {
    ...
    }

    @Override
    public boolean isInterClusterRequest(
       TransportRequest request,
       X509Certificate[] localCerts,
       X509Certificate[] peerCerts,
       final String principal) {
       ...
    }
}
```

Make sure the class is on the classpath, and configure your custom implementation in `elasticsearch.yml`:

```
searchguard.cert.intercluster_request_evaluator_class: ...
```