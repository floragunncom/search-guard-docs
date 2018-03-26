---
title: Field masking
html_title: Field masking
slug: field-masking
category: compliance
order: 300
layout: docs
edition: compliance
description: Use the Search Guard Compliance edition to mask and anonymize sensitive fields in any Elasticsearch index.
---
<!---
Copryight 2018 floragunn GmbH
-->

# Field masking

**This is a technology preview. The configuration settings listed here may change in subsequent releases. Do not use in production yet**

Instead of removing sensitive fields from a document with [field-level security](dlsfls_fls.md), you can also choose to anonymize them. At the moment this features is available for String based fields only and replaces the actual field value with a cryptographic hash. 

Field masking works well together with field-level security and can be applied to on a per-role and per-index basis. This gives you the flexibility of allowing certain roles to see sensitive fields in clear text, while anonymizing them for others.

## Hash algorithm and salts

Search Guard uses Blake2bDigest to calculate the hash. This alogorithm strives a very good balance between speed and security and has built-in support for a salt for randomized hashing.

## Setting the salt

You can set the salt in elasticsearch.yml like: 

```
searchguard.compliance.salt: abc123
```

| Name | Description |
|---|---|
| searchguard.compliance.salt | Salt to use when generating the hash value. Must be at least 32 characters, only ASCII is allowed. Optional.|

While setting a salt is optional, it is highly recommended to do so. 

## Configuring field masking

Field masking can be configured per role and per index, very similar to field-level security. You simply list the fields to be masked under the  `_masked_fields_` key in the role definition. Wildcards and nested documents are supported:

```
role_name:
  cluster:
  ...
  indices:
    indexname:
      documenttype:
      _masked_fields_:
        - field1
        - field2*
        - fieldx.fieldy
        - fielda.fieldb.*      
```

Field masking plays well together with [field-level security](dlsfls_fls.md). You just need to make sure that the fields you want to mask are not excluded from the result by the field-level security configuration.

## Example

```
sg_human_resources_masking:
  cluster:
    - CLUSTER_COMPOSITE_OPS_RO
  indices:
    'humanresources':
      '*':
        - READ
      _fls_:
        - 'Designation'
        - 'Salary'
        - 'FirstName'
        - 'LastName'
        - 'Address'
      _masked_fields_:
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

## Effects on the compliance read history

The [compliance read history](compliance_read_history.md) feature makes it possible to track read access to sensitive fields in your documents. For example, you can track access to the email field of customer records in order to stay GDPR compliant.

Access to masked fields are excluded from the read history, because the user has only seen that hash value, and not the email address in clear text.