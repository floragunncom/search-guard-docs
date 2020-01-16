---
title: Demo users and roles
html_title: Demo users and role
slug: demo-users-roles
category: rolespermissions
order: 50
layout: docs
edition: community
description: Description of the demo users and roles Search Guard ships with. Use them as blueprint for your own permission schema.
---
<!---
Copyright 2019 floragunn GmbH
-->
# Demo users and roles
{: .no_toc}

{% include toc.md %}

Search Guard ships with a demo configuration that contains users and roles for a variety of use cases. You can use these users and roles as a blueprint for your own permission schema.

## Demo users

Search Guard ships with the following demo users:

| Username | Password | Description |
|---|---|---|
| admin | admin | Full access to the cluster and all indices, but no access to the Search Guard configuration. Use an admin certificate for that. |
| kibanaserver | kibanaserver | Internal Kibana server user, for configuring `elasticsearch.username` and `elasticsearch.password` in `kibana.yml`. Has all permissions on the `.kibana` index. |
| kibanaro | kibanaro | Regular Kibana user, has `SGS_READ` access to all indices and all permissions on the `.kibana` index. |
| logstash | logstash | Logstash and Beats user, has `SGS_CRUD` and `SGS_CREATE_INDEX` permissions on all logstash and beats indices |
| readall | readall | Has read access to all indices |
| snapshotrestore | snapshotrestore | Has permissions to perform snapshot and restore operations |
{: .config-table}

**Note:** By default, all users are mapped to the `SGS_OWN_INDEX` role. You can remove this mapping by deleting the following lines from `sg_roles_mapping.yml`:

```yaml
SGS_OWN_INDEX:
  reserved: false
  hidden: false
  users:
  - "*"
  description: "Allow full access to an index named like the username"
```

