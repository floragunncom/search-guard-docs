---
title: Mapping users to Search Guard roles
html_title: Roles mapping
slug: first-steps-mapping-users-roles
category: first_steps
order: 200
layout: docs
description: How to map users to Search Guard roles to assign cluster- and index-level access permissions.
resources:
  - mapping-users-roles|Mapping users to roles (docs)  
  - sgadmin|Using sgadmin (docs)  

---

<!--- Copyright 2019 floragunn GmbH -->

# Mapping users to Search Guard roles
{: .no_toc}

{% include toc.md %}

This guide assumes that you have already installed Search Guard in your cluster using the [demo installer](demo-installer).
{: .note .js-note .note-info}

## Roles mapping concept

In the last two chapters we created new Search Guard users and Search Guard roles.

As a next step, we need to connect the users with the Search Guard roles. This is where the roles mapping come into play. In order to map a user to a Search Guard role, you can use

* the username
* the user's backend roles
* the hostname or IP the request originated from (advanced)

The most flexible way is to use backend roles. Depending on what authentication method you use, backend roles can be:

* LDAP/Active Directory groups
* JWT claims
* SAML assertions
* Internal user database backend roles 

<p align="center">
<img src="rolemapping.png" style="width: 70%" class="md_image"/>
</p>

Since we leverage the internal user database in this example, we will use the  backend roles we configured in the first chapter.

## Recap: Backend roles of the users

In the first chapter of this guide we configured three users. Two of them have the backend role `hr_department` one has the backend role `devops `.

```
jdoe:
  hash: $2y$12$AwwN1fn0HDEw/LBCwWU0y.Ys6PoKBL5pR.WTYAIV92ld7tA8kozqa
  backend_roles:
    - hr_department

psmith:
  hash: $2y$12$YOVZhJ.gbZOAoGyd9YGNMuw7rWYTfB73n8OGBLtsrihMkW5rg5D1G
  backend_roles:
    - hr_department

cmaddock:
  hash: $2y$12$3UFikPXIZLoHcsDGD0hyqOvxjytdXeRkefIF1M58jA5oueSDKthzu
  backend_roles:
    - devops
```

We want to assign 

* all users that have the backend role `hr_department` to the Search Guard role `sg_human_resources`
* all users that have the backend role `devops` to the Search Guard role `sg_devops`

## Configuring the roles mapping

The mapping between users and Search Guard roles is configured in the `sg_roles_mapping.yml` file. The structure is straight-forward:

```
<Search Guard role name>:
  users:
    - <username>
    - ...
  backend_roles:
    - <rolename>
    - ...
  hosts:
    - <hostname>
    - ...
```

We use the backend roles of the users configured in `sg_internal_users.yml` and thus define like the roles mapping like:

```
sg_human_resources:
  backend_roles:
    - hr_department

sg_devops:
  backend_roles:
    - devops
```

This in effect maps the user `jdoe` and `psmith` to the Search Guard role `sg_human_resources` because they have the backend role `hr_department`.

And it maps the user `cmaddock` to the Search Guard role `sg_devops` because the user has the backend role `devops`.

<p align="center">
<img src="rolemapping.png" style="width: 70%" class="md_image"/>
</p>

## Uploading configuration changes

In order to activate the changed configuration, we need to upload it to the Search Guard configuration index by using the [`sgadmin.sh` command line tool](sgadmin). We will perform the [same steps as in the first chapter](first-steps-user-configuration).

