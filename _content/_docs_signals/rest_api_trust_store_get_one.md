---
title: Get one trust store
html_title: Get one trust store
permalink: elasticsearch-alerting-rest-api-trust-store-get-one
category: signals-rest
order: 853
layout: docs
edition: community
description: Use to retrieve all trust stores.
---

<!--- Copyright 2023 floragunn GmbH -->

# Get one trust store
{: .no_toc}

{% include toc.md %}


```
GET /_signals/truststores/{trust-store-id}
```

Load information about the trust store with the given id. 


## Responses

### 200 OK

The trust store was found, information about trust store are present in response body.

### 403 Forbidden

The user does not have the required permissions to access the endpoint.

### 404 Not Found

The trust store with the requested id does not exist.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:truststores/findone`.

## Examples

### Get truststore with id `ca-trust-anchor`

```
GET /_signals/truststores/ca-trust-anchor
```

**Response**

```
200 OK
```

```json
{
  "status": 200,
  "data": {
    "id": "ca-trust-anchor",
    "name": "my trust anchor",
    "raw_pem": "-----BEGIN CERTIFICATE-----\nMIIDbDCCAlSgAwIBAgIBATANBgkqhkiG9w0BAQsFADBHMRAwDgYDVQQKDAdpbmRl\neC0wMRQwEgYDVQQLDAtTZWFyY2hHdWFyZDEdMBsGA1UEAwwUcm9vdC5jYS5udW1i\nZXItMC5jb20wHhcNMjMwNTE4MTU0MzMwWhcNMjMwNjE3MTU0MzMwWjBHMRAwDgYD\nVQQKDAdpbmRleC0wMRQwEgYDVQQLDAtTZWFyY2hHdWFyZDEdMBsGA1UEAwwUcm9v\ndC5jYS5udW1iZXItMC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB\nAQDL0mJkBHydlHIYIfZbP05RvH/31J4S7Dlkw0hCZP8qsF9JWC9voeoLdxDm7XS1\nEQ/osotUD6C6JvQC8CUp659PMFJkvRbouoUMm4fy0t6W5Td2OejBZ5/JAsRogUw1\nZDBsUY4VzzG3YcZGO9D13/EGM+fDqGVLrd9KQU89EBz4ZTh9D5DwxdH//eKDWc3O\nLtJDd/0SQwq2QuQ6RMQo8UaFIcGtl4tpoukDPzwT0s+jNgHcNaJQcHCsf5qb5yfT\n6Vwd1n8mEyd7o7wErQpqQTYQSL6Zl5rVENggvLBZ+IoBPAdKnXLqVxGRS+8yfQbr\nr6ds0Ic0msEXOgf6Ma6Ax3ebAgMBAAGjYzBhMA8GA1UdEwEB/wQFMAMBAf8wHwYD\nVR0jBBgwFoAUZLIuPFJPTyMZCxSglaea/myWYJ8wHQYDVR0OBBYEFGSyLjxST08j\nGQsUoJWnmv5slmCfMA4GA1UdDwEB/wQEAwIBhjANBgkqhkiG9w0BAQsFAAOCAQEA\nSZ01KvwkwxjNf1azrBWAfVgUU78DsSzF3C732ABwpTfagypxVNCHxgKB2UUWTl3T\nV6N6noDcVr3F5s/uwNpqlWdvHdohnnP1L8kt7ffWVAKfrRq3HAZsZGL31wQVNL+Z\nxx1xeB3Y3Q3ual+D20VivPg9QH4EfJiRwAUD4DooW0EQtwbRqYxb+vM4EcdvSvZH\nWnJ/HIGRjCrp77+JiaNOK+BfOgZb1af3+fit7nJZGmbAchk4CivS/FVDMTPUwQnG\nFvYSkmIJr/LNMNLRrV1zPO5VKlNUB7IU40zyIsf4CwYoefPiF7Xy9HyCzL5v5Q9A\njyS2KwH21/DFtX582wsDOQ==\n-----END CERTIFICATE-----",
    "certificates": [
      {
        "pem": "-----BEGIN CERTIFICATE-----\nMIIDbDCCAlSgAwIBAgIBATANBgkqhkiG9w0BAQsFADBHMRAwDgYDVQQKDAdpbmRl\neC0wMRQwEgYDVQQLDAtTZWFyY2hHdWFyZDEdMBsGA1UEAwwUcm9vdC5jYS5udW1i\nZXItMC5jb20wHhcNMjMwNTE4MTU0MzMwWhcNMjMwNjE3MTU0MzMwWjBHMRAwDgYD\nVQQKDAdpbmRleC0wMRQwEgYDVQQLDAtTZWFyY2hHdWFyZDEdMBsGA1UEAwwUcm9v\ndC5jYS5udW1iZXItMC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB\nAQDL0mJkBHydlHIYIfZbP05RvH/31J4S7Dlkw0hCZP8qsF9JWC9voeoLdxDm7XS1\nEQ/osotUD6C6JvQC8CUp659PMFJkvRbouoUMm4fy0t6W5Td2OejBZ5/JAsRogUw1\nZDBsUY4VzzG3YcZGO9D13/EGM+fDqGVLrd9KQU89EBz4ZTh9D5DwxdH//eKDWc3O\nLtJDd/0SQwq2QuQ6RMQo8UaFIcGtl4tpoukDPzwT0s+jNgHcNaJQcHCsf5qb5yfT\n6Vwd1n8mEyd7o7wErQpqQTYQSL6Zl5rVENggvLBZ+IoBPAdKnXLqVxGRS+8yfQbr\nr6ds0Ic0msEXOgf6Ma6Ax3ebAgMBAAGjYzBhMA8GA1UdEwEB/wQFMAMBAf8wHwYD\nVR0jBBgwFoAUZLIuPFJPTyMZCxSglaea/myWYJ8wHQYDVR0OBBYEFGSyLjxST08j\nGQsUoJWnmv5slmCfMA4GA1UdDwEB/wQEAwIBhjANBgkqhkiG9w0BAQsFAAOCAQEA\nSZ01KvwkwxjNf1azrBWAfVgUU78DsSzF3C732ABwpTfagypxVNCHxgKB2UUWTl3T\nV6N6noDcVr3F5s/uwNpqlWdvHdohnnP1L8kt7ffWVAKfrRq3HAZsZGL31wQVNL+Z\nxx1xeB3Y3Q3ual+D20VivPg9QH4EfJiRwAUD4DooW0EQtwbRqYxb+vM4EcdvSvZH\nWnJ/HIGRjCrp77+JiaNOK+BfOgZb1af3+fit7nJZGmbAchk4CivS/FVDMTPUwQnG\nFvYSkmIJr/LNMNLRrV1zPO5VKlNUB7IU40zyIsf4CwYoefPiF7Xy9HyCzL5v5Q9A\njyS2KwH21/DFtX582wsDOQ==\n-----END CERTIFICATE-----",
        "subject": "CN=root.ca.number-0.com,OU=SearchGuard,O=index-0",
        "issuer": "CN=root.ca.number-0.com,OU=SearchGuard,O=index-0",
        "not_before": "2023-05-18T15:43:30.000Z",
        "not_after": "2023-06-17T15:43:30.000Z",
        "serial_number": "1"
      }
    ]
  }
}
```
