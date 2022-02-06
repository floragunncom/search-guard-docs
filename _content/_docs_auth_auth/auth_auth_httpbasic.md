---
title: Password-based Authentication
permalink: http-basic-authorization
category: authauth
order: 200
layout: docs
edition: community
description: How to set up HTTP Basic Authentication on the REST layer of OpenSearch/Elasticsearch with Search Guard.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Password-based authentication
{: .no_toc}

If you want to use a user name and password to log into OpenSearch/Elasticsearch, you need to use the `basic` authentication frontend combined with an authentication backend.

The simplest setup uses the Search Guard internal user database as the authentication backend; for this, you just have to define the users. No further configuration is necessary. See below for more details on this.

If you want to use Active Directory/LDAP for authenticating users, you can use the `ldap` authentication backend. This requires a bit more configuration; see the [LDAP and Active Directory docs](../_docs_auth_auth/auth_auth_ldap.md) for more information.

**Note:** Users of older Search Guard versions might know the `challenge` flag which controls whether Search Guards sends HTTP Basic challenges for unauthenticated requests. The new version of Search Guard is capable of sending multiple challenges at once. Thus, this flag is no longer needed.

## Internal users database

The minimal `sg_authc.yml` configuration for using Search Guard with the internal users database looks like this:

```yaml
auth_domains:
- type: basic/internal_users_db
```

Additionally, you need to add users to the internal user database. See [here](../_docs_roles_permissions/configuration_internalusers.md) for more details on this.

Users authenticated via the internal users database automatically have the roles that are associated with them in the database (both backend roles and Search Guard roles). 

### Attribute mapping

If you want to use user-attribute-based authorization (TODO: link), you have to define an attribute mapping. This mapping maps the attributes stored in the internal user database to the attributes the logged-in user will have.  Suppose users in the internal user database are defined like this:

```yaml
hr_employee:
  [...]
  attributes:
    manager: "layne.burton"
    department: 
      name: "operations"
      number: 52
```

The `internal_users_db` makes the attributes available for mapping below the key `user_entry.attributes`. Thus, you can map the attribute `department.number` like this:

```yaml
auth_domains:
- type: basic/internal_users_db
  user_mapping.attributes.from:
    dept_no: user_entry.attributes.department.number
```
