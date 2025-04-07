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

# Testing the configuration
{: .no_toc}

{% include toc.md %}

This guide assumes that you have already installed Search Guard in your cluster using the [demo installer](demo-installer).
{: .note .js-note .note-info}

In the last chapters we have:

* created users by adding them to `sg_internal_users.yml`
* created roles by configuring them to `sg_roles.yml`
* connected users and Search Guard roles by creating a mapping in `sg_roles_mapping.yml`

Not it's time to test if the configuration works as expected.

## Checking the configured users

As a first step we want to check whether the users we have configured can log in and are mapped to the correct Search Guard role(s).

Search Guard provides an HTTP endpoint to check the attributes of a user. 

```
https://<node name>:<http port>/_searchguard/authinfo?pretty
```

To fetch the user information, we need to provide the username and the password. We first check the attributes of the user `jdoe` by issuing a curl call to this endpoint:

```
curl -k -u jdoe:jdoe -XGET "https://sgssl-0.example.com:9200/_searchguard/authinfo?pretty"
```

which returns:

```
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

In this JSON snippet (abbreviated for clarity) we can see that our user was created and is assigned to the correct Search Guard role:

**"user_name" : "jdoe"**

This is the user name as configured in `sg_internal_users.yml`

**"backend\_roles": ["hr\_department"]**

This is backend role we assigned to the user `jdoe` in `sg_internal_users.yml`

**"sg\_roles": ["sg\_human\_resources"]**

This is the assigned Search Guard role for the user `jdoe`. This means the mapping from the user to the Search Guard role works as expected.

## Accessing Elasticsearch

Now that we are sure that our user `jdoe` is correctly mapped to the `sg_human_resources` Search Guard role, we can try to access some data in Elasticsearch.

The definition of the role looks like:

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

So we expect that the user can read data in the `humanresources` index, but cannot access any other data.

We try to access data in the `humanresources` first:

```
curl -k -u jdoe:jdoe -XGET "https://sgssl-0.example.com:9200/humanresources/_search?pretty"
```

As expected, access is allowed and Elasticsearch returns data from the index:

```
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
```

If we try to access data in the `devops` index, access is denied as expected:

```
curl -k -u jdoe:jdoe -XGET "https://sgssl-0.example.com:9200/devops/_search?pretty"
```
```
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