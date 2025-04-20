---
title: Create or replace a trust store
html_title: Create or replace trust store
permalink: elasticsearch-alerting-rest-api-trust-store-create-or-replace
layout: docs
edition: community
description: The request used to create or replace a trust store
---
<!--- Copyright 2023 floragunn GmbH -->

# Create or replace trust store
{: .no_toc}

{% include toc.md %}


```
PUT /_signals/truststores/{trust-store-id}
```

Create a new trust store if the trust store with the provided id does not exist. If a trust store with the provided id exists, the existing
trust store is replaced. The trust store can contain one or more certificates. Certificates should be provided in
[PEM format](https://www.rfc-editor.org/rfc/rfc7468). If the trust store is composed of more than one certificate then the 
[PEM](https://www.rfc-editor.org/rfc/rfc7468) certificate representation should be concatenated into one string and placed in the `pem` 
JSON field.

This request accepts certificates in textual ([PEM format](https://www.rfc-editor.org/rfc/rfc7468)) representation which should be placed
in a JSON string (in the field `pem`). The certificates in ([PEM format](https://www.rfc-editor.org/rfc/rfc7468)) usually contain a lot of new
line characters which cannot be placed directly in JSON string. Therefore, it is necessary to properly escape new line characters with the usage of
character sequence `\n`. Please see [RFC 8259](https://www.rfc-editor.org/rfc/rfc8259) for more details.

## Limitations

Due to performance reasons, users should not add too many certificates to their trust stores. A large number of certificates may affect 
the time needed to perform a TLS handshake and increase the system's start time.

Moreover, when certificates are uploaded to the system only basic validation is performed. Therefore, the user can (for example) upload
expired certificates.

## Responses

### 200 OK

Basic information of the created trust store and its certificates.

### 403 Forbidden

The user does not have the required permissions to access the endpoint.

## Permissions

For being able to access the endpoint, the user needs to have the privilege `cluster:admin:searchguard:signals:truststores/createorreplace`.

## Examples

### Create a new trust store with id `ca-trust-anchor`

```
PUT /_signals/truststores/ca-trust-anchor
```
```json
{
	"name": "my trust anchor",
	"pem": "-----BEGIN CERTIFICATE-----\nMIIDbDCCAlSgAwIBAgIBATANBgkqhkiG9w0BAQsFADBHMRAwDgYDVQQKDAdpbmRl\neC0wMRQwEgYDVQQLDAtTZWFyY2hHdWFyZDEdMBsGA1UEAwwUcm9vdC5jYS5udW1i\nZXItMC5jb20wHhcNMjMwNTE4MTU0MzMwWhcNMjMwNjE3MTU0MzMwWjBHMRAwDgYD\nVQQKDAdpbmRleC0wMRQwEgYDVQQLDAtTZWFyY2hHdWFyZDEdMBsGA1UEAwwUcm9v\ndC5jYS5udW1iZXItMC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB\nAQDL0mJkBHydlHIYIfZbP05RvH/31J4S7Dlkw0hCZP8qsF9JWC9voeoLdxDm7XS1\nEQ/osotUD6C6JvQC8CUp659PMFJkvRbouoUMm4fy0t6W5Td2OejBZ5/JAsRogUw1\nZDBsUY4VzzG3YcZGO9D13/EGM+fDqGVLrd9KQU89EBz4ZTh9D5DwxdH//eKDWc3O\nLtJDd/0SQwq2QuQ6RMQo8UaFIcGtl4tpoukDPzwT0s+jNgHcNaJQcHCsf5qb5yfT\n6Vwd1n8mEyd7o7wErQpqQTYQSL6Zl5rVENggvLBZ+IoBPAdKnXLqVxGRS+8yfQbr\nr6ds0Ic0msEXOgf6Ma6Ax3ebAgMBAAGjYzBhMA8GA1UdEwEB/wQFMAMBAf8wHwYD\nVR0jBBgwFoAUZLIuPFJPTyMZCxSglaea/myWYJ8wHQYDVR0OBBYEFGSyLjxST08j\nGQsUoJWnmv5slmCfMA4GA1UdDwEB/wQEAwIBhjANBgkqhkiG9w0BAQsFAAOCAQEA\nSZ01KvwkwxjNf1azrBWAfVgUU78DsSzF3C732ABwpTfagypxVNCHxgKB2UUWTl3T\nV6N6noDcVr3F5s/uwNpqlWdvHdohnnP1L8kt7ffWVAKfrRq3HAZsZGL31wQVNL+Z\nxx1xeB3Y3Q3ual+D20VivPg9QH4EfJiRwAUD4DooW0EQtwbRqYxb+vM4EcdvSvZH\nWnJ/HIGRjCrp77+JiaNOK+BfOgZb1af3+fit7nJZGmbAchk4CivS/FVDMTPUwQnG\nFvYSkmIJr/LNMNLRrV1zPO5VKlNUB7IU40zyIsf4CwYoefPiF7Xy9HyCzL5v5Q9A\njyS2KwH21/DFtX582wsDOQ==\n-----END CERTIFICATE-----"
}
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
