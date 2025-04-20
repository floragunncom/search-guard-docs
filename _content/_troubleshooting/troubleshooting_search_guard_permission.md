---
title: Permissions troubleshooting
html_title: Permissions help
permalink: troubleshooting-search-guard-permission
layout: docs
description: Step-by-step instructions on how to troubleshoot issues with Search Guard
  roles and permissions.
---
<!--- Copyright 2022 floragunn GmbH -->

# Roles and permissions troubleshooting

If a user has insufficient privileges to execute a particular request, or cannot be authenticated, Search Guard will print log statements on WARN level to the log file which help to identify the root cause. If this information is not enough to pinpoint the problem, please set the [Search Guard log level to debug](logging_troubleshooting.md).  

## Authentication issues

If a user cannot be authenticated by any configured authentication domains, Search Guard will log:

```
curl -Ss -k -u unauthenticated:unauthenticated -XGET "https://sgssl-0.example.com:9200/myindex/_search"
```

```
[c.f.s.a.BackendRegistry  ] Authentication finally failed for unauthenticated
```

This typically means that the user `unauthenticated` either does not exists, or the password is incorrect.


Please check

* that user exists in one of your configured authentication domains
  * for example, check that the user is present in sg\_internal\_users.yml, LDAP, Active Directory etc.
* that the password is correct 

## Permission issues

If the user can log in but has insufficient privileges to perform a particular request, Search Guard will log a statement like:

**Request:**

```
curl -Ss -k -u hr_employee:hr_employee -XGET "https://sgssl-0.example.com:9200/logstash-*/_search"
```

**Log statement:**

```
[c.f.s.p.PrivilegesEvaluator] No index-level perm match for 
User [name=hr_employee, roles=[backendrole_1, backendrole_2], requestedTenant=null] 
Resolved [aliases=[], indices=[logstash-2018.05.18, logstash-2018.05.19, logstash-2018.05.20],
allIndices=[logstash-2018.05.18, logstash-2018.05.19, logstash-2018.05.20], types=[*], isAll()=false, isEmpty()=false] 
[Action [indices:data/read/search]] 
[RolesChecked [sg_own_index, sg_kibana_user, sg_human_resources]]
```

This log message contains all information needed for debugging:

## Cluster vs. index permissions

Depending on whether the user lacksd a permission on the index- or cluster-level, Search Guard will log either: 

```
No index-level perm match ...
```

or

```
No cluster-level perm match ...
```

which means that the role definition is either missing privileges on the index- or cluster-level:

**Index-level:**

```
rolename:
  indices:
    'indexname':
      '*':
        - missing_privilege
```

**Cluster-level:**

```
rolename:
  cluster:
    - missing_privilege
```

## Username and backend roles

The next line lists the username and the **backend roles** assigned to this user:

```
User [name=hr_employee, roles=[backendrole_1, backendrole_2], requestedTenant=null]  
```

Please check

* that the username is the expected one
* that the backend roles for this user are correct.

## Search Guard roles

This line lists all Search Guard roles the user is currently mapped to

```
RolesChecked [sg_own_index, sg_kibana_user, sg_human_resources]
```

In this example the user is mapped to three Search Guard roles, `sg_own_index`, `sg_kibana_user` and `sg_human_resources`.

Please check

* that the user has the expected Search Guard roles

If Search Guard roles are missing or are incorrect, check that the [mapping between users/backend roles and Search Guard](../_docs_roles_permissions/configuration_roles_mapping.md) roles are correct.

## Executed action / missing permissions

This line prints the missing permission that causes this request to fail:

```
Action [indices:data/read/search]
```

Please check

* that the Search Guard role(s) for this user allow the execution of this request against the affected indices (see below)
  * the permission can be either granted by [assigning an action group](../_docs_roles_permissions/configuration_action_groups.md) like READ
  * or by assigning the single permission `indices:data/read/search` directly

**Using an action group:**

```
sg_role:
  cluster:
    - ...
  indices:
    'logstash-*':
      '*':
        - READ  
```

**Using single permissions:**

```
sg_role:
  cluster:
    - ...
  indices:
    'logstash-*':
      '*':
        - indices:data/read/search 
```

## Affected indices

This line lists all indices affected by this request:

```
Resolved [aliases=[], indices=[logstash-2018.05.18, logstash-2018.05.19, logstash-2018.05.20],
allIndices=[logstash-2018.05.18, logstash-2018.05.19, logstash-2018.05.20], types=[*], 
```

Search Guard will resolve any wildcard or index alias to the concrete, underlying indices. In our sample query we used a wildcard:

```
curl ... -XGET "https://sgssl-0.example.com:9200/logstash-*/_search"
```

In the log statement, you can see that Search Guard has expanded `logstash-*` to `logstash-2018.05.18`, `logstash-2018.05.19` and `logstash-2018.05.20`.