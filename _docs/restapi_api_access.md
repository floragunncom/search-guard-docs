---
title: Access Control
slug: rest-api-access-control
category: restapi
order: 100
layout: docs
edition: enterprise
description: Configure role-based access control to different endpoints and methods of the REST API.
---
<!---
Copryight 2017 floragunn GmbH
-->

# REST management API
{: .no_toc}

{% include_relative _includes/toc.md %}

This module adds the capability of managing users, roles, roles mapping and action groups via a REST Api. It is required if you plan to use the Kibana config GUI.

## Access control

Since the REST management API makes it possible to change users, roles and permissions, access to this functionality is restricted by Search Guard. Access is granted either by a user's role or by providing an admin certificate.

## Role-based access control

All roles that should have access to the API must be configured in `elasticsearch.yml` with the following key:

```yaml
searchguard.restapi.roles_enabled: ["sg_all_access", ...]
```

This will grant full access permission to the REST API for all users that have the Search Guard role `sg_all_access`.

You can further limit access to certain API endpoints and methods on a per role basis. For example, you can give a user permission to retrieve role information, but not to change or delete it.

The structure of the respective configuration is:

```yaml
searchguard.restapi.endpoints_disabled.<role>.<endpoint>: ["<method>",...]
```

For example:

```yaml
searchguard.restapi.endpoints_disabled.sg_all_access.ROLES: ["PUT", "POST", "DELETE"]
```

Possible values for endpoint are:

```
ACTIONGROUPS
ROLES
ROLESMAPPING
INTERNALUSERS
SGCONFIG
CACHE
LICENSE
SYSTEMINFO
```

Possible values for then method are:

```
GET
PUT
POST
DELETE
```

You can also disable endpoints and methods for all users by using `global` as role name:

```yaml
searchguard.restapi.endpoints_disabled.global.<endpoint>: ["<method>",...]
```

## Admin certificate access control

Access can also be granted by using an admin certificate. This is the same certificate that you use when executing [sgadmin](sgadmin.md).

In order for Search Guard to pick up this certificate on the REST layer, you need to set the `clientauth_mode` in `elasticsearch.yml` to either `OPTIONAL` or `REQUIRE`:

```yaml
searchguard.ssl.http.clientauth_mode: OPTIONAL
```

For curl, you need to specify the admin certificate with it's complete certificate chain, and also the key:

```bash
curl --insecure --cert chain.pem --key kirk.key.pem "<API Endpoint>"
```

If you use the example PKI scripts provided by Search Guard SSL, the `kirk.key.pem` is already generated for you. You can generate the chain file by `cat`ing the certificate and the ca chain file:

```bash
cd search-guard-sll
cat example-pki-scripts/kirk.crt.pem example-pki-scripts/ca/chain-ca.pem > chain.pem
```

## Reserved resources

You can mark any user, role, action group or roles mapping as `readonly` in their respective configuration files. Resources that have this flag set to true can not be changed via the REST API and are marked as `reserved` in the Kibana Configuration GUI.

You can use this feature to give users or customers permission to add and edit their own users and roles, while making sure your own built-in resources are left untouched. For example, it makes sense to mark the Kibana server user as `readonly`.

To mark a resource `readonly`, add the following flag:

```yaml
sg_kibana_user:
  readonly: true
  ...
```

## Hidden resources

Any resource can be marked *hidden*. As the name implies, a hidden resource

* is removed from any API GET request result
  * when querying for a single hidden resource, a `404` is returned
  * when querying for all resources, hidden resources are filtered from the result set
* cannot be deleted
  * a `404` is returned instead
* cannot be changed
  * a `403` is returned instead 

Hidden resources are most useful if you want to give end users access to the REST API, but you want to hide some of the service users your platform is using. For example, the Kibana server user or the logstash user.

Example:

```yaml
sg_kibana_server:
  hidden: true
  ...
```  

## Fixing curl issues

If you experience problems with curl commands see [Fixing curl](../_troubleshooting/tls_troubleshooting.md#fixing-curl) first before reporting any issues.
