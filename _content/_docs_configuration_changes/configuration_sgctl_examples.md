---
title: Examples
permalink: sgctl-examples
category: sgctl
order: 100
layout: docs
edition: community
index: false
description: Examples for sgctl command line tool
---
<!---
Copyright 2022 floragunn GmbH
-->

# Using `sgctl` to Configure Search Guard
{: .no_toc}

{% include toc.md %}

## Adding users to internal user database

```
./sgctl.sh add-user xxw \
    --password \
    --sg-roles=sg_role1,sg_role2 \
    --attributes=attribute1=value1,attribute2=value2 \
    --backend-roles=backend_role_1,backend_role_1
```
You will be prompted for a password.

To specify password on the command line use:

```
./sgctl.sh add-user xxw \
    --password=mypassword123 \
    --sg-roles=sg_role1,sg_role2 \
    --attributes=attribute1=value1,attribute2=value2 \
    --backend-roles=backend_role_1,backend_role_1
```

## Modifying Search Guard configuration on the fly

Sometimes you need to modify only a single attribute of the Search Guard configuration. If you want to do so without editing files, you can use the `sgctl set` command.

A sample command looks like this:

```
./sgctl.sh set authc auth_domains.1.type "basic/ldap"
```
