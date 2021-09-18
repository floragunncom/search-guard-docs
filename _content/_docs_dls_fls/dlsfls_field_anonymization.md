---
title: Field anonymization
html_title: Field anonymization
permalink: field-anonymization
category: dlsfls
order: 300
layout: docs
edition: compliance
description: How to anonymize fields in OpenSearch/Elasticsearch documents by using hashes or regular expressions.
---
<!---
Copyright 2020 floragunn GmbH
-->

# Anonymize fields in OpenSearch/Elasticsearch documents
{: .no_toc}

{% include toc.md %}

Instead of removing sensitive fields from a document with [field-level security](../_docs_dls_fls/dlsfls_fls.md), you can also choose to anonymize them. At the moment this features is available for String based fields only and replaces the actual field value with a cryptographic hash. 

Field masking works well together with field-level security and can be applied to on a per-role and per-index basis. This gives you the flexibility of allowing certain roles to see sensitive fields in clear text, while anonymizing them for others.

## Hash algorithm and salts

Search Guard by default uses Blake2bDigest to calculate the hash. This alogorithm strives a very good balance between speed and security and has built-in support for a salt for randomized hashing.

## Setting a static salt

You can set the salt in elasticsearch.yml like: 

```
searchguard.compliance.salt: abc123
```

| Name | Description |
|---|---|
| searchguard.compliance.salt | Optional. Salt to use when generating the hash value. Must be at least 32 characters, only ASCII is allowed. Optional.|
{: .config-table}

While setting a salt is optional, it is highly recommended to do so. The salt you set in `opensearch.yml`/`elasticsearch.yml` cannot be changed without restarting OpenSearch/Elasticsearch. This provides a high level of security and performance, but limits flexibility. Depending on your use case and security requirements you can also use a dynamic salt.

## Setting a dynamic salt

You can also configure the salt in `sg_config.yml`. This makes it possible to change the salt at runtime without the need to restart OpenSearch/Elasticsearch. Please note that changing the salt at runtime will invalidate any query cache, so you might see a small degradation in performance for a brief period of time.

Enable dynamic salts in elasticsearch.yml by setting:

```
searchguard.compliance.local_hashing_enabled: true
```

The dynamic salt can be configure in `sg_config.yml`and thus updated at runtime with either [sgadmin](sgadmin) or the [REST API](rest-api-access-control).

## Configuring fields to anonymize

Field masking can be configured per role and index pattern, very similar to field-level security. You simply list the fields to be masked under the  `_masked_fields_` key in the role definition. Wildcards and nested documents are supported:

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - ...
      masked_fields:
        - field1
        - field2*
        - fieldx.fieldy
        - fielda.fieldb.*      
      
```

Field masking plays well together with [field-level security](../_docs_dls_fls/dlsfls_fls.md). You just need to make sure that the fields you want to mask are not excluded from the result by the field-level security configuration.

## Example

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - ...
      fls:
        - 'Designation'
        - 'Salary'
        - 'FirstName'
        - 'LastName'
        - 'Address'
      masked_fields:
        - '*Name'
        - 'Address'     
      
```

In this example only the fields `Designation`, `Salary`, `FirstName`, `LastName` and `Address` of documents in the index `humanresources` are included in the resulting documents. This is done by whitelisting these fields in the `_fls_` section of the role / index definition. In addition, the `FirstName`, `LastName` and `Address` are masked. A search result might look like:

```
{
  "_index" : "humanresources",
  "_type" : "employees",
  "_id" : "1",
  "_score" : 5.7807436,
  "_source" : {
    "Designation" : "Manager",
    "Salary" : 154000,
    "Address" : "c560467d662d919fe9d1439127a5d3dd7da027dbadfd677ed88367a38a90fc69",
    "FirstName" : "fe6d625e4d577ab9b57bc403027e7022edfc27743991d73b14c594d6a8462443",
    "LastName" : "2823cef66118a9dd3f1ceb523018c2c47e40d3d48471e42285aa8cb8d1531528"
  }
}
```

## Custom hash algorithms

You can configure alternative hash algorithms (instead of Blake2bDigest) and you also can mask only a part of the field value.

### Defining an alternative hash algorithm

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - ...
      masked_fields:
        - '*Name::SHA-1'
        - 'Address::SHA-512'     
      
```

The above example means that all values of all fields ending with `Name` are anonymized with an SHA-1 hash and all values of the field `Address` are anonymized with an SHA-512. All hashing algorithms provided which are provided by your JVM are supported. This typically includes MD5, SHA-1, SHA-384, and SHA-512.

If you use the REST API to define your roles and masked fields then the validity or your alternative hash algorithm is checked.

### Using regular expressions

You can apply one or more regex patterns and replacement strings to configure how the value of a particular field will be anonymized.
The formal definition is `<field-pattern>::/<regex>/::<replacement-string>`. There can be multiple regex/replacement tuples whereas the result from one on the left side is passed as in input to the one on the right side (like piping in a shell). The regex can include `^` and `$`, they are not implicitly assumed. 

```yaml
hr_employee:
  index_permissions:
    - index_patterns:
      - 'humanresources'
      allowed_actions:
        - ...
      masked_fields:
        - 'lastname::/.*/::*'
        - '*ip_source::/[0-9]{1,3}$/::XXX::/^[0-9]{1,3}/::***'
   
      
```

The above example means that every field value of the field `lastname` is anonymized by replacing all characters with a *.
All values of all fields ending with `ip_source` are anonymized by replacing the last three numbers with XXX and then take this and anonymize it
by replacing the last three numbers with ***. So an example IP address of `100.200.121.212` will result in `100.200.***.XXX`.

If you use the REST API to define your roles and masked fields then the syntax of your patterns is checked.

## Prefixing anonymized fields

In order to make it easier for the end user to understand which fields are anonymized, you can configure a prefix for anonymized fields. The prefix has no impact on search or aggregations.

Set the prefix in elasticsearch.yml:

```
searchguard.compliance.mask_prefix: "<prefix>"
```

## Multiple roles and field anonymization

As with document-level security, if a user is member of multiple roles it is important to understand how the field anonymization (FA) settings for these roles are combined.

In case of FA, the FA field definitions of the roles are combined with `AND`. 

If a user has a role that defines FA restrictions on an index, and another role that does not place any FA restrictions on the same index, the restrictions defined in the first role still apply.

You can change that behaviour so that a role that places no restrictions on an index removes any restrictions from other roles. This can be enabled in `opensearch.yml`/`elasticsearch.yml`: 

```
searchguard.dfm_empty_overrides_all: true
```

## Effects on the compliance read history

The [compliance read history](../_docs_audit_logging/auditlogging_read_history.md) feature makes it possible to track read access to sensitive fields in your documents. For example, you can track access to the email field of customer records in order to stay GDPR compliant.

Access to masked fields are excluded from the read history, because the user has only seen that hash value, and not the email address in clear text.