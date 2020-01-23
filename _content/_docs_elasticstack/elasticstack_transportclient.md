---
title: Transport Clients
html_title: Transport Clients
slug: elasticsearch-transport-clients-search-guard
category: elasticstack
order: 400
layout: docs
edition: community
description: How to connect to a Search Guard secured Elasticsearch cluster using a Transport Client.

---
<!---
Copyright 2020 floragunn GmbH
-->

# Using Transport Clients
{: .no_toc}

{% include toc.md %}

For a Transport Client to talk to a Search Guard secured Elasticsearch cluster, the following requirements must be met:

* The Transport Client needs to authenticate itself against the cluster by sending a trusted TLS certificate
* A role with appropriate permissions has to be configured in Search Guard, either based on the hostname of the client, or the DN of the certificate

## Setting up the dependencies

First add Search Guard as a dependency to your project. If you are using Maven, add the following dependency to your `pom.xml`: 

```
<dependency>
    <groupId>com.floragunn</groupId>
    <artifactId>search-guard-7</artifactId>
    <version>${sg.version}</version>
    <scope>provided</scope>
</dependency>
```     

The Search Guard version must match the version of your Elasticsearch cluster. 
{: .note .js-note .note-warning}
    
## Configuring the Transport Client

When building the settings for the Transport Client, add the root CA and the TLS client certificate to the `Settings.Builder`:

```
Settings.Builder settingsBuilder = 
  Settings.builder()
  .put(SSLConfigConstants.SEARCHGUARD_SSL_TRANSPORT_PEMCERT_FILEPATH,"<absolute/path/to/certificate>")
  .put(SSLConfigConstants.SEARCHGUARD_SSL_TRANSPORT_PEMKEY_FILEPATH,"<absolute/path/to/key>")
  .put(SSLConfigConstants.SEARCHGUARD_SSL_TRANSPORT_PEMKEY_PASSWORD,"<key password>")
  .put(SSLConfigConstants.SEARCHGUARD_SSL_TRANSPORT_PEMTRUSTEDCAS_FILEPATH, "<absolute/path/to/root CAs>")
  ...
  Settings settings = settingsBuilder.build();
```     

If you are using self-signed certificates, you may want to disable hostname verification:

```
  ...
  .put(SSLConfigConstants.SEARCHGUARD_SSL_TRANSPORT_ENFORCE_HOSTNAME_VERIFICATION, false)
  ...

```     

## Adding the Search Guard plugin

To activate TLS on the transport layer, add the Search Guard plugin to the Transport Client:

```
TransportClient tc = 
  new PreBuiltTransportClient(settings, SearchGuardPlugin.class)
  .addTransportAddress(...)
  ...
```  

## Setting up authentication

When setting up authentication, you have two choices:

* Use the client certificate's DN as username
  * This means all requests are using the same username and thus the same Search Guard role(s)
* Add a username and password to each request
  * This means each request can be assigned to a different user and thus different Search Guard role(s)

  
### Using certificate authentication

When using the certificate that you added to the `Settings.Builder` for authentication, you need to add an authentication domain for the transport layer first:

```
transport_auth_domain:
  order: 0
  http_enabled: false
  transport_enabled: true  
  http_authenticator:
  authentication_backend:
    type: internal     
```  

You can use any authentication backend for the transport layer. Since the certificate has already been verified at this point, Search Guard will only check if the user exists in the configured authentication backend. No password is required. The username is the DN of the certificate.

If you use the internal user database, add the username to `sg_internal_users.yml` like:

```
CN=spock,OU=client,O=client,L=Test,C=DE:
  hash: not_required
``` 

Next, use the sg_roles_mapping.yml to map the certificate to one or more Search Guard roles:

```
sg_readall:
  users:
    - 'CN=spock,OU=client,O=client,L=Test,C=DE'
    - user1
    - user2
    - ...
```

### Using username/password authentication

Credentials on the transport level work very similar to credentials provided via HTTP Basic Authentication. You use the very same format and mechanism, meaning that you

* Add an "Authenticate" header to each request
* Which contains the Base64 encoded username and password separated by a colon

A typical HTTP Basic header on the REST level looks something like this:

```
Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l
```

The part after Basic is the Base64 representation of

```
Aladdin:OpenSesame
```

When using a Transport Client, instead of adding the Basic Authentication credentials to the HTTP request, you need to add them to the ThreadContext headers:

```
TransportClient client = ...

client.threadPool().getThreadContext().putHeader("Authorization", "Basic "+encodeBase64("username:password"));
tc.prepareGet(...).get();
```