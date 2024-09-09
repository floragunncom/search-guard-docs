---
title: Field anonymization
html_title: Anonymize fields in Elasticsearch documents
permalink: field-anonymization
category: dlsfls
order: 300
layout: docs
edition: compliance
description: How to anonymize fields in Elasticsearch documents by using hashes or regular expressions.
---
<!---
Copyright 2022 floragunn GmbH
-->

# Field anonymization
{: .no_toc}

{% include toc.md %}

Instead of removing sensitive fields from a document with [field-level security](../_docs_dls_fls/dlsfls_fls.md), you can also choose to anonymize them. At the moment this features is available for String based fields only. 

You can choose between several methods for anonymization:

- Hashing using the blake 2 hash algorithm
- Hashing using other available algorithms
- Custom string replace operations
 
Field masking works well together with field-level security and can be applied to on a per-role and per-index basis. This gives you the flexibility of allowing certain roles to see sensitive fields in clear text, while anonymizing them for others.


**Note:** Search Guard FLX 1.0 comes with two implementations of DLS/FLS:

- A legacy implementation, which is compatible with nodes which are running still older versions of Search Guard
- A new implementation, which provides better efficiency and functionality. However, this implementation can only be used if you have completely updated your cluster to Search Guard FLX.

As the new implementation is not backwards-compatible, it needs to be manually activated in the configuration. To do so, create or edit `sg_authz_dlsfls.yml` and add:

```yaml
use_impl: flx
```

**Note:** `LogsDB` mode, introduced by Elasticsearch in version 8.15, is not supported with the legacy DLS/FLS implementation.

This documentation describes the *new implementation*.

## Configuring fields to anonymize

Field masking can be configured per role and index pattern, very similar to field-level security. You simply list the fields to be masked under the  `masked_fields` key in the role definition. Wildcards and nested documents are supported:

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

By default, Search Guard uses the blake2b hash algorithm to calculate the hash. This algorithm strives a very good balance between speed and security and has built-in support for a salt for randomized hashing. If you use the blake2b algorithm, you should [configure a custom hash salt](#configuring-the-hash-salt).


Field masking plays well together with [field-level security](../_docs_dls_fls/dlsfls_fls.md). You just need to make sure that the fields you want to mask are not excluded from the result by the field-level security configuration.

### Example

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

In this example only the fields `Designation`, `Salary`, `FirstName`, `LastName` and `Address` of documents in the index `humanresources` are included in the resulting documents. This is done by whitelisting these fields in the `fls` section of the role / index definition. In addition, the `FirstName`, `LastName` and `Address` are masked. A search result might look like:

```json
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

## String manipulation using regular expressions

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

## Custom hash algorithms

You can also configure alternative hash algorithms instead of blake2b. This looks like this:


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


## Global configuration

Global configuration for field masking is stored in the `sg_authz_dlsfls` configuration. You can use `sgctl` to upload the changed configuration to the cluster.

### Configuring the hash salt

If you use a hashing algorithm, you should configure a custom hash salt. 

**field_anonymization.salt:** A hexadecimal value with exactly 32 characters. For secure hashing, you should make sure that this value has a high entropy. The default value is `7A4EB67D40536EB6B107AF3202EA6275`. 

**field_anonymization.personalization:** A string which serves as the personalization parameter of the blake2b algorithm. Only the first 16 bytes of the string will be used. The default value is `searchguard-flx1`. 


For generating a suitable random value for `field_anonymization.salt`, you can use the following command:

```
$ xxd -u -l 16 -p /dev/urandom
```

### Constant prefixes for anonymized fields

You can configure a constant prefix for anonymized fields. This makes it clearer that the content was anonymized.

**field_anonymization.prefix:** A string that is prepended to any anonymized value. Defaults to the empty string.