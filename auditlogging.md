<!---
Copryight 2016 floragunn GmbH
-->

# Audit Logging

Audit logging enables you to track access to your Elasticsearch cluster. Search Guard tracks the following types of events, on REST- and transport level:

* SSL_EXCEPTION
 * An attempt was made to access Elasticsearch without a valid SSL/TLS certificate.
* BAD_HEADERS
 * An attempt was made to spoof a request to Elasticsearch with Search Guard internal headers
* FAILED_LOGIN
 *  The provided credentials of a request could not be validated, most likely because the user does not exist or the password is incorrect. 
* MISSING_PRIVILEGES
 * An attempt was made to access Elasticsearch, but the authenticated user lacks the respective privileges for the requested action
* SG\_INDEX\_ATTEMPT
 * An attempt was made to access the Search Guard internal user- and privileges index without a valid admin TLS certificate 
* AUTHENTICATED
 * Represents a successful request to Elasticsearch 

All events are logged asynchronously, so the audit log has only minimal impact on the performance of your cluster. You can tune the number of threads that Search Guard uses for audit logging, see chapter "Finetuning the thread pool" below.
  
For security reasons, audit logging has to be configured in `elasticsearch.yml`, not in `sg_config.yml`. Thus, changes to the audit log settings require a restart of all participating nodes in the cluster.
  
## Enabling audit logging

