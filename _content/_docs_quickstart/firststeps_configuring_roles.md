---
title: Configuring roles and permissions
html_title: Configuring roles
permalink: first-steps-roles-configuration
category: first_steps
order: 200
layout: docs
description: How to configure Search Guard roles to control access to indices, documents and fields.
resources:
  - roles-permissions|Roles and permissions (docs)  
  - action-groups|Action groups (docs)  
  - sgadmin|Using sgadmin (docs)  

---

<!--- Copyright 2020 floragunn GmbH-->

# Configuring roles and permissions
{: .no_toc}

{% include toc.md %}

This guide assumes that you have already installed Search Guard in your cluster using the [demo installer](demo-installer).
{: .note .js-note .note-info}

## Configuring roles and permissions

Search Guard roles define what access permissions a user with this role has. This includes

* Permissions on the cluster level (Community)
  * e.g. accessing the cluster health 
* Permissions on index level (Community)
  * e.g. if a user has read permissions for a dedicated index
* Permissions on document level (Enterprise)
  * e.g. what documents a user is allowed to see
* Permissions on field level (Enterprise)
  * e.g. what fields in documents a user is allowed to see

As with users, you can configure roles by using `sgctl`, the [REST API](rest-api-internalusers) or the [Search Guard Config GUI](configuration-gui).
     
Users are assigned to Search Guard roles by using the roles mapping. We will first define our roles, and then map users to them in the next chapter.
     
## Structure of a role definition

As with internal users, you define Search Guard roles in the `sg_roles.yml` file:

```
<ES installation directory>/plugins/search-guard-7/sgconfig/sg_roles.yml
```

After that you upload this file to the cluster by using the sgadmin command line tool for the configuration changes to become effective. 

The basic structure of a role looks like:

```
<rolename>:
  cluster_permissions:
    - <cluster permission>
  index_permissions:
    - index_patterns:
      - <index pattern>
      allowed_actions:
        - <index permissions>
```

Search Guard ships with built-in sets of actions ("action groups") which cover the most common use cases:

[Search Guard action groups](action-groups#built-in-action-groups)

We will use those action groups to assign access permissions to our indices.

## Configuring Search Guard roles

In this example, we want to create two roles:

* sg\_human\_resources:
  * Grants read-only access to an index `humanresources` 
* sg\_devops:
  * Grants read and write access to an index `infrastructure`
  * Grants read-only access to all indices starting with `logs-`

The role definitions look like:

**sg\_human\_resources**

```
sg_human_resources:
  cluster_permissions:
    - "SGS_CLUSTER_COMPOSITE_OPS"
  index_permissions:
    - index_patterns:
      - "humanresources"
      allowed_actions:
        - "SGS_READ"
```  

Here we applied the default `SGS_CLUSTER_COMPOSITE_OPS` on cluster level, and granted `SGS_READ` permissions to the index `humanresources`. If a user has only this role, then no index other than `humanresources` is accessible.

The **index name(s) can also contain regular expressions and wildcards**, which we will use in the second role:

**sg\_devops**
  
```
sg_devops:
  cluster_permissions:
    - "SGS_CLUSTER_COMPOSITE_OPS"
  index_permissions:
    - index_patterns:
      - "infrastructure"
      allowed_actions:
        - SGS_READ
        - SGS_WRITE
    - index_patterns:
      - "logs-*"
      allowed_actions:
        - SGS_READ
```  

This role grants read and write permissions to the `infrastructure` index, and read-only access to all indices starting with `logs-`. The latter can for example be used for date-based indices, like daily rolling log data indices. 

## Uploading configuration changes

In order to activate the changed configuration, we need to upload it to the Search Guard configuration index by using the `sgctl` command line tool:

```
./sgctl.sh update-config /path/to/changed/sg_roles.yml
```

