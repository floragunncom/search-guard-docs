---
title: Field Reference
html_title: Audit Log Field Reference
permalink: audit-logging-reference
category: auditlog
order: 300
layout: docs
edition: enterprise
description: Field reference for the Search Guard audit logging module which can be used to track security and compliance related events in an OpenSearch/Elasticsearch cluster.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Audit Log Field Reference
{: .no_toc}

{% include toc.md %}

## Common Attributes

The following attributes are logged for all event categores, independent of the layer.

| Name | Description |
|---|---|
| audit\_format\_version | Audit log message format version, current: 3|
| @timestamp | UTC timestamp when the event was generated|
| audit_category | Audit log category, one of FAILED\_LOGIN, MISSING\_PRIVILEGES, BAD_HEADERS, SSL\_EXCEPTION, SG\_INDEX\_ATTEMPT, AUTHENTICATED or GRANTED\_PRIVILEGES.|
| audit\_node\_id  | The ID of the node where the event was generated.|
| audit\_node\_name | The name of the node where the event was generated. |
| audit\_node\_host\_address |The host address of the node where the event was generated.|
| audit\_node\_host\_name |The host address of the node where the event was generated. |
| audit\_request\_layer | The layer on which the event has been generated. One if `TRANSPORT` or `REST`.  |
| audit\_request\_origin | The layer from which the event originated. One if `TRANSPORT` or `REST`.  |
| audit\_request\_effective\_user\_is\_admin | true if the request was made wit an TLS admin certificate, false otherwise. |
| audit\_request\_remote\_address | The IP this request originated from. |
{: .config-table}

## REST FAILED_LOGIN attributes


| Name | Description |
|---|---|
| audit\_request\_effective\_user | The username that failed authentication. |
| audit\_rest\_request\_path | The REST endpoint URI |
| audit\_rest\_request\_params | The HTTP request parameters, if any. Optional. |
| audit\_rest\_request\_headers | The HTTP headers, if any. Optional. |
| audit\_request\_initiating\_user | The user that initiated the request. Only logged if it differs from the effective user, for example when using impersonation. Optional.  |
| audit\_request\_body | The HTTP body, if any and if request body logging is enabled. Optional.|
{: .config-table}

## REST AUTHENTICATED attributes


| Name | Description |
|---|---|
| audit\_request\_effective\_user | The username / principal that failed authentication. |
| audit\_request\_effective\_user\_auth\_domain | The domain that authenticated the user, as defined in `sg_config.yml`. E.g. "ldap", "jwt" |  
| audit\_request\_initiating\_user | The user that initiated the request. Only logged if it differs from the effective user, for example when using impersonation. Optional.  |
| audit\_request\_initiating\_user\_auth\_domain | The domain that authenticated the initiating user. Only logged if it differs from the effective user, for example when using impersonation. Optional. |
| audit\_rest\_request\_path | The REST endpoint URI |
| audit\_rest\_request\_params | The HTTP request parameters, if any. Optional. |
| audit\_rest\_request\_headers | The HTTP headers, if any. Optional. |
| audit\_request\_body | The HTTP body, if any and if request body logging is enabled. Optional.|
{: .config-table}

## REST SSL_EXCEPTION attributes

| Name | Description |
|---|---|
| audit\_request\_exception\_stacktrace | The stacktrace of the SSL Exception|
{: .config-table}

## REST BAD_HEADERS attributes

| Name | Description |
|---|---|
| audit\_rest\_request\_path | The REST endpoint URI |
| audit\_rest\_request\_params | The HTTP request parameters, if any. Optional. |
| audit\_rest\_request\_headers | The HTTP headers, if any. Optional. |
| audit\_request\_body | The HTTP body, if any and if request body logging is enabled. Optional.|
{: .config-table}

## REST BLOCKED_USER attributes

| Name | Description |
|---|---|
| audit\_request\_effective\_user | The username that was being blocked. |
| audit\_rest\_request\_path | The REST endpoint URI |
| audit\_rest\_request\_params | The HTTP request parameters, if any. Optional. |
| audit\_rest\_request\_headers | The HTTP headers, if any. Optional. |
| audit\_request\_body | The HTTP body, if any and if request body logging is enabled. Optional.|
{: .config-table}

## REST BLOCKED_IP attributes

| Name | Description |
|---|---|
| audit\_rest\_request\_path | The REST endpoint URI |
| audit\_rest\_request\_params | The HTTP request parameters, if any. Optional. |
| audit\_rest\_request\_headers | The HTTP headers, if any. Optional. |
| audit\_request\_remote\_address | The IP that was being blocked. |
{: .config-table}

## Transport FAILED_LOGIN attributes

