---
title: Inter-node traffic evaluator
html_title: Inter-node traffic
permalink: search-guard-oem-inter-node-traffic
category: systemintegrators
order: 500
layout: docs
edition: community
description: How implement a custom inter-node traffic evaluator for Seaerch Guard.

---
<!---
Copyright 2020 floragunn GmbH
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

<<<<<<< tech-preview
Make sure the class is on the classpath, and configure your custom implementation in `opensearch.yml`/`elasticsearch.yml`:
=======
Make sure the class is on the classpath, and configure your custom implementation in `elasticsearch.yml`:
>>>>>>> 2a2e5e1 OpenSearch support

```
searchguard.cert.intercluster_request_evaluator_class: ...
```