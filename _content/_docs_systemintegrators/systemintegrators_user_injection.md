---
title: Injecting Search Guard users
html_title: Injecting users
slug: search-guard-oem-user-injection
category: systemintegrators
order: 400
layout: docs
edition: community
description: How to integrate Search Guard with other products and plugins to inject a Search Guard user directly
---
<!---
Copyright 2020 floragunn GmbH
-->

# Injecting a Search Guard user

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
backend_roles: ["role1", "role2"],
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
backend_roles: ["role1", "role2"],
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
backend_roles: [],
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

Due to security concerns, this is only possible for injected users. You cannot assign admin privileges for regular users. Use an admin TLS certificate instead.
{: .note .js-note .note-warning}

You can also mix admin access granted by a TLS certificate and admin access for injected users:

```
searchguard.authcz.admin_dn:
  - injectedadmin
  - CN=kirk,OU=client,O=client,L=Test,C=DE"
```

Any entry that is not a DN will be treated as usernames, whereas DNs are applied to admin certificates.
