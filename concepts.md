<!---
Copryight 2016 floragunn GmbH
-->

# Search Guard Main Concepts

Search Guard can be used to secure your Elasticsearch cluster by using a wide range of technologies. While this offers great flexibility, it also means that you should familiarize yourself with all the basic concepts behind Search Guard, so you can choose and configure it according to your needs.

However, there is a basic pattern of steps that Search Guard executes when deciding if a user is allowed to perform a specific action or not. Depending on the chosen technologies, some of the steps are optional. The basic flow is as follows

* A user wants to **interact** with an Elasticsearch cluster
 *  this means any kind of interaction, ranging from issuing simple queries to changing the cluster topology
* Search Guard retrieves the **credentials** of the user
 * This can be achieved by explicitly asking (challenging) the user to provide this information, or it can be extracted directly from the request. Credentials can be something like a username/password combination, but also a hostname or the DN of a TLS certificate.
* Search Guard **authenticates** the credentials against an authentication backend.
 * This step is optional if you use for TLS client or proxy authentication.
* Search Guard **authorizes** the user by retrieving a list of roles for the user
 * Roles retrieved in this step are called **backend roles**, for they are retrieved from a backend system. This step is optional. 
* Search Guard **maps** the user and her backend roles to **internal Search Guard roles**
 * sometimes this mapping resembles the backend roles 1:1, but more often than not you want to define dedicated roles for your specific ES use case.
* Search Guard determines the **permissions** associated with the internal Search Guard role, and decides whether the action the user wants to perform is allowed or not
 * If your are using document- and field-level-security, you can also apply more fine grained permissions based on document types and individual fields  

## Credentials

In order to **identify** the user who wants to interact with the cluster, Search Guard first needs the users **credentials**. 

What the term credential means depends on the technology you use for user identification. For example, if you use HTTP basic auth, then the credentials are the username/password combination the user provides.

If you use TLS certificates for identifying clients, then the credentials are already included in the certificate.

An credential provider can either be **challenging** or **non-challenging**. A challenging provider actively asks the user for its credentials (e.g. HTTP basic auth). A non-challenging authenticator extracts the user credentials from some other source (e.g. TLS certificate) without the need for user interaction.

## Authentication (authc)

Search Guard then **authenticates** the credentials **against a backend authentication module**. This step is performed by a so called **Authenticator**. Authenticators can be very diverse regarding their principles and inner workings, but they always verify if provided credentials are correct. 

In order for Search Guard to work, there has to be at least one authenticator configured. If this is not the case, an implicit one will be created. This will authenticate the credentials against the internal user database and use HTTP Basic as the credentials provider.

You can define more than one authenticator if necessary, but in most cased you will have exactly one authenticator talking to one authentication backend.

### External authentication / SSO

Search Guard also supports external authentication / Single Sign On solutions. In most cases, these systems act as a proxy and/or store authentication information in special HTTP header fields. Search Guard provides an HTTP proxy authenticator, which can read and interpret these fields. In that case, Search Guard has to **trust the external authentication system** to work correctly. 

## Authorisation (authz)

After an authenticator has **verified** a user's **credentials**, an (optional) authorisation module can collect additional roles for the authenticated user from a configured backend. 

These roles are called **backend roles**.

## Users and roles

After the user is verified and roles have been fetched, Search Guard will **map** the **user and any backend roles** the user has to **Search Guard roles**. 

In some cases you want to map the backend roles 1:1 to Search Guard roles, but more often than not you want to have a dedicated users- and roles schema for your Elasticsearch installation.

The mapping between backend roles / users and Search Guard roles is an n:m mapping.

## Permissions

On a high level, each interaction with Elasticsearch means that a particular **user** wants to **execute** an **action** on an Elasticsearch **cluster** or **one ore more indices**. This closely resembles the internal model of Elasticsearch.

Permissions in Search Guard are based on exactly this model. A permission defines

* which role
* can perform which action
* against wich cluster or index

A definition of a permission that allows searching a particular index looks like:

* `indices:data/read/search*`

Permissions are defined per role can be applied on cluster- and index-level.

## Action groups

The action model of Elasticsearch, and thus the permission model of Search Guard, allows for very fine grained settings. This can lead to long lists of permission settings that you need to repeat for several roles.

You can use **action groups** in order to save you from repeating permission definitions. An action group is an **alias for a set of permissions**. Action groups can also be **nested**. 

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

All configuration settings for Search Guard, such as users, roles and permissions, are stored as documents in a special Search Guard index. This index is specially secured so that only an admin user with a special SSL certificate may write or read this index. You can define one or more of these certificates, which we'll call **admin certificates**.

Keeping the configuration settings in an Elasticsearch index enables hot config reloading. This means that you can **change any of the user-, role- and permission settings at runtime , without restarting your nodes**. Configuration changes will **take effect nearly immediately**. You can load and **change the settings from any machine** which has access to your Elasticsearch cluster. 

**This also means that you do not need to keep any configuration files on the nodes themselves.** No more dealing with configuration files on different servers!

The configuration consists of the following files. These are shipped with Search Guard, and you can use them as templates for your own configuration settings:

* sg\_config.yml
  * Configure authenticators and authorisation backends
* sg\_roles.yml
  * define the roles and the associated permissions
* sg\_roles\_mapping.yml
  * map backend roles, hosts and users to roles
* sg\_internal\_users.yml
  * user and hashed passwords (hash with hasher.sh), used for the internal user database
* sg\_action\_groups.yml
  * group permissions together

Configuration settings are applied by pushing the content of one or more configuration files to the Search Guard secured cluster. To do so, use the `sgadmin` tool that ships with Search Guard. For details, refer to the chapter [sgadmin](sgadmin.md). Please pay also attention to the shard and replica settings, since you want to make sure that the Search Guard index is available on all nodes.
