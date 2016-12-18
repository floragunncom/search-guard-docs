<!---
Copryight 2016 floragunn GmbH
-->

# Using Search Guard with logstash

Configuring logstash is very similar to configuring Kibana, so we highly recommend to read the Kibana chapter as well. Most principles, especially the Kibana server user / logstash user, are nearly identical.

The sample configuration files that ship with Search Guard already contain a user named `logstash`. The correct permissions for this user are already configured as well, so you can use the sample config files to quickly set up a Search Guard secured logstash installation for testing purposes.

## Principles

From an Elasticsearch / Search Guard point of view, logstash is merely an HTTP client, just like curl or a browser: Logstash connects to Elasticsearch via the REST API, creates indices and reads and writes documents from and to these indices. So, in order to use Search Guard in conjunction with logstash, you just need to perform the following steps:

* Configure logstash to use HTTPS instead of HTTP
 * If you want to verify the servers certificate (optional, but recommended), you need to provide the path to the keystore containing your Root CA as well 
* Configure the logstash username and password
 * When talking to Elasticsearch, logstash uses this username and password to identify itself
* Set up the logstash user and its permissions in the Search Guard configuration
 * You can use the sample config files shipped with Search Guard for a quick start 

## Setting up TLS/SSL

If you use TLS on the REST layer (as you should), you need to configure logstash to use HTTPS when talking to Elasticsearch as well. This can be configured in the `elasticsearch` output section of the `logstash.conf`:

```
output {
    elasticsearch {
       ...
       ssl => true
       ssl_certificate_verification => true
       truststore => "/path/to/elasticsearch-2.3.3/config/truststore.jks"
       truststore_password => changeit
    }
}
```
Setting `ssl` to true ensures that logstash uses HTTPS.

If you want logstash to verify the certificate it gets back from Elasticsearch / Search Guard (optional, but recommended), set the `ssl_certificate_verification` property to true. Validation here means that logstash verifies the certificate against the certificates configured in a truststore file. In most cases, you will want to put your Root CA that was used to generate the server certificates in the truststore.

This is very similar to configuring the truststore for your Elasticsearch nodes, so if you want to dig deeper into this topic, please refer to the [Search Guard SSL configuration documentation](https://github.com/floragunncom/search-guard-ssl-docs/blob/master/configuration.md).

If you enable certificate validation, you need to provide the absolute path to the truststore, and the truststores password as well:

```
truststore => "/path/to/elasticsearch-2.3.3/config/truststore.jks"
truststore_password => changeit
```

## Configuring the logstash user

Similar to Kibana, logstash needs to authenticate itself when talking to a secured Elasticsearch cluster. So, you need to configure the username and password logstash should use for this. This is also configured in the `elasticsearch` output section of the `logstash.conf`:

```
output {
    elasticsearch {
       user => logstash
       password => logstash
       ...
    }
}
```

You can use any username and password you want, but of course you need to make sure the username and password matches the usernames and passwords configured in your authentication backend.

For example, if you use the internal Search Guard user database, make sure the user exists in the `sg_internal_users.yml` file. The template shipped with Search Guard already contains the respective entry:

```
logstash:
  hash: $2a$12$u1ShR4l4uBS3Uv59Pa2y5.1uQuZBrZtmNfqB3iM/.jL0XoV9sghS2
  #password is: logstash
```

If you use another authenticaton backend, such as LDAP, you need to configure the user and password there.

## Complete logstash configuration

The complete configuration file now should look similar to this:

```
output {
    elasticsearch {
       user => logstash
       password => logstash
       ssl => true
       ssl_certificate_verification => true
       truststore => "/path/to/elasticsearch-2.3.3/config/truststore.jks"
       truststore_password => changeit
    }
}
```

## Setting up permissions for the logstash user

Now you need to assign the correct permissions to the logstash user. The default permissions, which are also used in the sample configuration files, are as follows:

```
sg_logstash:
  cluster:
    - indices:admin/template/get
    - indices:admin/template/put
    - indices:data/write/bulk*  
  indices:
    'logstash-*':
      '*':
        - CRUD
        - CREATE_INDEX
    '*beat*':
      '*':
        - CRUD
        - CREATE_INDEX
```

**The permission indices:data/write/bulk* on cluster level is only required for Logstash 5.**

This config entry assumes that the logstash user is assigned to the role `sg_logstash`. You can set/change this in the file `sg_roles_mapping.yml` if necessary. The user needs the permission to `put` and get `get` templates on cluster level. It also needs to have the permission to create and modify indices starting with `logstash-`, and of course the permission to create, read, update and modify documents in these indices. The `*beat*` entry is necessary if you use any of the beats datashippers.

Please note that the permissions `CRUD` and `CREATE_INDEX` are action groups. An action group is a named set of permissions. Think of action groups as shortcuts. You can find the actual permissions definition for these groups in the file `sg_action_groups.yml`:

```
CRUD:
  - READ
  - WRITE
READ:
  - "indices:data/read*"
WRITE:
  - "indices:data/write*"
CREATE_INDEX:
  - "indices:admin/create"
```