---
title: User Impersonation
html_title: User Impersonation
slug: user-impersonation
category: rolespermissions
order: 700
layout: docs
edition: community
description: How to use the Search Guard User Impersonation feature to submit requests on behalf of another user.
resources:
  - "https://search-guard.com/elasticsearch-user-impersonation/|User Impersonation: Submit requests on behalf of another user (blog post)"

---

<!---
Copyright 2018 floragunn GmbH
-->

# User Impersonation
{: .no_toc}

{% include_relative _includes/toc.md %}

The Search Guard user impersonation feature lets you submit requests on behalf of another user. It means that a user can log in with his or her credentials, and then impersonate as another user, without having to know this users username or password.

For example, this can be useful when an admin needs to debug permission problems for a particular user. 

In order for user impersonation to work, you must be able to retrieve the user from one of the configured authentication backends. The Active Directory/LDAP and the Internal Users authentication backend support impersonation out of the box.

If you use a custom authentication backend, make sure you to implement the `AuthenticationBackend#exists(User user)` method correctly:

```java
/**
* 
* Lookup for a specific user in the authentication backend
* 
* @param user The user for which the authentication backend should be queried
* @return true if the user exists in the authentication backend, false otherwise
*/
boolean exists(User user);
```

## Permission settings

To give a user permission to impersonate as another user, 

```
searchguard.authcz.rest_impersonation_user.<allowed_user>:
  - <impersonated_user_1>
  - <impersonated_user_2>
  - ...
```

For example:

```
searchguard.authcz.rest_impersonation_user.admin:
  - user_1
  - user_2
```

In this example, the user `admin` has the permission to impersonate as user `user_1` and `user_2`. Wildcards are supported, so the following snippet grants the user `admin` the permission to impersonate as any user that starts with `user_`.

```
searchguard.authcz.rest_impersonation_user.admin:
  - user_*
```

## Using impersonation on the REST layer

To impersonate as another user, specify the username in the `sg_impersonate_as` HTTP header of the REST call, for example:

```
curl -u admin:password  \
  -H "sg_impersonate_as: user_1"  \
  -XGET https://example.com:9200/_searchguard/authinfo?pretty
```

## Effects on audit- and compliance logging

When using impersonation, the audit and compliance events will track both the initiating user and the impersonated user:

| Name | Description |
|---|---|
| audit\_request\_initiating\_user | The user that initiated the request |
|audit\_request\_effective\_user | The impersonated user |
