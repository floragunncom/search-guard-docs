---
title: System change tracking
html_title: System change tracking
slug: integrity-elasticsearch
category: auditlog
order: 700
layout: docs
edition: compliance
description: How to use Search Guard to monitor changes in the OpenSearch/Elasticsearch configuration.
---
<!---
Copyright 2020 floragunn GmbH
-->

# System Configuration Change Tracking
{: .no_toc}

{% include toc.md %}

Search Guard is able to monitor the integrity of your OpenSearch/Elasticsearch installation and emit events describing your current configuration.

These features help to detect any changes to your OpenSearch/Elasticsearch or Search Guard installation and for proofing that you applied critical fixes and upgrades in time.

The way OpenSearch/Elasticsearch can be configured includes

* Setting in elasticsearch.yml
* Environment variables used in elasticsearch.yml
* Java properties
* Files used by Search Guard like PEM certificates, keystores or Kerberos keytabs

On node startup, Search Guard will emit an event that contains these settings and their respective sha256 checksum.

## Enabling and disabling configuration tracking

The elasticsearch configuration monitoring can be switched on an off by the following entry in elasticsearch.yml:

| Name | Description |
|---|---|
| searchguard.compliance.history.external\_config\_enabled | boolean, whether to enable or disable elasticsearch configuration logging. Default: true |
{: .config-table}

## Audit log category

The OpenSearch/Elasticsearch configuration events are logged in the `COMPLIANCE_EXTERNAL_CONFIG`category. 

## Field reference

### Format, timestamp and category attributes

| Name | Description |
|---|---|
| audit\_format\_version | Audit log message format version, current: 3|
| audit\_utc\_timestamp | UTC timestamp when the event was generated|
| audit\_category | Audit log category, `COMPLIANCE_EXTERNAL_CONFIG` for all events|
{: .config-table}

### Cluster and node attributes

| Name | Description |
|---|---|
| audit\_cluster\_name | Name of the cluster this event was emitted on.|
| audit\_node\_id  | The ID of the node where the event was generated.|
| audit\_node\_name | The name of the node where the event was generated. |
| audit\_node\_host\_address |The host address of the node where the event was generated.|
| audit\_node\_host\_name |The host address of the node where the event was generated. |
{: .config-table}

### Configuration attributes

| Name | Description |
|---|---|
| audit\_compliance\_file\_infos | All external files referenced in the configuration, with modification date and sha256 checksum.  |
| audit\_request\_body | Detailed configuration information as JSON string.  |
{: .config-table}

## File information

The `audit_compliance_file_infos` key contains an array that lists all files used by Search Guard that are configured in elasticsearch.yml. Example:

```json
"audit_compliance_file_infos" : [
   {
     "path" : "/etc/elasticsearch/truststore.jks",
     "sha256" : "502be6ca9080666271ee9122998e6793e19fda080be095da60bab5aae8243f17",
     "last_modified" : "2018-03-13T12:10:29.000+00:00",
     "key" : "searchguard.ssl.http.truststore_filepath"
   },
   {
     "path" : "/etc/elasticsearch/CN=sgssl-0.example.com,OU=SSL,O=Test,L=Test,C=DE-keystore.jks",
     "sha256" : "9a5058ca0efb0068aeafc307f86d4af48274dab315702e014e1cdaf4bcc32f3b",
     "last_modified" : "2018-03-13T12:10:29.000+00:00",
     "key" : "searchguard.ssl.transport.keystore_filepath"
   },
   {
     "path" : "/etc/elasticsearch/sgssl-0.example.com.http_srv.keytab",
     "sha256" : "bb12b7483d9c449ac27cf6e6c698172bf227dc1ea1892d9e27732071731b9f8c",
     "last_modified" : "2018-03-15T16:27:50.522+00:00",
     "key" : "searchguard.kerberos.acceptor_keytab_filepath"
   }
   ... 
]
```

| Name | Description |
|---|---|
| path | Absolute path to the file |
| sha256 | SHA256 checksum of the file  |
| last_modified | Last modification date of the file  |
| key | The configuration key in elasticsearch.yml this file is referenced by.  |
{: .config-table}

## Configuration information

The detailed configuration settings can be found in the `audit_request_body` field of the generated event. The value is a JSON string with three keys:

| Name | Description |
|---|---|
| external_configuration | The content of the elasticsearch.yml on node startup |
| os_environment | Environment variables on node startup  |
| java_properties | Java properties on node startup  |
| sha256_checksum | SHA256 checksum of the combined external_configuration, os_environment and java_properties. Can be used to detect any changes to your OpenSearch/Elasticsearch installation.  |
{: .config-table}

### External configuration

The `external_configuration` contains the `opensearch.yml`/`elasticsearch.yml` settings on node startup as JSON String. Example:

```json
{
	"external_configuration": {
		"elasticsearch_yml": {
			"searchguard": {
				"compliance": {
					"disable_anonymous_authentication": "true",
					"history": {
						"external_config_enabled": "true",
						"read": {
							"watched_fields": ["humanresources,Designation,FirstName,LastName"],
							"ignore_users": ["admin"]
						},
						"write": {
							"diffs_only": "true",
							"ignore_users": ["finance_trainee"],
							"watched_indices": ["finance"]
						},
						"metadata_only": "false"
					}
				},
				"kerberos": {
					"acceptor_principal": "HTTP/sgssl-0.example.com",
					"krb5_filepath": "/etc/krb5.conf",
					"acceptor_keytab_filepath": "sgssl-0.example.com.http_srv.keytab"
				},
				...
			}
		}
	}
}
```

Since the JSON object is stored as String, the quotation marks are escaped in the original output. Depending on your JSON parser you might need to remove them first.
{: .note .js-note .note-warning}

### Environment variables

The `os_environment` key contains all environment variables as String. Example:

```
"LANGUAGE=en_US:en, 
PATH=/usr/share/elasticsearch/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:
-Dsun.security.krb5.debug=false
-Dsun.security.spnego.debug=false
..."
```

### Java properties

The `java_environment` key contains all java properties as String. Example:

```
"java.version=1.8.0_151
java.vendor.url=http://java.oracle.com/
-Enetwork.host=sgssl-0.example.com
-Esearchguard.ssl.http.keystore_filepath=keystore.jks
-Esearchguard.kerberos.acceptor_keytab_filepath=sgssl-0.example.com.http_srv.keytab
..."
```