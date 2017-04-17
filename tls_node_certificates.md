# Node certificates

This chapter explains the requirements regarding node certificates. It is only relevant if you plan to generate your own certificates with your own PKI infrastructure. 

If you generated the certificates with one of the methods described in the chapter [Prerequisites](tls_overview.md), everything is already set and you can jump to [TLS Configuration](tls_configuration.md) directly.
 
## Identifying inter-node traffic

Search Guard needs to securely and reliably identify internal communication between Elasticsearch nodes (inter-node traffic). This communication happens for example if one node receives a GET request on the HTTP layer, but needs to forward it to another node that holds the actual data. Search Guard does not perform any security checks for this kind of traffic.

Since Search Guard makes heavy use of TLS already, it also uses TLS certificates for identifying inter-node traffic. Search Guard offers several ways of dealing with inter-node traffic. Depending on your PKI setup and capabilities, you can choose from one of the following methods:

## Using the default OID value

This is the default setting of Search Guard. When Search Guard receives a request on the transport layer (remember that TLS is mandatory here), it checks the calling node's certificate for a certain `OID` value.

`OID` stands for an object identifier and in this context it is used to identify an X.509 certificate extension, i.e. additional data fields stored in the certificate, which are not predefined by the standard.

If you want to learn more about OIDs in TLS certificates, refer to Red Hats [Standard X.509 v3 Certificate Extension Reference](https://access.redhat.com/documentation/en-US/Red_Hat_Certificate_System/8.0/html/Admin_Guide/Standard_X.509_v3_Certificate_Extensions.html
).

The `OID` is configured in the `Subject Alternative Name (SAN)` section of the certificate, and must have the value `1.2.3.4.5.5`. If this value is not found, the certificate is considered invalid.

If you are unsure if the certificates in the keystore contain the correct OID value, you can check it with the following `keytool` command:

```
keytool -list -v -keystore node-0-keystore.jks
```

Check that the `SAN` extension for your node certificate contains the correct `OIDName`:

```
Certificate[1]:
Owner: CN=node-0.example.com, OU=SSL, O=Test, L=Test, C=DE
...
Extensions:
...
SubjectAlternativeName [
  DNSName: node-0.example.com
  ...
  OIDName: 1.2.3.4.5.5
]
```

## Using a custom OID value

If you cannot set the `OID` to the default value `1.2.3.4.5.5`, but you are able to use a different value, you can configure this value in `elasticsearch.yml` by setting:

```
searchguard.cert.oid: <String>
```

## Configuring valid node certificates

If you cannot set an `OID` value when generating certificates, for example if your PKI infrastructure simply does not support this, you can simply list all node certificate DNs in `elasticsearch.yml`:

```
searchguard.nodes_dn:
  - "CN=*.example.com, OU=SSL, O=Test, L=Test, C=DE"
  - "CN=node.other.com, OU=SSL, O=Test, L=Test, C=DE"
```

All certificate DNs listed here are considered valid node certificates. **Wildcards** and **regular expressions** are supported.

If you use this approach, please make sure to list only node certificates. Since a node certificate has all acess privileges to your cluster, listing wrong certificates here could pose a security risk!

## Expert: Custom implementation

If none of the approaches above works, you can also implement your own class to identify inter-cluster traffic. It must implement the following interface:

```
com.floragunn.searchguard.transport.InterClusterRequestEvaluator
```

And provide a singe argument constructor that takes a

```
org.elasticsearch.common.settings.Settings
```

as argument. For example:

```
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

## Extended key usage settings

A node certificate is used for server authentication and client authentication:

If a node issues an request to another node, it acts like a client, requesting data from a server.

If a node receives requests from another noder, it acts like a server, accepting requests from the client node.

Therefore, node certificates have to have the extended key usage setting to containing both `serverAuth` and `clientAuth`:

Again, you can check the settings in your keystore with the following command:

```
keytool -list -v -keystore node-0-keystore.jks
```

You should see the following output in the Extended Key Usages section:

```
ExtendedKeyUsages [
  serverAuth
  clientAuth
]
```