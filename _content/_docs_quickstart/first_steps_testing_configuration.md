---
title: Testing the configuration
html_title: Testing the configuration
permalink: first-steps-testing-configuration
layout: docs
description: How to test the user and role configuration we set up in the last steps.
resources:
  - troubleshooting-search-guard-user-roles|Troubleshooting user problems
  - troubleshooting-search-guard-permission|Troubleshooting permission problems
---
<!---
Copyright 2022 floragunn GmbH
-->

# Testing the Configuration
{: .no_toc}

{% include toc.md %}

This guide assumes that you have already installed Search Guard in your cluster using the [demo installer](demo-installer).
{: .note .js-note .note-info}

## Overview

In the previous chapters, we completed the essential configuration steps for Search Guard:

1. Created users in `sg_internal_users.yml`
2. Defined roles in `sg_roles.yml`
3. Connected users to roles through mappings in `sg_roles_mapping.yml`

Now it's time to verify that our configuration works as expected. This chapter will guide you through testing user authentication, role mapping, and permission enforcement.

## Verifying User Configuration

Search Guard provides a dedicated endpoint to verify user authentication and inspect user attributes, including role assignments:

```
https://<node name>:<http port>/_searchguard/authinfo?pretty
```

This endpoint returns detailed information about the authenticated user, allowing you to confirm that:
- The user can authenticate successfully
- The user has the correct backend roles
- The user is mapped to the expected Search Guard roles

### Testing User Authentication

Let's verify our configuration for the user `jdoe` using `curl`:

```
curl -k -u jdoe:jdoe -XGET "https://sgssl-0.example.com:9200/_searchguard/authinfo?pretty"
```

This command sends an authenticated request to the `authinfo` endpoint. The `-k` flag allows insecure connections (useful for testing environments), and `-u jdoe:jdoe` provides the username and password for basic authentication.

A successful response will look similar to:

```json
{
  "user" : "User [name=jdoe, backend_roles=[hr_department], requestedTenant=null]",
  "user_name" : "jdoe",
  ...
  "backend_roles" : [
    "hr_department"
  ],
  "sg_roles" : [
    "sg_human_resources"
  ],
  ...
}
```

### Understanding the Response

Let's analyze key parts of this response:

| Field | Description | Example Value | Source Configuration |
|-------|-------------|---------------|----------------------|
| `user_name` | The authenticated username | `jdoe` | Defined in `sg_internal_users.yml` |
| `backend_roles` | Roles assigned to this user | `["hr_department"]` | Configured in `sg_internal_users.yml` |
| `sg_roles` | Search Guard roles mapped to this user | `["sg_human_resources"]` | Result of mapping in `sg_roles_mapping.yml` |

This response confirms that:
1. User `jdoe` can authenticate successfully
2. The user has the backend role `hr_department` as configured
3. The user is correctly mapped to the `sg_human_resources` Search Guard role

## Testing Access Permissions

After verifying that users are correctly mapped to roles, we should test whether the role-based permissions are enforced as expected.

### Review Role Definition

First, let's recall the definition of the `sg_human_resources` role:

```yaml
sg_human_resources:
  cluster_permissions:
    - "SGS_CLUSTER_COMPOSITE_OPS"
  index_permissions:
    - index_patterns:
      - "humanresources"
      allowed_actions:
        - "SGS_READ"
```

Based on this definition, we expect:
- The user can perform basic cluster operations
- The user can read from the `humanresources` index
- The user cannot access any other indices

### Testing Allowed Access

Let's check if `jdoe` can read from the `humanresources` index:

```
curl -k -u jdoe:jdoe -XGET "https://sgssl-0.example.com:9200/humanresources/_search?pretty"
```

A successful response containing data confirms that the permissions are working correctly:

```json
{
  "took" : 216,
  "timed_out" : false,
  "_shards" : {
   ...
  },
  "hits" : {
    "total" : {
    ...
    },
    "max_score" : 1.0,
    "hits" : [
      {
        "_index" : "humanresources",
        "_type" : "_doc",
        "_id" : "3",
        "_score" : 1.0,
        "_source" : {
          "FirstName" : "CHASE",
          "LastName" : "CRUDO",
          "Designation" : "President",
        }
      },
      ...
    ]
  }
}
```

### Testing Denied Access

Now, let's verify that access is denied when `jdoe` tries to access an unauthorized index:

```
curl -k -u jdoe:jdoe -XGET "https://sgssl-0.example.com:9200/devops/_search?pretty"
```

A properly configured system should return a security exception:

```json
{
  "error" : {
    "root_cause" : [
      {
        "type" : "security_exception",
        "reason" : "no permissions for [indices:data/read/search] and User [name=jdoe, roles=[hr_department], requestedTenant=null]"
      }
    ],
    "type" : "security_exception",
    "reason" : "no permissions for [indices:data/read/search] and User [name=jdoe, roles=[hr_department], requestedTenant=null]"
  },
  "status" : 403
}
```

The `403` status code and security exception confirm that the access control is functioning as expected.

## Additional Testing Scenarios

For comprehensive verification, consider testing:

1. **Write operations**: Confirm that users can only write to indices where they have write permissions
   ```
   curl -k -u username:password -XPOST "https://host:port/index/_doc" -H "Content-Type: application/json" -d '{"field": "value"}'
   ```

2. **Other users**: Verify configuration for all users, especially those with different role mappings
   ```
   curl -k -u cmaddock:cmaddock -XGET "https://sgssl-0.example.com:9200/_searchguard/authinfo?pretty"
   ```

3. **Cluster operations**: Test permissions for cluster-level operations
   ```
   curl -k -u username:password -XGET "https://host:port/_cluster/health?pretty"
   ```

## Troubleshooting

If you encounter unexpected behavior during testing:

1. **Authentication issues**:
    - Verify username and password in `sg_internal_users.yml`
    - Check that configuration files were properly uploaded using `sgctl`

2. **Role mapping problems**:
    - Examine the `backend_roles` in the `authinfo` response
    - Verify role mappings in `sg_roles_mapping.yml`

3. **Permission issues**:
    - Review the role definition in `sg_roles.yml`
    - Check index patterns for typos or mismatches
    - Verify that action groups provide the intended permissions

For more detailed troubleshooting help, refer to:
- [Troubleshooting User Problems](troubleshooting-search-guard-user-roles)
- [Troubleshooting Permission Problems](troubleshooting-search-guard-permission)