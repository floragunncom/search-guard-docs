<!---
Copryight 2016 floragunn GmbH
-->

# Overview

Search Guard can be used to secure your Elasticsearch cluster by working with different industry standard authentication techniques, like Kerberos, clientcert, jwt, TLS certificate, JSON web tokens, proxy, and LDAP. 

Regardless of what authentication technique you select, the basic flow is as follows:

* A user wants to **access** an Elasticsearch cluster, such as issuing simple queries to changing the cluster topology.
* Search Guard retrieves the user's **credentials**.
 * The authentication mechanism challenges (prompts) the user for a username and password. Or it can be extracted directly from the request HTTP headers, which could be Basic Authentication, JSON web token, or SPNEGO/Kerberos. 
* Search Guard **authenticates** the credentials against the authentication backend.  
 * This step is optional.  If you use TLS client or proxy authentication, Search Guard uses the DN of a TLS certificate for authentication.
* Search Guard **authorizes** the user by retrieving a list of user roles.
 * Roles retrieved in this step are called **backend roles**. Roles are optional. 
* Search Guard **maps** the user and backend roles to **internal Search Guard roles**.
 * Often this mapping is one-for-one, like "all".  But more likely you want to define specific roles for specific ES use cases.
* Search Guard determines the **permissions** associated with the internal Search Guard role and decides whether the action the user wants to perform is allowed or not.
 * If your are using document- and field-level-security, you can also apply more fine grained permissions based on document types and individual fields.  

## Credentials

In order to **identify** the user who wants to interact with the cluster, Search Guard first needs the user's **credentials**. 

What the term credential means depends on the technology you use for user identification. For example, if you use HTTP basic auth, then the credentials are username and password.

If you use TLS certificates for identifying clients, then the credentials are included in the certificate.

An credential provider can either be **challenging** or **non-challenging**. A challenging provider actively asks the user for his or her credentials (e.g. HTTP basic auth). A non-challenging authenticator extracts the user credentials from some other source (e.g. TLS certificate) without the need for user interaction.

## Authentication (authc)

Search Guard then **authenticates** the credentials **against a backend authentication module**. This step is performed by an **Authenticator**.  

There needs to be at least one authenticator configured. If not, an implicit one will be created. This will authenticate the credentials against the internal user database and use HTTP Basic Authentication.

You can define more than one authenticator if needed, but in most cases you will have just one.

### External authentication / SSO

Search Guard also supports external authentication and Single Sign On (SSO) solutions. In most cases, these systems act as a proxy or store authentication information in HTTP header fields. Search Guard provides an HTTP proxy authenticator, which can read and interpret these fields. In that case, Search Guard has to **trust the external authentication system** to work correctly. This is explained below.

## Authorisation (authz)

After an authenticator has **verified** a user's **credentials**, an (optional) authorisation module can collect additional roles for the authenticated user from a configured backend. 

These roles are called **backend roles**.

## Users and roles

After the user is verified and roles have been retrieved, Search Guard will **map** the **user and any backend roles** to **Search Guard roles**. 

In some cases you want to map the backend roles 1:1 to Search Guard roles, but more often than not you want to have differing roles for granular control over Elasticsearch.

## Permissions

On a high level, each interaction with Elasticsearch means that a particular **user** wants to **execute** an **action** on an Elasticsearch **cluster** or **one ore more indices**. This closely resembles the internal model of Elasticsearch.

Permissions in Search Guard are based on exactly this model. A permission defines:

* which role,
* can perform which action,
* against wich cluster or index.

A definition of a permission that allows searching a particular index looks like:

* `indices:data/read/search*`

Permissions are defined per role and can be applied on a cluster or index level.

## Action groups

The action model of Elasticsearch, and thus the permission model of Search Guard, allows for very fine grained settings. This can lead to long lists of permission settings that you need to repeat for several roles.

So you can use **action groups** in order to avoid repeating permission definitions. An action group is an **alias for a set of permissions**. Action groups can also be **nested**. 

If you define action groups, you can use the name of the action groups in the permission settings configuration.

For example, the following snippet shows two action groups, where the `SUGGEST` action group is referenced by the `SEARCH` action group:

```
SEARCH:
  - "indices:data/read/search*"
  - "indices:data/read/msearch*"
  - SUGGEST
SUGGEST:
  - "indices:data/read/suggest*"
```

## Configuration settings: The Search Guard index

All configuration settings for Search Guard, such as users, roles and permissions, are stored as documents in a special Search Guard index. This index is secured so that only an admin user with a special SSL certificate may write or read this index. You define one or more of these certificates, called **admin certificates**, [defined here](https://github.com/werowe/search-guard-docs/blob/master/tls_overview.md).

Keeping the configuration settings in an Elasticsearch index enables hot config reloading. This means that you can **change any of the user, role and permission settings at runtime, without restarting your nodes**. Configuration changes will **take affect immediately**. You can load and **change the settings from any machine** which has access to your Elasticsearch cluster. 

**This also means that you do not need to keep any configuration files on the nodes themselves.** No more dealing with configuration files on different servers!

The configuration consists of the following files. These are shipped with Search Guard as templates.

* sg\_config.yml—configure authenticators and authorisation backends.
* sg\_roles.yml—define roles and the associated permissions.
* sg\_roles\_mapping.yml—map backend roles, hosts and users to roles.
* sg\_internal\_users.yml—stores user and hashed passwords (hash with hasher.sh) is using the internal user database.
* sg\_action\_groups.yml—group permissions.

Configuration settings are applied by pushing the content of one or more configuration files to the Search Guard secured cluster. To do this, use the `sgadmin` tool. For details, refer to the chapter [sgadmin](sgadmin.md). Please pay also attention to the shared and replica settings, since you want to make sure that the Search Guard index is available on all nodes.