| Name | Description |
|---|---|
| audit\_trace\_task\_id | The ID of this request |
| audit\_transport\_headers | The headers of the request, if any. Optional. |
| audit\_request\_effective\_user | The username / principal that failed authentication. |
| audit\_request\_initiating\_user | The user that initiated the request. Only logged if it differs from the effective user, for example when using impersonation. Optional.  |
| audit\_request\_initiating\_user\_auth\_domain | The domain that authenticated the initiating user. Only logged if it differs from the effective user, for example when using impersonation. Optional. |
| audit\_transport\_request\_type | The type of request, e.g. `IndexRequest`, `SearchRequest` |
| audit\_request\_body | The body / source, if any and if request body logging is enabled. Optional.|
| audit\_trace\_indices | The index name(s) as contained in the request. Can contain wildcards, date patterns and aliases. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_resolved\_indices | The resolved, concrete index name(s) affected by this request. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_doc\_types | The document types affecated by this request. Only logged if `resolve_indices` is true. Optional. |
{: .config-table}

## Transport AUTHENTICATED attributes

| Name | Description |
|---|---|
| audit\_trace\_task\_id | The ID of this request |
| audit\_transport\_headers | The headers of the request, if any. Optional. |
| audit\_request\_effective\_user | The username / principal that failed authentication. |
| audit\_request\_effective\_user\_auth\_domain | The domain that authenticated the user, as defined in `sg_config.yml`. E.g. "ldap", "jwt" |
| audit\_request\_initiating\_user | The user that initiated the request. Only logged if it differs from the effective user, for example when using impersonation. Optional.  |
| audit\_request\_initiating\_user\_auth\_domain | The domain that authenticated the initiating user. Only logged if it differs from the effective user, for example when using impersonation. Optional. |
| audit\_transport\_request\_type | The type of request, e.g. `IndexRequest`, `SearchRequest` |
| audit\_request\_body | The body / source, if any and if request body logging is enabled. Optional.|
| audit\_trace\_indices | The index name(s) as contained in the request. Can contain wildcards, date patterns and aliases. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_resolved\_indices | The resolved, concrete index name(s) affected by this request. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_doc\_types | The document types affecated by this request. Only logged if `resolve_indices` is true. Optional. |
{: .config-table}

## Transport MISSING_PRIVILEGES attributes

| Name | Description |
|---|---|
| audit\_trace\_task\_id | The ID of this request |
| audit\_trace\_task\_parent\_id | The parent ID of this request, if any. Optional. |
| audit\_transport\_headers | The headers of the request, if any. Optional. |
| audit\_request\_effective\_user | The username / principal that failed authentication. |
| audit\_request\_effective\_user\_auth\_domain | The domain that authenticated the user, as defined in `sg_config.yml`. E.g. "ldap", "jwt" |
| audit\_request\_initiating\_user | The user that initiated the request. Only logged if it differs from the effective user, for example when using impersonation. Optional.  |
| audit\_request\_initiating\_user\_auth\_domain | The domain that authenticated the initiating user. Only logged if it differs from the effective user, for example when using impersonation. Optional. |
| audit\_transport\_request\_type | The type of request, e.g. `IndexRequest`, `SearchRequest` |
| audit\_request\_privilege | The required privilege of the request, e.g. `indices:data/read/search` |
| audit\_request\_body | The body / source, if any and if request body logging is enabled. Optional.|
| audit\_trace\_indices | The index name(s) as contained in the request. Can contain wildcards, date patterns and aliases. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_resolved\_indices | The resolved, concrete index name(s) affected by this request. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_doc\_types | The document types affecated by this request. Only logged if `resolve_indices` is true. Optional. |
{: .config-table}

## Transport GRANTED_PRIVILEGES attributes

| Name | Description |
|---|---|
| audit\_trace\_task\_id | The ID of this request |
| audit\_trace\_task\_parent\_id | The parent ID of this request, if any. Optional. |
| audit\_transport\_headers | The headers of the request, if any. Optional. |
| audit\_request\_effective\_user | The username / principal that failed authentication. |
| audit\_request\_effective\_user\_auth\_domain | The domain that authenticated the user, as defined in `sg_config.yml`. E.g. "ldap", "jwt" |
| audit\_request\_initiating\_user | The user that initiated the request. Only logged if it differs from the effective user, for example when using impersonation. Optional.  |
| audit\_request\_initiating\_user\_auth\_domain | The domain that authenticated the initiating user. Only logged if it differs from the effective user, for example when using impersonation. Optional. |
| audit\_transport\_request\_type | The type of request, e.g. `IndexRequest`, `SearchRequest` |
| audit\_request\_privilege | The required privilege of the request, e.g. `indices:data/read/search` |
| audit\_request\_body | The body / source, if any and if request body logging is enabled. Optional.|
| audit\_trace\_indices | The index name(s) as contained in the request. Can contain wildcards, date patterns and aliases. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_resolved\_indices | The resolved, concrete index name(s) affected by this request. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_doc\_types | The document types affecated by this request. Only logged if `resolve_indices` is true. Optional. |
{: .config-table}