In order to enable audit logging, download the jar file from [Maven](http://search.maven.org/#search%7Cga%7C1%7Ca%3A%22dlic-search-guard-module-auditlog%22), and put it in the following folder: `<ES installation directory>/plugins/search-guard-2` or `<ES installation directory>/plugins/search-guard-5`

## Configuring audit logging

### Configuring the categories to be logged

Per default, the audit log module logs all events in all categories. If you want to log only certain events, you can disable categories individually in the `elasticsearch.yml` configuration file:

```
searchguard.audit.config.disabled_categories: [disabled categories]
```

For example:

```
searchguard.audit.config.disabled_categories: AUTHENTICATED, SG_INDEX_ATTEMPT
```

In this case, events in the categories `AUTHENTICATED` and `SG_INDEX_ATTEMPT` will not be logged.

### Configuring the log level

By default, Search Guard logs a reasonable amount of information for each audit log event, suitable for identifying attempted security breaches. This includes the audit category, user information, source IP, date, reason etc.

Search Guard also provides an extended log format, which includes the requested index (including composite index requests), and the query that was being submitted. This extended logging can be enabled and disabled by setting:

```
searchguard.audit.enable_request_details: <boolean>
```

Since this extended logging comes with an performance overhead, the default setting is `false`.

### Configuring the storage type

Search guard comes with three audit log storage types built in. This specifies where you want to store the tracked events. You can choose from:

* debug
 * Outputs the events on standard out
* internal_elasticsearch
 * Writes the events in a separate audit index on the same cluster
* external_elasticsearch
 * Writes the events in a separate audit index on another ES cluster
* webhook
 * Writes the events to an arbitrary HTTP endpoint

You configure the type of audit logging in the `elasticsearch.yml` file:

```
searchguard.audit.type: <debug|internal_elasticsearch|external_elasticsearch|webhook>
```

Note that it is not possible to specify more than one storage type at the moment.

You can also use your own, custom implementation of the storage, in case you have special requirements that are not covered by the built-in types. See chapter "Custom storage types" below.

## Storage type 'debug'

There are no special configuration settings for this audit type, so you just add the audit type setting in `elasticsearch.yml`:

```
searchguard.audit.type: debug
```  

This will output all tracked events on standard out.

## Storage type 'internal_elasticsearch'

In addition to specifying the type as `internal_elasticsearch`, you can set the index name and the document type to be used:

```
searchguard.audit.type: internal_elasticsearch
searchguard.audit.config.index: <indexname>
searchguard.audit.config.type: <typename>
``` 

If not specified, Search Guard uses the default value `auditlog` for both index name and document type.

## Storage type 'external_elasticsearch'

If you want to store the tracked events in a different Elasticsearch cluster than the cluster producing the events, you use `external_elasticsearch` as audit type, configure the Elasticsearch endpoints with hostname/IP and port, and optionally the index name and document type:

```
searchguard.audit.type: internal_elasticsearch
searchguard.audit.config.http_endpoints: <endpoints>
searchguard.audit.config.index: <indexname>
searchguard.audit.config.type: <typename>
``` 

SearchGuard uses the REST-API to send the tracked events, so for `searchguard.audit.config.http_endpoints`, use a comma-separated list of hostname/IP and the REST port (default 9200). For example:

```
searchguard.audit.config.http_endpoints: 192.168.178.1:9200,192.168.178.2:9200
```

### Storing audit logs in a Search Guard secured cluster

If you use `external_elasticsearch` as audit type, and the cluster you want to store the audit logs in is also secured by Search Guard, you need to supply some additional configuration parameters.

The parameters you need to specify depends on what authentication type you configured on the REST layer.

### TLS settings

Use the following settings to control SSL/TLS:

```
searchguard.audit.config.enable_ssl: <true|false>
```
Whether or not to use SSL/TLS. If you enabled SSL/TLS on the REST-layer of the receiving cluster, set this to true. Default is false.

```
searchguard.audit.config.verify_hostnames: <true|false>
```
Whether or not to verify the hostname of the SSL/TLS certificate of the receiving cluster. Default is true.

```
searchguard.audit.config.enable_ssl_client_auth: <true|false>
```
Whether or not to enable SSL/TLS client authentication. If you set this to true, the audit log module will send the nodes certificate from the keystore along with the request. The receiving cluster can use this certificate to verify the identity of the caller.

Note: The audit log module will use the key- and truststore settings configured in the HTTP/REST layer SSL section of the elasticsearch.yml file. Please refer to the [Search Guard SSL](https://github.com/floragunncom/search-guard-ssl-docs/blob/master/configuration.md) configuration chapter for more information.

### Basic auth settings

If you enabled HTTP Basic auth on the receiving cluster, use these settings to specify username and password the the audit log module should use:

```
searchguard.audit.config.username: <username>
searchguard.audit.config.password: <password>
```

## Storage type 'webhook'

This storage type ships the audit log events to an arbitrary HTTP endpoint. Enable this storage type adding the following to `elasticsearch.yml:`

```
searchguard.audit.type: webhook
``` 

In addition, you can configure the following keys:

```
searchguard.audit.config.webhook.url: <string>
```
The URL that the log events are shipped to. Can be an HTTP or HTTPS URL.

```
webhook.ssl.verify: <boolean>
```

If true, the TLS certificate provided by the endpoint (if any) will be verified. If set to false, no verification is performed. You can disable this check if you use self-signed certificates for example.

```
webhook.format: <URL_PARAMETER_GET|URL_PARAMETER_POST|TEXT|JSON|SLACK>
```

The format in which the audit log message is logged:

**URL\_PARAMETER\_GET**
 
The audit log message is submitted to the configured webhook URL as HTTP GET. All logged information is appended to the URL as request parameters.

**URL\_PARAMETER\_POST**

The audit log message is submitted to the configured webhook URL as HTTP POST. All logged information is appended to the URL as request parameters.

**TEXT**

The audit log message is submitted to the configured webhook URL as HTTP POST. The body of the HTTP POST request contains the audit log message in plain text format.

**JSON**

The audit log message is submitted to the configured webhook URL as HTTP POST. The body of the HTTP POST request contains the audit log message in JSON format.

**SLACK**

The audit log message is submitted to the configured webhook URL as HTTP POST. The body of the HTTP POST request contains the audit log message in JSON format suitable for consumption by Slack. The default implementation returns `"text": "<AuditMessage#toText>"`

### Customizing the audit log event format

If you need to provide the audit log event in a special format, suitable for consumption by your SIEM system for example, you can subclass the `com.floragunn.searchguard.auditlog.impl.WebhookAuditLog` class and configure it as custom storage type (see below).

The relevant methods are:

```
protected String formatJson(final AuditMessage msg) {
  return ...
}
```

This method is called when the webhook format is set to JSON.

```
protected String formatText(final AuditMessage msg) {
  return ...
}
```

This method is called when the webhook format is set to TEXT.

```
protected String formatUrlParameters(final AuditMessage msg) {
  return ...
}
```

This method is called when using URL\_PARAMETER\_GET or URL\_PARAMETER\_POST as webhook format.

## Custom storage types

If you have special requirements regarding the storage, you can always implement your own storage type and let the audit log module use it instead of the built in types.

### Implementing a custom storage

Implementing a custom storage is very easy. You just write a class with **a default constructor** that extends `com.floragunn.searchguard.auditlog.impl.AbstractAuditLog`. You need to implement only two methods:

```
protected void save(final AuditMessage msg) {
}

public void close() throws IOException {
}
```

The `save` method is responsible for storing the event to whatever storage you require. The interface `AuditLog` also extends `java.io.Closeable`. If the node is shut down, this method is called, and you can use it to close any resources you have aquired. For example, the `HttpESAuditLog` uses it to close the connection to the remote ES cluster.

### Configuring a custom storage

In order for Search Guard to pick up your custom implementation, specify its fully qualified name as `searchguard.audit.type`:

```
searchguard.audit.type: com.example.MyCustomAuditLogStorage
``` 

Make sure that the class is accessible by Search Guard by putting the respective `jar` file in the `plugins/search-guard-2` or `plugins/search-guard-5` folder.


## Advanced settings: Finetuning the thread pool

All events are logged asynchronously, so the overall performance of our cluster will only be affected minimally. Search Guard internally uses a fixed thread pool to submit log events. You can define the number of threads in the pool by the following configuration key in `elasticsearch.yml`:

```
searchguard.audit.threadpool.size: <integer>
```

The default setting is `10`. Setting this value to `0` disableds the thread pool completey, and the events are logged synchronously. 