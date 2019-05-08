---
title: Custom Principal Extractor
html_title: Principal Extractor
slug: search-guard-oem-principal-extractor
category: systemintegrators
order: 600
layout: docs
edition: community
description: How implement a custom TLS principal extractor for Seaerch Guard.
---

<!---
Copyright 2018 floragunn GmbH
-->

# Custom Principal Extractor

When using (client) TLS certificates for authentication and authorization, Search Guard uses the X.500 principal as the username by default. If you want to use any other part of the certificate as principal, Search Guard provides a hook for your implementation.

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



