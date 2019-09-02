---
title: Delete Destination
html_title: Delete a destination with the REST API
slug: elasticsearch-alerting-rest-api-destination-delete
category: signals-rest
order: 1000
layout: docs
edition: preview
description: 
---

<!--- Copyright 2019 floragunn GmbH -->

# Delete Destination
{: .no_toc}

{% include toc.md %}


## Endpoint

```
DELETE /_signals/destination/{destination_id}
```

Deletes the account identified by the `{destination_id}` path parameter. 

**Important:** Right now, it is possible to delete accounts even if they are still used by watches. After deleting an account which is still used by a watch, the watch will fail to execute.


## Path Parameters

**{destination_id}** The id of the account to be deleted. Required.

## Responses

### 200 OK

The account was successfully deleted.

### 403 Forbidden

The user does not have the permission to delete accounts. 

### 404 Not found

An account with the given id does not exist.



## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:destination/delete` .


## Examples

```
DELETE /_signals/destination/my_destination
```


**Response**

```
200 OK
```
