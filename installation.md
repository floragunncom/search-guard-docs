<!---
Copryight 2016 floragunn UG (haftungsbeschränkt)
-->

# Installation

**Note: At the time of writing, only Elasticsearch 2.3.3 is supported, but we'll provide installable versions for prior ES 2.x versions soon.**

First you need to install and configure Search Guard SSL on all nodes in your cluster. Please note that while most of the configuration settings for Search Guard can be changed at runtime, configuration changes for the SSL/TLS layer require the restart of all participating nodes. So please make sure that Search Guard SSL is running properly before installing Search Guard, and pay attention to the different types of certificates you need for server- and client nodes.

The required Search Guard SSL version for Elasticsearch 2.3.3 is 2.3.3.13.

Search Guard itslef can be installed like any other Elasticsearch plugin. 

Change to the directory of your Elasticsearch installation and type:

```
sudo bin/plugin install -b com.floragunn/search-guard-2/2.3.3.1
```

After that you should see a folder called "search-guard-2" in the plugin directory of your Elasticsearch installation.

Nearly all configuration settings for Search Guard are kept in Elasticsearch itself and can be changed at runtime by using the ```sgadmin``` command line tool. The only static configuration is the definition of the admin SSL certificate(s). This certificate is required by ```sgadmin```, and is used to verify that the user of this script is actually allowed to make changes to the Search Guard settings. Please see below for further information on the admin certificate(s).

You can define one or more of those admin certificates. Please add the following lines to to your elasticsearch.yml file (at any place), and change the settings according to your certificate(s):

```
searchguard.authcz.admin_dn:
  - cn=admin,ou=Test,ou=ou,dc=company,dc=com
```

If you want to use any of the enterprise modules, download the respective jar file and place it in the folder `<ES installation directory>/plugins/search-guard-2`.

Each module lives in its own github repository. Please visit github for the most recent version of the modules:

#### LDAP- and Active Directory Authentication/Authorisation:
 [https://github.com/floragunncom/search-guard-authbackend-ldap](https://github.com/floragunncom/search-guard-authbackend-ldap) 

#### Kerberos Authentication/Authorisation:
 [https://github.com/floragunncom/search-guard-auth-http-kerberos](https://github.com/floragunncom/search-guard-auth-http-kerberos) 

#### JWT Authentication/Authorisation:
(coming soon)

#### Document- and field level security:
 [https://github.com/floragunncom/search-guard-module-dlsfls](https://github.com/floragunncom/search-guard-module-dlsfls) 
 
#### Audit logging:
 [https://github.com/floragunncom/search-guard-module-auditlog](https://github.com/floragunncom/search-guard-module-auditlog) 

Most of these modules require additional configuration settings. Please see the respective sections of this document for further information.

## Certificates

In order to generate the correct certificates for all participating nodes and clients, you first need to identify for whichy type of node or client you are generating a certificate.

Again, if you use the example PKI scripts shipped with Search Guard SSL, or use the [Search Guard Bundle](quickstart.md), these certificates already have the correct settings.
 
### Terminology

The Elasticsearch terminology for nodes and clients is not really coherent. So we decided to introduce our own terminology for some topics:

#### SG Server Node (#sgsn)
A SG server node is an Elasticsearch node which is part of the cluster. This type of node needs an SSL certificate with a special subject alternative name (SAN). Example: Normal data nodes, master nodes, tribe nodes and SG Server Router Node (#sgsrn).

#### SG Server Router Node (#sgsrn)
This is a node (sometimes referred to as "client node") which lives on a server and acts like a Router or Loadbalancer for client requests. See [here](https://www.elastic.co/guide/en/elasticsearch/reference/2.3/modules-node.html#client-node) for more information. This type of node has always the following settings applied:

```
node.master: false 
node.data: false
```

This type of node needs also a SSL certificate with a special subject alternative name (SAN).

#### SG Server Tribe Node (#sgstn)
[Tribe Nodes](https://www.elastic.co/guide/en/elasticsearch/reference/2.3/modules-tribe.html) are **not yet** supported by Search Guard, but will be with one of the next releases (https://github.com/floragunncom/search-guard/issues/47).

#### SG Non-Server Node (#sgnsn)
This is the [Java Transport Client](https://www.elastic.co/guide/en/elasticsearch/client/java-api/current/transport-client.html) and lives on a client host. See [here](https://github.com/floragunncom/search-guard/issues/53#issuecomment-217019746) on how to connect with that to a Search Guard secured cluster. You just need the Search Guard SSL Plugin and an SSL certificate which is trusted by the nodes you connect to. This type of node **does not** need a SSL certificate with a special subject alternative name (SAN).

#### SG Non-Server Node Client (#sgnsnc)
This is the [Java Node Client](https://www.elastic.co/blog/found-interfacing-elasticsearch-picking-client) which lives on a client host and is **NOT** supported by Search Guard. Please use "SG Non-Server Node (#sgnsn)" instead. 

### Generating a Server Certificate

The only requirement for a server certificate is that it has the follwing entry as subject alternative name (SAN):

* ```oid:1.2.3.4.5.5```

If you use the example scripts that ship with Search Guard SSL, the certificates already contain this setting. For example, the script ```gen_node_cert.sh``` uses the follwing call to ```keytool``` to generate the certificate. Pay attention to the last line:

```
keytool -genkey \
        -alias     $NODE_NAME \
        -keystore  $NODE_NAME-keystore.jks \
        -keyalg    RSA \
        -keysize   2048 \
        -validity  712 \
        -keypass $KS_PASS \
        -storepass $KS_PASS \
        -dname "CN=$NODE_NAME.example.com, OU=SSL, O=Test, L=Test, C=DE" \
        -ext san=dns:$NODE_NAME.example.com,ip:127.0.0.1,oid:1.2.3.4.5.5
```

### Generating a Client Certificate

There are no special requirements for a client certificate, other than that it is signed with a Root CA that is trusted by all nodes. You do not need to specify a special SAN entry. As with server certificates, if you use the example scripts shipped with Search Guard SSL, this is already configured. For example, the script ```gen_client_cert.sh``` uses the follwing call to ```keytool``` to generate the certificate:

```
keytool -genkey \
        -alias     $CLIENT_NAME \
        -keystore  $CLIENT_NAME-keystore.jks \
        -keyalg    RSA \
        -keysize   2048 \
        -validity  712 \
        -keypass $KS_PASS \
        -storepass $KS_PASS \
        -dname "CN=$CLIENT_NAME, OU=client, O=client, L=Test, C=DE"
```

### Generating an Admin Certificate

In order to use the ```sgadmin``` command line tool, which can load and modify the Search Guard configuration settings, you need a certificate authenticating yourself as a valid admin user of Search Guard.

This certificate has no special requirements, so you can use any certificate that is signed with your Root CA.

As mentioned above, you just need to provide the settings of this certificate in the elasticsearch.yml file:

```
searchguard.authcz.admin_dn:
  - cn=admin,ou=Test,ou=ou,dc=company,dc=com
``` 

You can use more than one admin certificate. See also the chapter [Configuration](configuration.md) for more information.
