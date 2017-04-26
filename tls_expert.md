# Expert features

## Custom Principal Extractor

When using (client) TLS certificates for authentication and authorisation, Search Guard uses the X.500 principal as username by default. If you want to use any other part of the certificate as principal, Search Guard provides a hook for your own implementation.  **Note on principal:** . Principal is an abstract term here and refers to the “entity” the certificate is issued to. If no custom extractor is used, Search Guard by default uses a X.500 Principal, which is  the string representation of the Distinguished Name (DN) of the certificate.

So yes, the default username is in fact the DN of the certificate.


Create a class that implements the `com.floragunn.searchguard.ssl.transport.PrincipalExtractor` interface:

```
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

```
searchguard.ssl.transport.principal_extractor_class: com.example.MyPrincipalExtractor
```
## Injecting an SSLContext

If you are integrating Search Guard with your own software, you might already have an `javax.net.ssl.SSLContext` object available that you want to use. In this case, instead of building an `SSLContext` from the configured keystore and truststore, you can instruct Search Guard to use your `SSLContext` object directly.

Search Guard is able to manage multiple `SSLContext` objects. You need to register the objects you want to use with the `com.floragunn.searchguard.ssl.ExternalSearchGuardKeyStore` and an id first. When constructing the `Settings` object used for instantiating the `TransportClient`, you can configure which `SSLContext` should be used for this `TransportClient`.

Example:

```
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