## Transport SSL_EXCEPTION attributes

| Name | Description |
|---|---|
| audit\_request\_exception\_stacktrace | The stacktrace of the SSL Exception|
{: .config-table}

## Transport BAD_HEADERS attributes

| Name | Description |
|---|---|
| audit\_trace\_task\_id | The ID of this request |
| audit\_trace\_task\_parent\_id | The parent ID of this request, if any. Optional. |
| audit\_transport\_headers | The headers of the request, if any. Optional. |
| audit\_request\_effective\_user | The username / principal that failed authentication. |
| audit\_request\_initiating\_user | The user that initiated the request. Only logged if it differs from the effective user, for example when using impersonation. Optional.  |
| audit\_request\_initiating\_user\_auth\_domain | The domain that authenticated the initiating user. Only logged if it differs from the effective user, for example when using impersonation. Optional. |
| audit\_transport\_request\_type | The type of request, e.g. `IndexRequest`, `SearchRequest` |
| audit\_request\_body | The body / source, if any and if request body logging is enabled. Optional.|
| audit\_trace\_indices | The index name(s) as contained in the request. Can contain wildcards, date patterns and aliases. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_resolved\_indices | The resolved, concrete index name(s) affected by this request. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_doc\_types | The document types affecated by this request. Only logged if `resolve_indices` is true. Optional. |
{: .config-table}

## Transport BLOCKED_USER attributes

| Name | Description |
|---|---|
| audit\_trace\_task\_id | The ID of this request |
| audit\_transport\_headers | The headers of the request, if any. Optional. |
| audit\_request\_effective\_user | The username / principal was being blocked. |
| audit\_transport\_request\_type | The type of request, e.g. `IndexRequest`, `SearchRequest` |
| audit\_request\_body | The body / source, if any and if request body logging is enabled. Optional.|
| audit\_trace\_indices | The index name(s) as contained in the request. Can contain wildcards, date patterns and aliases. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_resolved\_indices | The resolved, concrete index name(s) affected by this request. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_doc\_types | The document types affecated by this request. Only logged if `resolve_indices` is true. Optional. |
{: .config-table}

## Transport BLOCKED_IP attributes

| Name | Description |
|---|---|
| audit\_request\_remote\_address | The IP that was being blocked. |
| audit\_trace\_task\_id | The ID of this request |
| audit\_trace\_task\_parent\_id | The parent ID of this request, if any. Optional. |
| audit\_transport\_headers | The headers of the request, if any. Optional. |
| audit\_transport\_request\_type | The type of request, e.g. `IndexRequest`, `SearchRequest` |
| audit\_request\_body | The body / source, if any and if request body logging is enabled. Optional.|
| audit\_trace\_indices | The index name(s) as contained in the request. Can contain wildcards, date patterns and aliases. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_resolved\_indices | The resolved, concrete index name(s) affected by this request. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_doc\_types | The document types affecated by this request. Only logged if `resolve_indices` is true. Optional. |
{: .config-table}

## Transport SG\_INDEX\_ATTEMPT attributes

| Name | Description |
|---|---|
| audit\_trace\_task\_id | The ID of this request |
| audit\_transport\_headers | The headers of the request, if any. Optional. |
| audit\_request\_effective\_user | The username / principal that failed authentication. |
| audit\_request\_effective\_user\_auth\_domain | The domain that authenticated the user, as defined in `sg_config.yml`. E.g. "ldap", "jwt" |
| audit\_request\_initiating\_user | The user that initiated the request. Only logged if it differs from the effective user, for example when using impersonation. Optional.  |
| audit\_request\_initiating\_user\_auth\_domain | The domain that authenticated the initiating user. Only logged if it differs from the effective user, for example when using impersonation. Optional. |
| audit\_transport\_request\_type | The type of request, e.g. `IndexRequest`, `SearchRequest` |
| audit\_request\_body | The body / source, if any and if request body logging is enabled. Optional.|
| audit\_trace\_indices | The index name(s) as contained in the request. Can contain wildcards, date patterns and aliases. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_resolved\_indices | The resolved, concrete index name(s) affected by this request. Only logged if `resolve_indices` is true. Optional. |
| audit\_trace\_doc\_types | The document types affecated by this request. Only logged if `resolve_indices` is true. Optional. |
{: .config-table}