---
title: System integrators
html_title: System integrators
slug: system-integrators-oem-search-guard
category: integrators
order: 100
layout: docs
edition: community
description: How to integrate Search Guard with other products and plugins. For System Integrators and OEM partners.
---
<!---
Copyright 2018 floragunn GmbH
-->
# System integrators

## Injecting a Search Guard user

If you are running an Elasticsearch plugin that has access to the `ThreadContext`, you can inject a Search Guard user directly, bypassing the authentication and authorization steps completely. Use this feature if the product you are integrating Search Guard with performs it's own authentication and authorization. 

Search Guard will implicitly trust any injected user. You do not need to add these users to any backend system like LDAP or the internal user database. You can use all features of the role mapping to map injected users to Search Guard roles.

You can use the Search Guard authentication and authorization features and injected users in parallel: When Search Guard detects an injected user, no authentication and authorization steps are performed. If there is no injected user found, the regular authentication and authorization steps apply.

You can enable this feature in elasticsearch.yml by setting:

```
searchguard.unsupported.inject_user.enabled: true
```

Inject a user by adding it as transient header in the ThreadContext:

```
threadContext.putTransient("injected_user", "user_string");
```

If you are compiling against Search Guard, instead of using *injected_user* you can also the the following constant:

```
com.floragunn.searchguard.support.SG_INJECTED_USER
```

### Security risks and caveats

By enabling this feature, you make it possible to inject users in the ThreadContext. Usually, this is done by an Elasticsearch plugin running in front of Search Guard. However, it is also possible to use a `TransportClient` for it. Thus you have to make sure that end users are not able to connect to the Elasticsearch cluster on the transport layer. **Otherwise a malicious attacker can inject any user and impersonate as any user, without having to authenticate!**

If your plugin registers an HTTP transport to intercept REST calls and to inject users, be aware that you cannot use TLS on the REST layer anymore. This is because Elasticsearch only allows one HTTP transport. So the Search Guard TLS HTTP transport has to be disabled. 

### Format

The user string has the following format:

```
username|backend roles|remoteIP:port|custom attributes|tenant
```

| Name | Description |
|---|---|
| username | Name of the user. Mandatory. |
| roles | Comma-separated list of backend roles. Optional |
| remoteIP:port | Remote IP and port of the original request. Optional. If missing, Search Guard will perform the standard remote IP lookup.|
| custom attributes | Custom attributes of the user. Comma-separated list of key/value pairs. The number of values has to be an even number. Optional. |
| tenant | The selected tenant for this request. Optional.  |

The only mandatory field is the username. You can leave all or parts of the other fields empty.

### Example

Full example:
```
admin|role1,role2|127.0.0:80|key1,value1,key2,value2|mytenant
```

```
Username: admin,
backendroles: ["role1", "role2"],
remoteip: "127.0.0:80",
custom_attributes: {
   key1: "value1",
   key2: "value2"
},
tenant: "mytenant"
```

Partial example:

```
admin|role1,role2|||mytenant
```

```
Username: admin,
backendroles: ["role1", "role2"],
remoteip: "(set by Search Guard)",
custom_attributes: {},
tenant: "mytenant"
```

Minimal example:

```
admin||||
```
```
Username: admin,
backendroles: [],
remoteip: "(set by Search Guard)",
custom_attributes: {},
tenant: null
```

## Admin access for injected users

You can assign Search Guard admin privileges to any injected user. By doing so, these users will have complete control over the cluster, bypassing any security restriction imposed by Search Guard. Each request these users make will be executed as if a TLS admin certificate was provided.

To activate that feature, configure it in elasticsearch.yml like:

```
searchguard.unsupported.inject_user.enabled: true
```

To assign elevated admin privileges to a user, list the username in the  `searchguard.authcz.admin_dn` section in `elasticsearch.yml`:

```
searchguard.authcz.admin_dn:
  - injectedadmin
```

Any injected user with username `injectedadmin` will be assigned admin privileges. 

**Note: Due to security concerns, this is only possible for injected users. You cannot assign admin privileges for regular users. Use an admin TLS certificate instead.**

You can also mix admin access granted by a TLS certificate and admin access for injected users:

```
searchguard.authcz.admin_dn:
  - injectedadmin
  - CN=kirk,OU=client,O=client,L=Test,C=DE"
```

Any entry that is not a DN will be treated as usernames, whereas DNs are applied to admin certificates.

## SSL only mode

Search Guard can be operated in "SSL only mode". If this is enabled, Search Guard behaves as if only the SSL functionality was deployed:

* The authentication / authorization modules are not loaded
* The DLS/FLS, Audit Logging and Compliance features are not loaded

Effectively this is identical with only deploying the Search Guard SSL plugin. The TLS only mode can be activated by the following setting in elasticsearch.yml:

```
searchguard.ssl_only: true
```

## Snapshot and restore access to the Search Guard index

By default, Search Guard does not allow to take a snapshot and restore the Search Guard index. This limitation can be lifted by explicitly allowing access to the Search Guard index in elasticsearch.yml:

```
searchguard.unsupported.restore.sgindex.enabled: true
``` 

Note: This setting must be configured **in addition** to

```
searchguard.enable_snapshot_restore_privilege: true
```

Please also refer to the [snapshot and restore configuration](configuration_snapshots.md) documentation.

## Custom inter-node traffic evaluator

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

## Custom Principal Extractor

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
## Injecting an SSLContext

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



