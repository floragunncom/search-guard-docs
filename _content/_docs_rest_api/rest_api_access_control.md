---
title: Access Control
permalink: rest-api-access-control
layout: docs
edition: enterprise
description: Configure role-based access control to different endpoints and methods
  of the REST API.
---
<!---
Copyright 2022 floragunn GmbH
-->

# REST management API
{: .no_toc}

{% include toc.md %}

This module adds the capability of managing users, roles, roles mapping and action groups via a REST Api. It is required if you plan to use the Kibana config GUI.

## Access control

Since the REST management API makes it possible to change users, roles and permissions, access to this functionality is restricted by Search Guard. Access is granted either by a user's role or by providing an admin certificate.

## Role-based access control

All roles that should have access to the API must be configured in `elasticsearch.yml` with the following key:

```yaml
searchguard.restapi.roles_enabled: ["SGS_ALL_ACCESS", ...]
```

This will grant full access permission to the REST API for all users that have the Search Guard role `SGS_ALL_ACCESS`.

You can further limit access to certain API endpoints and methods on a per role basis. For example, you can give a user permission to retrieve role information, but not to change or delete it.

The structure of the respective configuration is:

```yaml
searchguard.restapi.endpoints_disabled.<role>.<endpoint>: ["<method>",...]
```

For example:

```yaml
searchguard.restapi.endpoints_disabled.SGS_ALL_ACCESS.ROLES: ["PUT", "POST", "DELETE"]
```

Possible values for endpoint are:

```
ACTIONGROUPS
ROLES
ROLESMAPPING
INTERNALUSERS
TENANTS
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

Access can also be granted by using an admin certificate. This is the same certificate that you use when executing [sgctl](sgctl-configuration-changes).

In order for Search Guard to pick up this certificate on the REST layer, you need to set the `clientauth_mode` in `elasticsearch.yml` to either `OPTIONAL` or `REQUIRE`:

```yaml
searchguard.ssl.http.clientauth_mode: OPTIONAL
```

For curl, you need to specify the admin certificate with its complete certificate chain, and also the key:

```bash
curl --insecure --cert chain.pem --key kirk.key.pem "<API Endpoint>"
```

If you use the example PKI scripts provided by Search Guard SSL, the `kirk.key.pem` is already generated for you. You can generate the chain file by `cat`ing the certificate and the ca chain file:

```bash
cd search-guard-sll
cat example-pki-scripts/kirk.crt.pem example-pki-scripts/ca/chain-ca.pem > chain.pem
```

## Fixing curl issues

If you experience problems with curl commands see [Fixing curl](troubleshooting-tls#fixing-curl) first before reporting any issues.
