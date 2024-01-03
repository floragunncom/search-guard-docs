---
title: Configuration variables
permalink: configuration-password-handling
category: configuration
order: 210
layout: docs
edition: community
description: How to use config variables to keep sensitive information like passwords separate from the Search Guard configuration.
---

<!--- Copyright 2022 floragunn GmbH -->

# Configuration variables
{: .no_toc}

{% include toc.md %}

The Search Guard configuration is stored in a secured index. Without an admin certificate, it is not possible to access its content. 

Still, you might want to keep sensitive data separate from the configuration. This has a number of advantages:

- It is not possibly to accidentally reveal secrets when reviewing configuration files.
- You can separately manage and update secrets and configuration files.

## Using configuration variables

Search Guard supports variable substitution for all configuration files. The substitution will take place on the cluster, after the configuration has been loaded.

**Note:** Search Guard supports encryption of configuration variables. Naturally, Search Guard also needs to be able to access the decrypted values. This requires the encryption key to be available on each node of the cluster. Thus, this encryption should be considered as a basic protection against accidental exposure. However, users with administration access to a cluster node will be always able to access decrypted values if they really want to.

You can define configuration variables using the `sgctl` tool. After [having established a connection profile with your cluster](configuration_sgctl_basics.md), you can do the following:

```
$ ./sgctl.sh add-var ldap_password secret123 --encrypt 
```

This will store the value under the key `ldap_password` in encrypted form in a protected index, that cannot be accessed by normal users. By default, the encryption key is the hard-coded value `v9hGHVFiTgj+eAhjJrDgAEy5GUoTBUwXkAKEpfCL6dQ`. Thus, you should consider rather as obfuscation than an encryption. However, if you want, you can also [configure your own encryption key](TODO). TODO

You can also use configuration variables to store non-sensitive information. Just omit the `--encrypt` switch and the data won't be stored in encrypted form.

After having defined a variable, you can use it in any Search Guard configuration like this:

```yaml
auth_domains:
- type: basic/ldap
  ldap.idp.password: '#{var:ldap_password}'
```

Note: For a configuration property, you can either use a constant value or a configuration variable. However, you cannot use a configuration variable to define a sub-string of a constant. **Thus, something like this does not work:**

```yaml
  ldap.password: 'part_constant#{var:part_variable}'
```

In order to update configuration variables, use `update-var` command:

```
$ ./sgctl.sh update-var ldap_password newSecret456 --encrypt 
```

This will automatically reload the configuration. Thus, any change applied this way becomes immediately effective.

### Creating backups

If you want to create a dump or backup of all configuration variables, you can use the `sgctl get-config` command:

```
$ ./sgctl.sh get-config
```

This includes the configuration variables in the file `sg_config_vars.yml`. Note that encrypted variables are also stored in encrypted form in this file.

## Using content from external files

You can also retrieve configuration values from files which are available on your cluster nodes. You can use the following syntax for this purpose:


```yaml
auth_domains:
- type: basic/ldap
  ldap.idp.tls.trusted_cas: '#{file:/path/to/certificate.pem}'
```

This will load the data from the specified file and use it as the configuration value.

**Note:** Elasticsearch places restrictions on the locations of files plugins are allowed to access. The files must be located inside the `config` directory of your Elasticsearch installation. You can create subdirectories inside the `config` directory. If this directory is not convenient for you, you can use the `-Des.path.conf` command line option to move the directory to a different place.

**Note:** These files must be available on all nodes of your cluster; if the files change after a node has started, the change will not be immediately picked up. Changes will be only picked up when the configuration is reloaded. This is the case when the configuration is changed or if a node is restarted.

## Using content from environment variables

You can also use the value of environment variables of the Elasticsearch process. You can use the syntax `#{env:MY_ENV}` for this purpose. Example:


```yaml
auth_domains:
- type: basic/ldap
  ldap.idp.tls.trusted_cas: '#{env:CA_CERT}'
```

## Using pipe expressions
Pipe expressions are used to transform values of configuration variables. To transform value with the pipe expression the `|` operator is used together with the expression name, for example, `#{var:department_name|toLowerCase}`. Multiple pipe expressions can be combined e.g. `#{var:department_name|toLowerCase|base64}` Available pipe expressions

* `toString` - create a string representation
* `toJson` - convert an object to JSON string
* `toList` - replace an object with a single element list which contains the object
* `head` - extracts the first element from a collection
* `tail` - extracts the last element from the collection
* `toRegexFragment` - escapes all special characters related to regexp, please see [Pattern.quote method](https://docs.oracle.com/javase/8/docs/api/java/util/regex/Pattern.html#quote-java.lang.String-)
* `toLowerCase` - replaces each upper case character with a lower case character
* `toUpperCase` - replaces each lower case character with upper case character
* `base64` - performs base64 encoding
* `bcrypt` - calculates bcrypt password hash