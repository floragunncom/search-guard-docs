---
title: Delete Account
html_title: Delete Account
permalink: elasticsearch-alerting-rest-api-account-delete
layout: docs
section: alerting
edition: community
description: Use the Delete REST API endpoint to remove PagerDuty, Email, Slack and
  Webhook connectors by ID.
---
<!--- Copyright 2022 floragunn GmbH -->

# Delete Account
{: .no_toc}

{% include toc.md %}


## Endpoint

```
DELETE /_signals/account/{account_type}/{account_id}
DELETE /_signals/account/{tenant}/{account_type}/{account_id}
```

Deletes the tenant-independent account, or the account belonging to `{tenant}`, of type `{account_type}` identified by `{account_id}`.


## Path Parameters

**{account_type}** The type of the account to be deleted. Required.

**{account_id}** The id of the account to be deleted. Required.

**{tenant}** The tenant containing the account. Optional.

## Responses

### 200 OK

The account was successfully deleted.

### 403 Forbidden

The user does not have the permission to delete accounts. 

### 404 Not found

An account with the given id does not exist.

### 409 Conflict

The account is still used by a watch

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:account/delete` .

This permission is included in the following [built-in action groups](elasticsearch-alerting-security-permissions):

* SGS\_SIGNALS\_ACCOUNT\_MANAGE

The tenant endpoint requires `cluster:admin:searchguard:tenant:signals:account/delete`, included in:

* SGS\_SIGNALS\_TENANT\_ACCOUNT\_MANAGE

## Examples

```
DELETE /_signals/account/slack/my_account
```


**Response**

```
200 OK
```
