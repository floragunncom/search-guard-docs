<!---
Copryight 2016 floragunn GmbH
-->

# Architecture and dependencies

## Search Guard 2

In order to use Search Guard, you need to install and configure the free and Open Source **Search Guard SSL** plugin first. Search Guard SSL adds SSL/TLS encryption to the transport- and REST-layer of Elasticsearch and serves as the foundation for Search Guard.

You can find Search Guard SSL and the documentation for it also on github:

* [Search Guard SSL](https://github.com/floragunncom/search-guard-ssl)
* [Search Guard SSL Documentation](https://github.com/floragunncom/search-guard-ssl-docs)

Search Guard SSL has to be installed on all nodes in your cluster.

## Search Guard 5

Search Guard 5 comes bundled with Search Guard 5 SSL already, so you just need to install the Search Guard 5 plugin.

If you only need TLS encryption, we still offer Search Guard 5 SSL as a standalone plugin.

## Search Guard modules

All free modules, such as HTTP basic authentication, are already built-in. The **enterprise features** are implemented as **separate modules**. Depending on your requirements, download the modules you need and place them in the `plugins/search-guard-x/` folder of your Elasticsearch installation. See the [installation](installation.md) and [configuration](condifuration.md) section of this document for further information . For added security we strongly recommend to only install and run the modules you need.

## Why do I need SSL/TLS when running Search Guard?

While SSL/TLS encryption on the REST-layer is optional, it is mandatory on the transport layer. In other words, it is **not possible to run Search Guard without Search Guard SSL**.

We deliberately made this design decision, because we strongly believe that without securing the transport layer (meaning the communication between the nodes in a cluster), any attempt to adding security to Elasticsearch is in vain.

Why? Out of the box, Elasticsearch does not provide any security features at all. This means that everyone with access to your network is able to see and alter all your Elasticsearch traffic. Even worse, since there is no security regarding the participating nodes in your cluster, anyone can set up an additional node and join your cluster.

It is our belief that before you start adding authentication/authorisation, you need to make sure that:

* No one can spy on the Elasticsearch traffic
* No one can alter the Elasticsearch traffic
* Only trusted nodes can join the cluster
* Only trusted users can access Elasticsearch
 
This is exactly what Search Guard SSL provides. Please refer to the [Search Guard SSL Documentation](https://github.com/floragunncom/search-guard-ssl-docs) for further information. 

## Client- and Server Certificates

Search Guard needs to identifiy the type of traffic to secure. Without going too much into detail, Search Guard in particular needs to know wether a request comes from a trusted node in the cluster (server node), or from a client (non-server node). 

Server nodes are identified by having a special [Subject Alternative Name entry (SAN)](https://github.com/floragunncom/search-guard-ssl/blob/master/example-pki-scripts/gen_node_cert.sh) in their certificate:

* ``oid:1.2.3.4.5.5``

Please see the section [Certificates section in the installation chapter](installation.md) for further information and especially read it before you generate the TLS certificates for your Elasticsearch installation. 

If you use the example PKI scripts shipped with Search Guard SSL, like `example.sh` or `gen_server_node.sh`, the SAN entry is already set correctly.

The SAN entry is only needed for Search Guard. If you just run Search Guard SSL, no specific SAN entries are necessary.
