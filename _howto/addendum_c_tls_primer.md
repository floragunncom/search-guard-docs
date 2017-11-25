<!---
Copryight 2017 floragunn UG (haftungsbeschränkt)
-->

## Reasons for using TLS

While Elasticsearch is often used for storing and searching sensitive data, it does not offer encryption or authentication/authorization out of the box.

In order to secure your sensitive data, the first step is to encrypt the entire traffic from and to your ES cluster via TLS.

By using TLS, the traffic between ES nodes and ES clients will be encrypted, which means that:

* Nobody can spy on the traffic.
* Nobody can tamper with the traffic.
* Only trusted nodes can join your cluster.

Search Guard supports OpenSSL for improved performance and the most modern cipher suites.

## TLS in a nutshell

TLS (aka SSLv3) is a cryptographic protocol to secure the communication over a computer network. It uses **symmetric encryption** to encrypt the transmitted data, by negotiating a **unique secret** at the start of any **TLS session** between two participating parties. It uses **public key cryptography** to authenticate the identity of the participating parties.

TLS supports different ways to exchange keys and encrypt data. 

### Certificates & Certificate authorities

TLS uses certificates ("digital certificates") for encrypting traffic and for identifying and authenticating the two parties in a TLS session. 

To be more precise, 
> a digital certificate certifies the ownership of a public key by the common name in the certificate. 
(Source: [Wikipedia](https://en.wikipedia.org/wiki/Transport_Layer_Security#Digital_certificates)).

The public key is then used for the actual encryption.

#### Trust Hierarchies

A certificate can be used to issue and sign other certificates, building a trust hierarchy among these certificates. The certificates can be **intermediate root certificates** or **end entity certificates**.

A **root certificate**, issued by a **root certificate authority (root CA)**, is at the root of this hierarchy. A certificate authority represents a **trusted third party** authority, trusted both by the owner of the certificate and communication partner. All major browser come with a pre-installed list of trusted certificate authorities, like Thawte, GlobalSign, DigiCert and Comodo.

A root CA uses its own certificate to issue other certificates. An intermediate root certificate can be used to issue other certificates, while an end entity certificate is intended to be installed directly on a server. With an end entity certificate do you not to sign other certificates.

To establish a TLS session, all certificates in the hierarchy are verified, up to the root certificate. The communication partner is only trusted if each certificate in this chain is trusted.

### SSL handshake

Before any user data is sent between these parties, first a **TLS session** has to be established. This process is called **TLS handshake**.

The details of this handshake can vary slighty, depending on the selected cipher suite. At a high level the following steps are performed:

* The client sends a ClientHello message containing the information which TLS version and cipher protocols it supports.
* The server sends a ServerHello message containing the chosen protocol version and cipher suite.
* The server sends its certificate containing the public key.
* The client verifies the certificate and all intermediate certificates against its list of installed root CAs.
* If the client cannot verify the certificate, it aborts the connection or displays a warning, depending on the client and settings.
* If the certificate can be verified, the client sends a "PreMasterSecret" to compute a common secret, called the "master secret". This master secret is used for encrypting the traffic. The PreMasterSecret is encrypted using the public key of the server certificate.
* The server tries to decrypt the clients message using its private key. If this fails, the handshake is considered failed.
* If decryption succeeds, the handshake is complete, and all traffic is encrypted using the master secret.

While at this point the server's identity is verified, the client's identity is not, since it never sent any information regarding its own identity. But this is possible too.  It's called **Client Authentication** (aka **Mutual authentication** or **two-way authentication**) and is an optional part of the handshake protocol. If the server is configured to use client authentication, the following steps are added in the handshake:

* The server sends a CertificateRequest message to the client.
* The client sends its own certificate, containing the clients public key, to the server.
* The server verifies the certificate using its own installed list of root CAs and intermediate CA.
* If thus succeeds, the connection is mutually authenticated.

Note that this is a simplified explanation of the handshake protocol to demonstrate the basic principles. In short: the handshake protocol uses a combination of certificates and public/private keys to verify the identities of the communication partners and to negotiate a master secret for encrypting the traffic.

### Keystore and Truststore

Java uses **keystores** and a **truststores** to store certificates and private keys. The truststore contains all trusted certificates, typically root CAs and intermediate certificates. It is used to **verify credentials** from a communication partner.

The **keystore** holds the private keys and the associated certificates. It is used to **provide credentials** to the communication partner.

Search Guard supports two key and truststore formats: JKS and PKCS12. In addition, certificates in PEM format are also supported since v12.

In a typical Search Guard setup, each node in the cluster has both a keystore and a truststore. If a node wants to communicate with another node, it uses its own certificate stored in the keystore to identify itself.

The other node uses the root CA stored in the truststore to verify the other node's certificate.

This, of course, is run in both directions because a node acts as a "client" and "server" at the same time: it sends requests to other nodes, acting as a client, and receives requests, acting as a server.

## Minimal setup

A minimal Search Guard regarding TLS setup might look like this:

### Root CA

You need a root CA in order to create the required certificates for the nodes. If you already have a PKI infrastructure in place, you're good to go. Otherwise, you need to create a root CA first.

### Generate certificates

Using the root CA, you then generate certificates for all participating nodes (and optionally clients, if you use client authentication) in your setup. These certificates are signed with your root certificate

### Generate keystore and truststore files

For each node, you create a keystore and a truststore file. The keystore contains the nodes own certificate, while the truststore contains the root CA. The truststore can be the same on all nodes, while the keystore should be different, since each node should have its own, exclusive certificate
