---
title: Demo users and roles
html_title: Demo users and role
slug: demo-users-roles
category: rolespermissions
order: 400
layout: docs
description: Description of the demo users and roles Search Guard ships with. Use them as blueprint for your own permission schema.
---
<!---
Copryight 2017 floragunn GmbH
-->
# Demo users and roles

Search Guard ships with a demo configuration that contains users and roles for a variety of use cases. You can use these users and roles as a blueprint for your own permission schema.

## Demo users

Search Guard ships with the following demo users:

| Username | Password | Description |
|---|---|---|
| admin | admin | Full access to the cluster and all indices, but no access to the Search Guard configuration. Use an admin certificate for that. |
| kibanaserver | kibanaserver | Internal Kibana server user, for configuring `elasticsearch.username` and `elasticsearch.password` in `kibana.yml`. Has all permissions on the `.kibana` index. |
| kibanaro | kibanaro | Regular Kibana user, has `READ` access to all indices and   all permissions on the `.kibana` index. |
| logstash | logstash | Logstash and Beats user, has `CRUD` and `CREATE_INDEX`  permissions on all logstash and beats indices |
| readall | readall | Has read access to all indices |
| snapshotrestore | snapshotrestore | Has permissions to perform snapshot and restore operations |

## Demo roles

Search Guard ships with the following demo roles:

| Role name | Description |
|---|---|
| sg\_all\_access | All cluster permissions and all index permissions on all indices |
| sg\_readall | Read permissions on all indices, but no write permissions |
| sg\_readonly\_and\_monitor | Read and monitor permissions on all indices, but no write permissions |
| sg\_kibana\_server | Role for the internal Kibana server user, please refer to the [Kibana setup](kibana_installation.md) chapter for explanation |
| sg\_kibana\_user | Minimum permission set for regular Kibana users. In addition to this role, you need to also grant READ permissions on indices the user should be able to access in Kibana.|
| sg\_logstash | Role for logstash and beats users, grants full access to all logstash and beats indices. |
| sg\_manage\_snapshots | Grants full permissions on snapshot, restore and repositories operations |
| sg\_own\_index | Grants full permissions on an index named after the authenticated user's username. |
| sg\_xp\_monitoring | Role for X-Pack Monitoring. Users who wish to use X-Pack Monitoring need this role in addition to the sg\_kibana\_user role |
| sg\_xp\_alerting | Role for X-Pack Alerting. Users who wish to use X-Pack Alerting need this role in addition to the sg\_kibana role |
| sg\_xp\_machine\_learning | Role for X-Pack Machine Learning. Users who wish to use X-Pack Machine Learning need this role in addition to the sg\_kibana role |

**Note:** By default, all users are mapped to the roles `sg_public` and `sg_own_index`. You can remove this mapping by deleting the following lines from `sg_roles_mapping.yml`:

```yaml
sg_public:
  users:
    - '*'

sg_own_index:
  users:
    - '*'
```

