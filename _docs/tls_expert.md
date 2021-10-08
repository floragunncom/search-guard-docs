---
title: Expert Features
html_title: TLS Expert Features
slug: tls-expert
category: tls
order: 600
layout: docs
edition: community
description: How to write your own inter-node traffic evaluator and TLS principal extractor for Search Guard.
---
<!---
Copyright 2017 floragunn GmbH
-->
# Expert features
{: .no_toc}

{% include_relative _includes/toc.md %}

## Custom inter-node traffic evaluator

If the provided methods of listing the DNs of node certificates or adding an OID to the certificates does not work for you, you can implement your own class to identify inter-cluster traffic. It must implement the following interface:

```java
com.floragunn.searchguard.transport.InterClusterRequestEvaluator
```

And provide a singe argument constructor that takes a

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

## Custom Principal Extractor

When using (client) TLS certificates for authentication and authorisation, Search Guard uses the X.500 principal as username by default. If you want to use any other part of the certificate as principal, Search Guard provides a hook for your own implementation.

Create a class that implements the `com.floragunn.searchguard.ssl.transport.PrincipalExtractor` interface:

```java
public interface PrincipalExtractor {
    
  public enum Type {
      HTTP,
      TRANSPORT
  }

  /**
   * Extract the principal name
   * 
   * Please note that this method gets called for principal 
   * extraction of other nodes as well as transport clients. 
   * It's up to the implementer to distinguish between them
   * and handle them appropriately.
   * 
   * Implementations must be public classes with a default 
   * public default constructor.
   * 
   * @param x509Certificate The first X509 certificate in the 
   *  peer certificate chain. This can be null, in this case the 
   *  method must also return <code>null</code>.
   *
   * @return The principal as string. This may be <code>null</code>
   *  in case where x509Certificate is null or the principal cannot 
   *  be extracted because of any other circumstances.
   */
  String extractPrincipal(X509Certificate x509Certificate, Type type);

}
```

You can then define the Principal Extractor to use in `elasticsearch.yml` like:

```yaml
searchguard.ssl.transport.principal_extractor_class: com.example.MyPrincipalExtractor
```
## Injecting an SSLContext

If you are integrating Search Guard with your own software, you might already have an `javax.net.ssl.SSLContext` object available that you want to use. In this case, instead of building an `SSLContext` from the configured keystore and truststore, you can instruct Search Guard to use your `SSLContext` directly.

Search Guard is able to manage multiple `SSLContext` objects. You need to register the objects you want to use with the `com.floragunn.searchguard.ssl.ExternalSearchGuardKeyStore` and an id first. When constructing the `Settings` object used for instantiating the `TransportClient`, you can configure which `SSLContext` should be used for this `TransportClient`.

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
